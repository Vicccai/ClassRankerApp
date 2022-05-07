# Class Rooster
Feeling lost? Tired of swapping tabs? Don't wing it with Class Rooster!

# Description
Imagine this: you're looking for a course to fullfil an SMR-AS requirement, but nothing seems to match your interests. You've only combed through 30 of the 65 results on Course Roster and you've already opened 5 tabs of CUReviews and 6 tabs of RateMyProfessor. Preferably, the class you're looking for is easy—since math isn't exactly your strong suit—but you also want a rewarding experience overall. How much long will it take to find this class? Hours? Not if you use Class Rooster! With Class Rooster, we've optimized this process to find your dream class within a couple of simple clicks. You can filter courses by level, requirements, rating, difficulty, workload and popularity. These filters can even be mixed and matched to find the perfect class for yourself. You can also favorite courses and leave comments. All of these features come packaged within a seamless user interface that we know you will become very familiar with. Remember, there's no need to wing course registration with Class Rooster!

Members: 
Jordan Han (Back-end),
Bryan Lee (Back-end),
Luke Leh (Design),
Victor Cai (Front-end),
Mariana Meriles (Front-end),
Young Zheng (Back-end)

# Screenshots

# Front-end Implementation

# Back-end Implementation
* Developed using Flask, SQLAlchemy and Python
* Tested using Postman
* Scraped [CUReviews](https://www.cureviews.org/), [RateMyProfessors](https://www.ratemyprofessors.com/) and utilized Cornell Course Roster API to generate data for Course, Breadth, Distribution and Professor tables
* Added a many-to-many relationship to User and Course, Professor and Course, Breadth and Course, Distribution and Course tables.
* Created endpoint to routinely update tables with new data from CUReviews, RateMyProf and Corenll Course Roster API
* Created endpoints for user addition and deletion of favorite courses and comments
* Implemented http token authentication with bcrypt library
* Containzerization with Docker and deployed using Google Cloud virtual machine

# Product Design

# Future goals 

Credit: 
Thank you tisuela for [ratemyprof-api](https://github.com/tisuela/ratemyprof-api) and Cornell DTI for letting us scrape CUReviews
