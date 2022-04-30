import json
from flask import Flask
from flask import request
import requests

from ratemyprof_api import ratemyprof_api
CornellUniversity = ratemyprof_api.RateMyProfApi(298)  

app = Flask(__name__)

def failure_response(message, code=404):
    return json.dumps({"success": False, "error": message}), code

@app.route("/ratings/<string:subject>/<int:number>/")
def get_course_rating(subject, number):
    """
    Given subject (CS, ENGL, etc.) and number (1110, 4820, etc.) gives the difficulty of the class from CUReviews
    """
    body = {"number":number, "subject":subject}
    uri = "https://www.cureviews.org/v2/getCourseByInfo"
    reqResponse = requests.post(url=uri, json=body)
    results = reqResponse.json()["result"]
    ratings = {
        "difficulty": results["classDifficulty"],
        "rating": results["classRating"],
        "workload": results["classWorkload"]
    }
    return json.dumps(ratings), 200

@app.route("/prof/<string:first_name>/<string:last_name>/")
def get_professor_rating(first_name, last_name):
    """
    Given first and last name, gives professor name and rating
    """
    prof = CornellUniversity.get_professor_by_name(first_name, last_name)
    prof_json = {
        "name": prof.name,
        "rating": prof.overall_rating
    }
    return json.dumps(prof_json), 200

@app.route("/courses/<string:roster>/<string:subject>/")
def get_courses_by_subject(roster, subject):
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
                "number": course["catalogNbr"],
                "title": course["titleLong"],
                "breadth": course["catalogBreadth"],
                "distr": course["catalogDistr"]
            }
        )

    return json.dumps(course_list), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)