import json
from flask import Flask
from flask import request
from db import db
from db import Course
from db import User
from db import Professor
from ratemyprof_api import ratemyprof_api 
import requests


app = Flask(__name__)
db_filename = "data.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.drop_all() ## remove it later
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
        rating = 0
    else:
        rating = prof.overall_rating
    return {
        "first_name": first_name,
        "last_name": last_name,
        "rating": rating
    }

def get_professor(course):
    """
    Helper function that returns list of professors given course.
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

def set_up_all_courses():
    """
    Adds all of the courses of the last four years to the Course table
    """
    #Cornell_University = ratemyprof_api.RateMyProfApi(298) 
    rosters = get_rosters()
    for count in range(len(rosters)-1, 0, -1):
        roster = rosters[count]
        subjects = get_subjects(roster)
        for subject in subjects:
            courses = get_courses(roster, subject)
            for course in courses:
                prev_course = Course.query.filter_by(title=course["title"]).first()
                if prev_course == None and course["description"] != None and course["breadth"] != None and course["distribution"] != None:
                    rating = get_course_rating(course["subject"].lower(), course["number"])
                    new_course = Course(
                        subject = course["subject"],
                        number = course["number"],
                        title = course["title"],
                        description = course["description"],
                        breadth = course["breadth"],
                        distribution = course["distribution"],
                        workload = rating["workload"],
                        difficulty = rating["difficulty"],
                        rating = rating["rating"]
                        )
                    #for prof in course["professors"]:
                    #    prev_prof = Professor.query.filter_by(first_name=prof[0],last_name=prof[1]).first()
                    #    if(prev_prof == None):
                    #        prev_prof = Professor(first_name=prof[0],
                    #                    last_name=prof[1],
                    #                    rating=get_professor_rating(Cornell_University,prof[0],prof[1]))
                    #    new_course.professors.append(prev_prof) ### Does this add prof????
                    db.session.add(new_course)
    db.session.commit()

@app.route("/courses/")
def get_all_courses():
    """
    Endpoint for getting all courses
    """
    set_up_all_courses()
    return json.dumps({"courses": [c.serialize() for c in Course.query.all()]})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)