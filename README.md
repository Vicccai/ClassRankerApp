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
![image](https://user-images.githubusercontent.com/69128074/167240728-15605884-3e37-458d-8def-e990fbb4304b.png)

# Front-end Implementation

# Back-end Implementation
* Developed using Flask, SQLAlchemy and Python
* Tested using Postman
* Scraped [CUReviews](https://www.cureviews.org/), [RateMyProfessors](https://www.ratemyprofessors.com/) and utilized Cornell Course Roster API to generate data for Course, Breadth, Distribution and Professor tables
* Added a many-to-many relationship to User and Course, Professor and Course, Breadth and Course, Distribution and Course tables.
* Created endpoint to routinely update tables with new data from CUReviews, RateMyProf and Cornell Course Roster API
* Created endpoints for user addition and deletion of favorite courses and comments
* Implemented http token authentication with bcrypt library
* Containerization with Docker and deployed using Google Cloud virtual machine

# Product Design
The main features of the app include a landing page, login and creating an account, filtering through courses, searching for classes, viewing class descriptions, favouriting classes, and participating in discussions on classes.

The people problem that this app solves is that students often find it difficult and inconvenient to find classes that are worthwhile yet meet their college requirements due to:
1. Resources and information and classes are spread out over too many websites
2. Students find it hard to find reliable information on classes

From an interaction design perspective, I decided to have all the classes be listed and accessible on the main page of the app, with the default sort being the highest rated classes. Under the search bar, I included a filter bar where students would be able to sort and sift through the list of classes based on what they are looking for, be it by distribution, level, etc. For the filter options, I decided to have the tab for that pop out from the bottom which is already a natural and accesible position for a user's thumb. I also implemented a match all/match any option for distribution sorting, as students may want to fulfill two requirements with one class if possible. Clicking on a class brings the user to a description page where they can find more information on a class, and scrolling down they find a discussion page that can be expanded under the class description. Users can like and post replies to other users' comments on classes.
Visually, I made the classes into bubbles and introduced a shadow effect to intuitively guide a user to clicking it. I also decided to have the star button on the bubbles as a student may want to star a class they skim pass and then check back on its details later. Clicking on the star in the filter bar switches the colors of the class list to the primary color red, signifying that these classes are different from the other ones listed, and gives the user a heads up that it is in a different sorting mode already. I included the rating as well on the class bubbles as it gives a user important information on whether a class is "worthwhile" or not.

For colors, I decided to use a bright red as a primary color, reflecting Cornell university's main color, and also matching the theme of the app "Class Rooster". I used a grayscale for the rest of the app as red is itself already a strong color. Combining the two allows me to draw the user to important information on the screen through color variety instead of only being limited by font size and style. A lighter hue of pinkish-red is also used scarcely, mostly intended for bars and highlights while there is already a main red object present on a screen.

For typography, I decided to use Proxima Nova. It stands out from the default SF Pro of iOS, but at the same time gives an elegant and minimal feel to the app. Most importantly, it is clean yet welcoming, With the hierarchy, I used bold proxima very often, save for the body, course names and descriptions, to allow the font to hold its own against a very strong color that is red. Channel on the other hand was used for the title of the app on the landing page, in order to contrast the more proper and straight font of Proxima Nova, with a fun and cursive font. I made the title dark gray, saving for the word "Rooster" which is clad in red to draw the attention of the user.

[Figma Link](https://www.figma.com/file/qPlbhnlE9x49FaDMPc8DeR/Hack-Challenge-SP22?node-id=2%3A3)


# Credits
Thank you tisuela for [ratemyprof-api](https://github.com/tisuela/ratemyprof-api) and Cornell DTI for letting us scrape CUReviews
