import json
import math
from msilib.schema import Error
from re import M
from flask import Flask
from flask import request
from db import db
from db import Course
from db import User
from db import Professor
from db import Comment
from db import Breadth
from db import Distribution
from ratemyprof_api import ratemyprof_api 
import requests


app = Flask(__name__)
db_filename = "data.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():  
    db.create_all()

def failure_response(message, code=404):
    return json.dumps({"success": False, "error": message}), code

def get_rosters():
    """
    Gives last 4 of the available rosters (FA22, SP20 etc)
    """
    uri = "https://classes.cornell.edu/api/2.0/config/rosters.json"
    reqResponse = requests.get(url=uri)
    rosters = reqResponse.json()["data"]["rosters"]
    roster_list = []
    for roster in rosters:
        roster_list.append(roster["slug"])
    roster_list = roster_list[len(roster_list)-5:]
    return roster_list

def get_subjects(roster):
    """
    Gives all of the subjects of a given roster in a list
    """
    uri = "https://classes.cornell.edu/api/2.0/config/subjects.json?roster=" + roster 
    reqResponse = requests.get(url=uri)
    subjects = reqResponse.json()["data"]["subjects"]
    subject_list = []
    for subject in subjects:
        subject_list.append(subject["value"])
    return subject_list

def get_course_rating(subject, number):
    """
    Given subject (cs, engl, etc.) and number (1110, 4820, etc.) gives the difficulty of the class from CUReviews
    """
    body = {"number":number, "subject":subject}
    uri = "https://www.cureviews.org/v2/getCourseByInfo"
    reqResponse = requests.post(url=uri, json=body)
    results = reqResponse.json()["result"]
    if results is None:
        return {
            "difficulty": 0.0,
            "rating": 0.0,
            "workload": 0.0
        }
    difficulty = results.get("classDifficulty")
    if(difficulty is None):
        difficulty = "0"
    rating = results.get("classRating")
    if(rating == "" or rating is None):
        rating = "0"
    workload = results.get("classWorkload")
    if(workload is None):
        workload = "0"
    ratings = {
        "difficulty": float(difficulty),
        "rating": float(rating),
        "workload": float(workload)
    }
    return ratings

def get_professor_rating(Cornell_University, first_name, last_name):
    """
    Given first and last name, gives professor name and rating
    """
    prof = Cornell_University.get_professor_by_name(first_name, last_name)
    if prof is None:
        rating = 0.0
    else:
        rating = prof.overall_rating
    return rating

def get_professor(course):
    """
    Given course returns a list of professors.
    """
    meetings = course["enrollGroups"][0]["classSections"][0]["meetings"]
    if len(meetings) == 0:
        return []
    instructors = meetings[0]["instructors"]
    if len(instructors) == 0:
        return []
    prof_list = []
    for prof in instructors:
        prof_list.append([prof["firstName"], prof["lastName"]])
    return prof_list

def get_courses(roster, subject):
    """
    Given roster (FA22, SP20, etc.) and subject (CS, ENGL, etc.) gives important information about the course
    """
    uri = "https://classes.cornell.edu/api/2.0/search/classes.json?roster=" + roster + "&subject=" + subject
    reqResponse = requests.get(url=uri)
    classes = reqResponse.json()["data"]["classes"]
    course_list = []
    for course in classes:
        course_list.append(
            {
                "subject": course["subject"],
                "number": int(course["catalogNbr"]),
                "title": course["titleLong"],
                "description": course["description"],
                "breadth": course["catalogBreadth"],
                "distribution": course["catalogDistr"],
                "professors": get_professor(course)
            }
        )
    return course_list

def convert_to_list(dist):
    """
    Helper method to convert distribution and breadth into a list format
    """
    if dist == "":
        return []
    i = 1
    list = []
    while(dist.find(",", i) != -1):
        list += [dist[i: dist.find(",", i)].strip()]
        i = dist.find(",", i)+1
    list += [dist[i:-1].strip()]
    return list

