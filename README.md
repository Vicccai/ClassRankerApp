# Class Rooster
Feeling lost? Tired of swapping tabs? Don't wing it. Use Course Rooster!

# Description
Imagine this: you're looking for a course to fulfill a requirement, but nothing seems to match your interests. You've looked through 30 out of 65 results on Course Roster and you've already opened 10 syllabuses and 7 CUReviews tabs. Preferably, the class you're looking for is easy, but you also want a rewarding experience overall. How much long will it take to find this class? Hours? Not if you use Class Rooster! With Class Rooster, we've optimized this process to find your dream class within a couple of simple clicks. You can filter courses by level, requirements, rating, difficulty, and workload. These filters can be mixed and matched and you can even favorite these courses or leave comments. All of these features come packaged within a seamless user interface that we know you will become very familiar with. Remember, there's no need to wing course registration with Class Rooster!

Members: 
Jordan Han (Back-end),
Bryan Lee (Back-end),
Luke Leh (Design),
Victor Cai (Front-end),
Mariana Meriles (Front-end),
Young Zheng (Back-end)

# Screenshots
To be added... 

# Front-end Implementation
To be added...

# Back-end Implementation
* Developed using Flask, SQLAlchemy and Python
* Tested using Postman
* Scraped [CUReviews](https://www.cureviews.org/) and utilized Cornell [Class Roster](https://classes.cornell.edu/browse/roster/FA22) API to generate data for Course, Breadth, Distribution and Professor tables
* Added one-to-many relationship to User and Comment tables and many-to-many relationships to User and Course, Professor and Course, Breadth and Course, and Distribution and Course tables
* Optimized filter times using pre-sorted tables; lowered search time on Google Cloud's e2-small vm from 7-8 seconds to <1 sec
* Created endpoint to routinely update tables with new data from [CUReviews](https://www.cureviews.org/) and Cornell [Class Roster](https://classes.cornell.edu/browse/roster/FA22) API
* Created endpoints for user addition and deletion of favorite courses and comments
* Implemented http token authentication with bcrypt library
* Containerized with Docker and deployed using Google Cloud virtual machine

# Credits
Thank you Cornell DTI for letting us scrape CUReviews
