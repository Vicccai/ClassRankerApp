import json
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
    if results == None:
        return {
            "difficulty": 0.0,
            "rating": 0.0,
            "workload": 0.0
        }
    difficulty = results.get("classDifficulty")
    if(difficulty == None):
        difficulty = "0"
    rating = results.get("classRating")
    if(rating == "" or rating == None):
        rating = "0"
    workload = results.get("classWorkload")
    if(workload == None):
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
    if prof == None:
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
        if course["catalogBreadth"] != "" and course["catalogDistr"] != "":
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
            if(prev_prof == None):
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
            if(prev_breadth == None):
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
            if(prev_distribution == None):
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
                if course["description"] != None and course["breadth"] != None and course["distribution"] != None:
                    rating = get_course_rating(course["subject"].lower(), course["number"])
                    if prev_course == None:
                        new_course = Course(
                            subject = course["subject"],
                            number = course["number"],
                            title = course["title"],
                            description = course["description"],
                            workload = rating["workload"],
                            difficulty = rating["difficulty"],
                            rating = rating["rating"]
                            )
                        add_professors_to_course(new_course, course["professors"], Cornell_University)
                        add_breadths_to_course(new_course, course["breadth"])
                        add_distributions_to_course(new_course, course["distribution"])
                        db.session.add(new_course)
                    else:
                        prev_course.description = course["description"]
                        prev_course.workload = rating["workload"]
                        prev_course.difficulty = rating["difficulty"]
                        prev_course.rating = rating["rating"]
                        add_professors_to_course(prev_course, course["professors"], Cornell_University)
                        add_breadths_to_course(prev_course, course["breadth"])
                        add_distributions_to_course(prev_course, course["distribution"])
                    db.session.commit()

### add an endpoints for query course by name, distribution, breadth, prof, difficulty etc

### add method for sorting the courses

### add endpoints for adding and deleting favorite courses and comments

### add endpoints for authentication

@app.route("/courses/")
def get_all_courses():
    """
    Endpoint for getting all courses
    """
    return json.dumps({"courses": [c.serialize() for c in Course.query.all()]})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
