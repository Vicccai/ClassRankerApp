# Class Rooster
Feeling lost? Tired of swapping tabs? Don't wing it. Use Course Rooster!

# Description
Imagine this: you're looking for a course to fulfill a requirement, but nothing seems to match your interests. You've looked through 30 out of 65 results on Course Roster and you've already opened 10 syllabuses and 7 CUReviews tabs. Preferably, the class you're looking for is easy, but you also want a rewarding experience overall. How much long will it take to find this class? Hours? Not if you use Class Rooster! With Class Rooster, we've optimized this process to find your dream class within a couple of simple clicks. You can filter courses by level, requirements, rating, difficulty, and workload. These filters can be mixed and matched and you can even favorite these courses or leave comments. There's no need to wing course registration with Class Rooster!

Members: 
Young Zheng (full stack),
Jordan Han (back end),
Bryan Lee (back end),
Luke Leh (product design),
Victor Cai (front end),
Mariana Meriles (front end)

# Screenshots
To be added... 

# Front-end Implemention
* Developed using Swift, SwiftUI and UIKit
* Utilized Alamofire, IQKeyboardManagerSwift and iOSDropDown with CocoaPods
* Features 
  * Search bar based on course title
  * Filter by college, course level, distribution
  * Sort by course rating, which include overall, difficulty and workload
  * User and Guest login
  * Favorite courses, display all favorites, and search favorites
  * Discussion forums for every course
  * Each course contains its rating and description

# Back-end Implementation
* Developed using Flask, SQLAlchemy and Python
* Tested using Postman
* Scraped [CUReviews](https://www.cureviews.org/) and utilized Cornell [Class Roster](https://classes.cornell.edu/browse/roster/FA22) API to generate data for Course, Breadth, Distribution and Professor tables
* Added one-to-many relationship to User and Comment tables and many-to-many relationships to User and Course, Professor and Course, Breadth and Course, and Distribution and Course tables
* Optimized filter times using pre-sorted tables; reduced search time on Google Cloud's e2-small vm from 6-7 seconds to <2 sec
* Created endpoint to routinely update tables with new data from [CUReviews](https://www.cureviews.org/) and Cornell [Class Roster](https://classes.cornell.edu/browse/roster/FA22) API
* Implemented http token authentication with bcrypt library
* Containerized with Docker and deployed using Google Cloud virtual machine

# Credits
Thank you Cornell DTI for letting us scrape CUReviews and Cornell University for access to the Class Roster API. Also thank you Gonzalo Gonzalez for being the best mentor ever!
