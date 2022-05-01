
import requests
import json
import math
import os

from .professor import Professor

"""
This is an example of how to find Walker White

from ratemyprof_api import ratemyprof_api
CornellUniversity = ratemyprof_api.RateMyProfApi(298) 
CornellUniversity.get_professor_by_name("White")
"""

class RateMyProfApi:
    def __init__(self, school_id: str = "1074", testing: bool = False):
        """
        Initializes object of RateMyProfAPI
        """
        self.UniversityId = school_id
        if not os.path.exists("SchoolID_" + str(self.UniversityId)):
            os.mkdir("SchoolID_" + str(self.UniversityId))

        # dict of Professor
        self.professors= self.scrape_professors(testing)
        self.indexnumber = False

    def scrape_professors(
        self,
        testing: bool = False
    ):  
        """
        Creates List object that includes basic information on all professors from the IDed University
        """
        professors = dict()
        num_of_prof = self.get_num_of_professors(self.UniversityId)
        num_of_pages = math.ceil(num_of_prof / 20)

        for i in range(1, num_of_pages + 1):  # the loop insert all professor into list
            page = requests.get(
                "http://www.ratemyprofessors.com/filter/professor/?&page="
                + str(i)
                + "&filter=teacherlastname_sort_s+asc&query=*%3A*&queryoption=TEACHER&queryBy=schoolId&sid="
                + str(self.UniversityId)
            )
            json_response = json.loads(page.content)

            for json_professor in json_response["professors"]:
                professor = Professor(
                    json_professor["tid"],
                    json_professor["tFname"],
                    json_professor["tLname"],
                    json_professor["tNumRatings"],
                    json_professor["overall_rating"])

                professors[professor.ratemyprof_id] = professor

            # for test cases, limit to 2 iterations
            if testing and (i > 1): break

        return professors
    
    def get_num_of_professors(
        self, id
    ):  # function returns the number of professors in the university of the given ID.
        page = requests.get(
        "http://www.ratemyprofessors.com/filter/professor/?&page=1&filter=teacherlastname_sort_s+asc&query=*%3A*&queryoption=TEACHER&queryBy=schoolId&sid="
        + str(id)
    )  # get request for page
        temp_jsonpage = json.loads(page.content)
        num_of_prof = (
            temp_jsonpage["remaining"] + 20
        )  # get the number of professors at William Paterson University
        return num_of_prof

    def get_professor_by_name(
        self, first_name, last_name
    ):
        '''
        Return the first professor with the matching name.
        Case insenstive.
        '''
        last_name = last_name.lower()
        first_name = first_name.lower()
        for professor in self.professors.values():
            if first_name == professor.first_name.lower() and last_name == professor.last_name.lower():
                return professor
        return None