def add_professors_to_course(course, professors, Cornell_University):
    """
    Given list of professors adds them to the course 
    """
    for prof in professors:
        found = False
        for course_prof in course.professors:
            if(course_prof.first_name == prof[0] and course_prof.last_name == prof[1]):
                found = True
        if(not found):
            prev_prof = Professor.query.filter_by(first_name=prof[0],last_name=prof[1]).first()
            if(prev_prof is None):
                prev_prof = Professor(first_name=prof[0],
                    last_name=prof[1],
                    rating=get_professor_rating(Cornell_University,prof[0],prof[1]))
            course.professors.append(prev_prof) 

def add_breadths_to_course(course, breadths):
    """
    Given strings of breadths, add them to the course
    """
    breadth_list = convert_to_list(breadths)
    for breadth in breadth_list:
        found = False
        for course_breadth in course.breadths:
            if(course_breadth.name == breadth):
                found = True
        if(not found):
            prev_breadth = Breadth.query.filter_by(name=breadth).first()
            if(prev_breadth is None):
                prev_breadth = Breadth(name=breadth)
            course.breadths.append(prev_breadth)

def add_distributions_to_course(course, distributions):
    """
    Given strings of distributions, add them to the course
    """
    distribution_list = convert_to_list(distributions)
    for distribution in distribution_list:
        found = False
        for course_distribution in course.distributions:
            if(course_distribution.name == distribution):
                found = True
        if(not found):
            prev_distribution = Distribution.query.filter_by(name=distribution).first()
            if(prev_distribution is None):
                prev_distribution = Distribution(name=distribution)
            course.distributions.append(prev_distribution)

@app.route("/setup_update/")
def set_up_and_update_courses():
    """
    Adds and updates all of the courses of the last four semesters to the Course table. 
    """
    Professor.query.delete()
    Breadth.query.delete()
    Distribution.query.delete()
    Cornell_University = ratemyprof_api.RateMyProfApi(298) 
    rosters = get_rosters()
    for roster in rosters:
        subjects = get_subjects(roster)
        for subject in subjects:
            courses = get_courses(roster, subject)
            for course in courses:
                prev_course = Course.query.filter_by(title=course["title"]).first()
                description = course["description"] if course["description"] is not None else "No Description."
                breadth = course["breadth"] if course["breadth"] is not None else ""
                distribution = course["distribution"] if course["distribution"] is not None else ""
                rating = get_course_rating(course["subject"].lower(), course["number"])
                if prev_course is None:
                    new_course = Course(
                        subject = course["subject"],
                        number = course["number"],
                        title = course["title"],
                        description = description,
                        workload = rating["workload"],
                        difficulty = rating["difficulty"],
                        rating = rating["rating"]
                        )
                    add_professors_to_course(new_course, course["professors"], Cornell_University)
                    add_breadths_to_course(new_course, breadth)
                    add_distributions_to_course(new_course, distribution)
                    db.session.add(new_course)
                else:
                    prev_course.description = description
                    prev_course.workload = rating["workload"]
                    prev_course.difficulty = rating["difficulty"]
                    prev_course.rating = rating["rating"]
                    add_professors_to_course(prev_course, course["professors"], Cornell_University)
                    add_breadths_to_course(prev_course, breadth)
                    add_distributions_to_course(prev_course, distribution)
                db.session.commit()
    return json.dumps({"courses": [c.serialize() for c in Course.query.all()]})

def list_helper(bord, c):
    """
    helper function for finding breadths and distributions in courses 
    """
    for b in bord:
        if len(c) == 0:
            return False
        contain = False
        for r in c:
            if b == r.name:
                contain = True
        if not contain:
            return False
    return True 

def sort_by_rating(course):
    rating = course.rating
    return rating if rating > 0 else -1

def sort_by_difficulty(course):
    difficulty = course.difficulty
    return difficulty if difficulty > 0 else 6

def sort_by_workload(course):
    workload = course.workload
    return workload if workload > 0 else 6

def sort_by_users(course):
    return len(course.users)

def sort_by_prof(course):
    professors = course.professors
    avg_rating = 0
    total = 0
    for prof in professors:
        rating = prof.rating
        if rating > 0:
            avg_rating += rating
            total += 1
    if total == 0:
        return -1
    return avg_rating / total

