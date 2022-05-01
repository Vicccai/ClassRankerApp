from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

associate_users = db.Table(
    "associate_users",
    db.Column("user_id", db.Integer, db.ForeignKey("users.id")),
    db.Column("course_id", db.Integer, db.ForeignKey("courses.id"))
)

associate_professors = db.Table(
    "associate_professors",
    db.Column("professor_id", db.Integer, db.ForeignKey("professors.id")),
    db.Column("course_id", db.Integer, db.ForeignKey("courses.id"))
)

class Course(db.Model):
    """
    Course model 

    has a many to many model with users
    """
    __tablename__ = "courses"
    id = db.Column(db.Integer, primary_key = True, autoincrement=True)
    subject = db.Column(db.String, nullable = False)
    number = db.Column(db.Integer, nullable = False)
    title = db.Column(db.String, nullable = False)
    description = db.Column(db.String, nullable = False)
    breadth = db.Column(db.String)
    distribution = db.Column(db.String)
    workload = db.Column(db.Float)
    difficulty = db.Column(db.Float)
    rating = db.Column(db.Float)
    users = db.relationship("User", secondary = associate_users, back_populates="courses")
    professors = db.relationship("Professor", secondary = associate_professors, back_populates="courses")

    def __init__(self, **kwargs): 
        """
        initialize Course object
        """
        self.subject = kwargs.get("subject", "")
        self.number = kwargs.get("number", "")
        self.title = kwargs.get("title", "")
        self.description = kwargs.get("description", "")
        self.breadth = kwargs.get("breadth", "")
        self.distribution = kwargs.get("distribution", "")
        self.workload = kwargs.get("workload", "")
        self.difficulty = kwargs.get("difficulty", "")
        self.rating = kwargs.get("rating", "")

    def serialize(self):
        """
        Serialize Course object
        """
        return {
            "id": self.id,
            "subject": self.subject,
            "number": self.number,
            "title": self.title,
            "description": self.description,
            "breadth":self.breadth,
            "distribution": self.distribution,
            "workload": self.workload,
            "difficulty": self.difficulty,
            "rating": self.rating,
            "users": [c.simple_serialize() for c in self.users],
            "professors": [d.simple_serialize() for d in self.professors]
            }

class User(db.Model):
    """
    User model 
    """
    __tablename__="users"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name =db.Column(db.String, nullable = False)
    username = db.Column(db.String, nullable = False)
    courses = db.relationship("Course", secondary = associate_users, back_populates="users")
    
    def __init__(self, **kwargs):
        """initializes a User object"""
        self.name = kwargs.get("name", "")
        self.username = kwargs.get("username", "")

    def serialize(self):
        """serializes a user object"""
        return {
            "id": self.id,
            "name": self.name,
            "username": self.username,
            "courses":self.courses
        }
    def simple_serialize(self):
        """simple serializes a user object"""
        return {
            "id": self.id,
            "name": self.name,
            "username": self.username
        }

class Professor(db.Model):
    """
    Professor Model
    """
    __tablename__="professors"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    first_name = db.Column(db.String, nullable = False)
    last_name = db.Column(db.String, nullable = False)
    rating = db.Column(db.Float, nullable = False)
    courses = db.relationship("Course", secondary = associate_professors, back_populates="professors")

    def __init__(self, **kwargs):
        """Initializes a Professor object"""
        self.first_name = kwargs.get("first_name", ""),
        self.last_name = kwargs.get("last_name", "")
        self.rating = kwargs.get("rating", "")

    def simple_serialize(self):
        """simple serializes a professor object"""
        return {
            "first_name": self.first_name,
            "last_name": self.last_name,
            "rating": self.rating
        }