def sort_by_prof_and_rating(course):
    rating = sort_by_rating(course)
    if rating == -1:
        rating = 0
    prof_rating = sort_by_prof(course)
    if prof_rating == -1:
        prof_rating = 0
    return rating + prof_rating

@app.route("/courses/attributes/", methods = ["POST"])
def get_sorted_courses():
    """
    Takes in a JSON dictionary and it is an endpoint for getting courses sorted by the listed attributes.
     
    For the subject attribute, it can be the empty string if there is no specified subject
    For the level attribute, it can be 0 if there is no specified level, else it will be X000
    For the breadth and distribution attribute, it can be the empty list if there is no specified elements
    For the sort attribute, it can sorted 4 different ways, input can be 1, 2, 3, 4:
        1 is sorting by best to worst rating
        2 is sorting by least to most difficulty
        3 is sorting by least to most workload
        4 is sorting by most to least favorites
        5 is sorting by best to worst overall professor rating
        6 is sorted by professors and ratings
    """
    body = json.loads(request.data)
    subject = body.get("subject")
    level = body.get("level")
    breadth = body.get("breadth")
    distribution = body.get("distribution")
    sort = body.get("sort")
    if subject is None or level is None or breadth is None or distribution is None or sort is None:
        return failure_response("Required field(s) not supplied.", 400)
    if not isinstance(sort, int) or sort < 1 or sort > 6:
        return failure_response("Invalid input for sort.", 400)
    course_list = []
    for c in Course.query.all():
        if c.subject == subject or subject == "":
            print(c.number)
            if math.floor(c.number / 1000) == math.floor(level / 1000) or level == 0:
                if list_helper(breadth, c.breadths) and list_helper(distribution, c.distributions):
                    course_list.append(c)
    if sort == 6:
        course_list.sort(reverse=True, key=sort_by_prof_and_rating)
    elif sort == 5:
        course_list.sort(reverse=True, key=sort_by_prof)
    elif sort == 4:
        course_list.sort(reverse=True, key=sort_by_users)
    elif sort == 2:
        course_list.sort(key=sort_by_difficulty)
    elif sort == 3:
        course_list.sort(key=sort_by_workload)
    else:
        course_list.sort(reverse=True, key=sort_by_rating)
    return json.dumps({"courses": [c.serialize() for c in course_list]})
    
### add method for sorting the courses

### add endpoints for adding and deleting favorite courses and comments
@app.route("/comments/<int:course_id/")
def get_comments_by_course(course_id):
    """
    Endpoint for retrieving comments by course id 
    """
    course = Course.query.filter_by(id= course_id).first()
    return json.dumps({"comments": [c.serialize() for c in course]})

@app.route("/comments/", methods = ["POST"])
def post_comments(): 
    """
    Endpoint for posting comments to a course
    """
    body = json.loads(request.data)
    course_id = body.get("course_id")
    description = body.get("description")
    user_id = body.get("user_id")
    if course_id is None or description is None or user_id is None:
        return failure_response("Required field(s) not supplied.", 400)
    if description == "":
        return failure_response("Description must be provided.", 400)

    course = Course.query.filter_by(id= course_id).first()
    new_comment = Comment(
        course_id= course_id, 
        user_id = user_id,
        description = description
    )
    db.session.add(new_comment)
    db.session.commit()
    return json.dumps(new_comment.serialize()), 201


@app.route("/comments/<int:comment_id>", methods = ["DELETE"])
def delete_comments(comment_id):
    """
    Endpoint for deleting comments 
    """
    comment = Comment.query.filter_by(id= comment_id).first()
    if comment is None:
        return failure_response("Comment not found.", 404)
    db.session.delete(comment)
    db.session.commit()
    return json.dumps(comment.serialize()), 200



    

### add endpoints for authentication

@app.route("/courses/")
def get_all_courses():
    """
    Endpoint for getting all courses
    """
    return json.dumps({"courses": [c.serialize() for c in Course.query.all()]})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
