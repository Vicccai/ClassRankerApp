import datetime
import hashlib
import os
from pyexpat import model
from flask_sqlalchemy import SQLAlchemy
import bcrypt

db = SQLAlchemy()

associate_users_with_courses = db.Table(
    "associate_users_with_courses",
    db.Column("user_id", db.Integer, db.ForeignKey("users.id")),
    db.Column("course_id", db.Integer, db.ForeignKey("courses.id"))
)

associate_professors_with_courses = db.Table(
    "associate_professors_with_courses",
    db.Column("professor_id", db.Integer, db.ForeignKey("professors.id")),
    db.Column("course_id", db.Integer, db.ForeignKey("courses.id"))
)

associate_users_with_sorted_rating = db.Table(
    "associate_users_with_sorted_rating",
    db.Column("user_id", db.Integer, db.ForeignKey("users.id")),
    db.Column("sortedByRating_id", db.Integer, db.ForeignKey("sortedByRating.id"))
)

associate_professors_with_sorted_rating = db.Table(
    "associate_professors_with_sorted_rating",
    db.Column("professor_id", db.Integer, db.ForeignKey("professors.id")),
    db.Column("sortedByRating_id", db.Integer, db.ForeignKey("sortedByRating.id"))
)

associate_users_with_sorted_workload = db.Table(
    "associate_users_with_sorted_workload",
    db.Column("user_id", db.Integer, db.ForeignKey("users.id")),
    db.Column("sortedByWorkload_id", db.Integer, db.ForeignKey("sortedByWorkload.id"))
)

associate_professors_with_sorted_workload = db.Table(
    "associate_professors_with_sorted_workload",
    db.Column("professor_id", db.Integer, db.ForeignKey("professors.id")),
    db.Column("sortedByWorkload_id", db.Integer, db.ForeignKey("sortedByWorkload.id"))
)

associate_users_with_sorted_difficulty = db.Table(
    "associate_users_with_sorted_difficulty",
    db.Column("user_id", db.Integer, db.ForeignKey("users.id")),
    db.Column("sortedByDifficulty_id", db.Integer, db.ForeignKey("sortedByDifficulty.id"))
)

associate_professors_with_sorted_difficulty = db.Table(
    "associate_professors_with_sorted_difficulty",
    db.Column("professor_id", db.Integer, db.ForeignKey("professors.id")),
    db.Column("sortedByDificulty_id", db.Integer, db.ForeignKey("sortedByDifficulty.id"))
)

associate_breadths_with_courses = db.Table(
    "associate_breadths_with_courses",
    db.Column("breadth_id", db.Integer, db.ForeignKey("breadths.id")),
    db.Column("course_id", db.Integer, db.ForeignKey("courses.id"))
)

associate_distributions_with_courses = db.Table(
    "associate_distributions_with_courses",
    db.Column("distribution_id", db.Integer, db.ForeignKey("distributions.id")),
    db.Column("course_id", db.Integer, db.ForeignKey("courses.id"))
)

associate_sorted_rating_with_breadths = db.Table(
    "associate_sorted_rating_with_breadths",
    db.Column("breadth_id", db.Integer, db.ForeignKey("breadths.id")),
    db.Column("sortedByRating_id", db.Integer, db.ForeignKey("sortedByRating.id"))
)

associate_sorted_rating_with_distributions = db.Table(
    "associate_sorted_rating_with_distributions",
    db.Column("distribution_id", db.Integer, db.ForeignKey("distributions.id")),
    db.Column("sortedByRating_id", db.Integer, db.ForeignKey("sortedByRating.id"))
)

associate_sorted_workload_with_breadths = db.Table(
    "associate_sorted_workload_with_breadths",
    db.Column("breadth_id", db.Integer, db.ForeignKey("breadths.id")),
    db.Column("sortedByWorkload_id", db.Integer, db.ForeignKey("sortedByWorkload.id"))
)

associate_sorted_workload_with_distributions = db.Table(
    "associate_sorted_workload_with_distributions",
    db.Column("distribution_id", db.Integer, db.ForeignKey("distributions.id")),
    db.Column("sortedByWorkload_id", db.Integer, db.ForeignKey("sortedByWorkload.id"))
)

associate_sorted_difficulty_with_breadths = db.Table(
    "associate_sorted_difficulty_with_breadths",
    db.Column("breadth_id", db.Integer, db.ForeignKey("breadths.id")),
    db.Column("sortedByDifficulty_id", db.Integer, db.ForeignKey("sortedByDifficulty.id")),
)

associate_sorted_difficulty_with_distributions = db.Table(
    "associate_sorted_difficulty_with_distributions",
    db.Column("distribution_id", db.Integer, db.ForeignKey("distributions.id")),
    db.Column("sortedByDifficulty_id", db.Integer, db.ForeignKey("sortedByDifficulty.id"))
)

class Course(db.Model):
    """
    Course model 
    """
    __tablename__ = "courses"
    id = db.Column(db.Integer, primary_key = True, autoincrement=True)
    subject = db.Column(db.String, nullable = False)
    number = db.Column(db.Integer, nullable = False)
    subandnum = db.Column(db.String, nullable = False)
    title = db.Column(db.String, nullable = False)
    creditsMin = db.Column(db.Integer, nullable = False)
    creditsMax = db.Column(db.Integer, nullable = False)
    description = db.Column(db.String, nullable = False)
    workload = db.Column(db.Float)
    difficulty = db.Column(db.Float)
    rating = db.Column(db.Float)
    breadths = db.relationship("Breadth", secondary = associate_breadths_with_courses, back_populates = "courses")
    distributions = db.relationship("Distribution", secondary = associate_distributions_with_courses, back_populates = "courses")
    users = db.relationship("User", secondary = associate_users_with_courses, back_populates="courses") 
    professors = db.relationship("Professor", secondary = associate_professors_with_courses, back_populates="courses")
    comments = db.relationship("Comment", cascade = "delete")

    def __init__(self, **kwargs): 
        """
        Initialize Course object
        """
        self.subject = kwargs.get("subject", "")
        self.number = kwargs.get("number", 0)
        self.subandnum = kwargs.get("subandnum", "")
        self.title = kwargs.get("title", "")
        self.creditsMin = kwargs.get("creditsMin", 0)
        self.creditsMax = kwargs.get("creditsMax", 0)
        self.description = kwargs.get("description", "")
        self.workload = kwargs.get("workload", 0)
        self.difficulty = kwargs.get("difficulty", 0)
        self.rating = kwargs.get("rating", 0)

    def simple_serialize(self):
        """
        Simple serializes a Course object
        """
        return {
            "id": self.id,
            "subject": self.subject,
            "number": self.number,
            "subandnum": self.subandnum,
            "title": self.title,
            "creditsMin": self.creditsMin,
            "creditsMax": self.creditsMax,
            "description": self.description,
            "workload": self.workload,
            "difficulty": self.difficulty,
            "rating": self.rating,
            }

    def serialize(self):
        """
        Serialize Course object
        """
        return {
            "id": self.id,
            "subject": self.subject,
            "number": self.number,
            "subandnum": self.subandnum,
            "title": self.title,
            "creditsMin": self.creditsMin,
            "creditsMax": self.creditsMax,
            "description": self.description,
            "workload": self.workload,
            "difficulty": self.difficulty,
            "rating": self.rating,
            "users": [c.simple_serialize() for c in self.users],
            "professors": [d.simple_serialize() for d in self.professors],
            "comments": [m.serialize() for m in self.comments],
            "breadths": [b.simple_serialize() for b in self.breadths],
            "distributions": [f.simple_serialize() for f in self.distributions]
            }
    
class SortedByRating(db.Model):
    """
    SortedByRating model

    Table of courses sorted by rating
    """
    __tablename__="sortedByRating"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    subject = db.Column(db.String, nullable = False)
    number = db.Column(db.Integer, nullable = False)
    subandnum = db.Column(db.String, nullable = False)
    title = db.Column(db.String, nullable = False)
    creditsMin = db.Column(db.Integer, nullable = False)
    creditsMax = db.Column(db.Integer, nullable = False)
    description = db.Column(db.String, nullable = False)
    workload = db.Column(db.Float)
    difficulty = db.Column(db.Float)
    rating = db.Column(db.Float)
    breadths = db.relationship("Breadth", secondary = associate_sorted_rating_with_breadths)
    distributions = db.relationship("Distribution", secondary= associate_sorted_rating_with_distributions)
    users = db.relationship("User", secondary = associate_users_with_sorted_rating, back_populates = "sortedByRating")
    professors = db.relationship("Professor", secondary = associate_professors_with_sorted_rating)
    comments = db.relationship("Comment", cascade = "delete")


    def __init__(self, **kwargs): 
        """
        Initialize SortByRating object
        """
        self.subject = kwargs.get("subject", "")
        self.number = kwargs.get("number", 0)
        self.subandnum = kwargs.get("subandnum", "")
        self.title = kwargs.get("title", "")
        self.creditsMin = kwargs.get("creditsMin", 0)
        self.creditsMax = kwargs.get("creditsMax", 0)
        self.description = kwargs.get("description", "")
        self.workload = kwargs.get("workload", 0)
        self.difficulty = kwargs.get("difficulty", 0)
        self.rating = kwargs.get("rating", 0)

    def simple_serialize(self):
        """
        Simple serializes a Course object
        """
        return {
            "id": self.id,
            "subject": self.subject,
            "number": self.number,
            "subandnum": self.subandnum,
            "title": self.title,
            "workload": self.workload,
            "difficulty": self.difficulty,
            "rating": self.rating,
            }

    def serialize(self):
        """
        Serialize SortByRating object
        """
        return {
            "id": self.id,
            "subject": self.subject,
            "number": self.number,
            "subandnum": self.subandnum,
            "title": self.title,
            "creditsMin": self.creditsMin,
            "creditsMax": self.creditsMax,
            "description": self.description,
            "workload": self.workload,
            "difficulty": self.difficulty,
            "rating": self.rating,
            "users": [c.simple_serialize() for c in self.users],
            "professors": [d.simple_serialize() for d in self.professors],
            "comments": [m.serialize() for m in self.comments],
            "breadths": [b.simple_serialize() for b in self.breadths],
            "distributions": [f.simple_serialize() for f in self.distributions]
            }

class SortedByWorkload(db.Model):
    """
    SortedByWorkload model

    Table of courses sorted by workload
    """
    __tablename__="sortedByWorkload"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    subject = db.Column(db.String, nullable = False)
    number = db.Column(db.Integer, nullable = False)
    subandnum = db.Column(db.String, nullable = False)
    title = db.Column(db.String, nullable = False)
    creditsMin = db.Column(db.Integer, nullable = False)
    creditsMax = db.Column(db.Integer, nullable = False)
    description = db.Column(db.String, nullable = False)
    workload = db.Column(db.Float)
    difficulty = db.Column(db.Float)
    rating = db.Column(db.Float)
    breadths = db.relationship("Breadth", secondary = associate_sorted_workload_with_breadths)
    distributions = db.relationship("Distribution", secondary= associate_sorted_workload_with_distributions)
    users = db.relationship("User", secondary = associate_users_with_sorted_workload, back_populates = "sortedByWorkload")
    professors = db.relationship("Professor", secondary = associate_professors_with_sorted_workload)
    comments = db.relationship("Comment", cascade = "delete")

    def __init__(self, **kwargs): 
        """
        Initialize SortByWorkload object
        """
        self.subject = kwargs.get("subject", "")
        self.number = kwargs.get("number", 0)
        self.subandnum = kwargs.get("subandnum", "")
        self.title = kwargs.get("title", "")
        self.creditsMin = kwargs.get("creditsMin", 0)
        self.creditsMax = kwargs.get("creditsMax", 0)
        self.description = kwargs.get("description", "")
        self.workload = kwargs.get("workload", 0)
        self.difficulty = kwargs.get("difficulty", 0)
        self.rating = kwargs.get("rating", 0)

    def simple_serialize(self):
        """
        Simple serializes a Course object
        """
        return {
            "id": self.id,
            "subject": self.subject,
            "number": self.number,
            "subandnum": self.subandnum,
            "title": self.title,
            "workload": self.workload,
            "difficulty": self.difficulty,
            "rating": self.rating,
            }

    def serialize(self):
        """
        Serialize SortByWorkload object
        """
        return {
            "id": self.id,
            "subject": self.subject,
            "number": self.number,
            "subandnum": self.subandnum,
            "title": self.title,
            "creditsMin": self.creditsMin,
            "creditsMax": self.creditsMax,
            "description": self.description,
            "workload": self.workload,
            "difficulty": self.difficulty,
            "rating": self.rating,
            "users": [c.simple_serialize() for c in self.users],
            "professors": [d.simple_serialize() for d in self.professors],
            "comments": [m.serialize() for m in self.comments],
            "breadths": [b.simple_serialize() for b in self.breadths],
            "distributions": [f.simple_serialize() for f in self.distributions]
            }

class SortedByDifficulty(db.Model):
    """
    SortedByDifficulty model

    Table of courses sorted by difficulty
    """
    __tablename__="sortedByDifficulty"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    subject = db.Column(db.String, nullable = False)
    number = db.Column(db.Integer, nullable = False)
    subandnum = db.Column(db.String, nullable = False)
    title = db.Column(db.String, nullable = False)
    creditsMin = db.Column(db.Integer, nullable = False)
    creditsMax = db.Column(db.Integer, nullable = False)
    description = db.Column(db.String, nullable = False)
    workload = db.Column(db.Float)
    difficulty = db.Column(db.Float)
    rating = db.Column(db.Float)
    breadths = db.relationship("Breadth", secondary = associate_sorted_difficulty_with_breadths)
    distributions = db.relationship("Distribution", secondary= associate_sorted_difficulty_with_distributions)
    users = db.relationship("User", secondary = associate_users_with_sorted_difficulty, back_populates = "sortedByDifficulty")
    professors = db.relationship("Professor", secondary = associate_professors_with_sorted_difficulty)
    comments = db.relationship("Comment", cascade = "delete")

    def __init__(self, **kwargs): 
        """
        Initialize SortByDifficulty object
        """
        self.subject = kwargs.get("subject", "")
        self.number = kwargs.get("number", 0)
        self.subandnum = kwargs.get("subandnum", "")
        self.title = kwargs.get("title", "")
        self.creditsMin = kwargs.get("creditsMin", 0)
        self.creditsMax = kwargs.get("creditsMax", 0)
        self.description = kwargs.get("description", "")
        self.workload = kwargs.get("workload", 0)
        self.difficulty = kwargs.get("difficulty", 0)
        self.rating = kwargs.get("rating", 0)
    
    def simple_serialize(self):
        """
        Simple serializes a Course object
        """
        return {
            "id": self.id,
            "subject": self.subject,
            "number": self.number,
            "subandnum": self.subandnum,
            "title": self.title,
            "workload": self.workload,
            "difficulty": self.difficulty,
            "rating": self.rating,
            }

    def serialize(self):
        """
        Serialize SortByDifficulty object
        """
        return {
            "id": self.id,
            "subject": self.subject,
            "number": self.number,
            "subandnum": self.subandnum,
            "title": self.title,
            "creditsMin": self.creditsMin,
            "creditsMax": self.creditsMax,
            "description": self.description,
            "workload": self.workload,
            "difficulty": self.difficulty,
            "rating": self.rating,
            "users": [c.simple_serialize() for c in self.users],
            "professors": [d.simple_serialize() for d in self.professors],
            "comments": [m.serialize() for m in self.comments],
            "breadths": [b.simple_serialize() for b in self.breadths],
            "distributions": [f.simple_serialize() for f in self.distributions]
            }

class Breadth(db.Model):
    """
    Breadth Model
    """
    __tablename__="breadths"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable = False)
    courses = db.relationship("Course", secondary = associate_breadths_with_courses, back_populates = "breadths")

    def __init__(self, **kwargs):
        """Initializes Breadth object"""
        self.name = kwargs.get("name", "")
    
    def simple_serialize(self):
        """Serializes a breadth object"""
        return {
            "name": self.name
        }

class Distribution(db.Model):
    """
    Distribution Model
    """
    __tablename__="distributions"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable = False)
    courses = db.relationship("Course", secondary = associate_distributions_with_courses, back_populates = "distributions")

    def __init__(self, **kwargs):
        """Initializes Distribution object"""
        self.name = kwargs.get("name", "")
    
    def simple_serialize(self):
        """Serializes a Distribution object"""
        return {
            "name": self.name
        }

class User(db.Model):
    """
    User model 
    """
    __tablename__="users"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name =db.Column(db.String, nullable = False)
    username = db.Column(db.String, nullable = False)
    courses = db.relationship("Course", secondary = associate_users_with_courses, back_populates="users")
    sortedByRating = db.relationship("SortedByRating", secondary = associate_users_with_sorted_rating, back_populates="users")
    sortedByWorkload = db.relationship("SortedByWorkload", secondary = associate_users_with_sorted_workload, back_populates="users")
    sortedByDifficulty = db.relationship("SortedByDifficulty", secondary = associate_users_with_sorted_difficulty, back_populates="users")
    comments = db.relationship("Comment", cascade = "delete")
    password_digest = db.Column(db.String, nullable = False)

    #session info
    session_token = db.Column(db.String, nullable = False, unique = True)
    session_expiration = db.Column(db.DateTime, nullable = False)
    update_token = db.Column(db.String, nullable=False, unique=True)

    def __init__(self, **kwargs):
        """initializes a User object"""
        self.name = kwargs.get("name", "")
        self.username = kwargs.get("username", "")
        self.password_digest = bcrypt.hashpw(kwargs.get("password").encode("utf8"), bcrypt.gensalt(rounds=13))
        self.renew_session()
    
    def _urlsafe_base_64(self):
        """
        Randomly generates hashed tokens (used for session/update tokens)
        """
        return hashlib.sha1(os.urandom(64)).hexdigest()

    def renew_session(self):
        """
        Renews the sessions, i.e.
        1. Creates a new session token
        2. Sets the expiration time of the session to be a day from now
        3. Creates a new update token
        """
        self.session_token = self._urlsafe_base_64()
        self.session_expiration = datetime.datetime.now() + datetime.timedelta(days=1)
        self.update_token = self._urlsafe_base_64()

    def verify_password(self, password):
        """
        Verifies the password of a user
        """
        return bcrypt.checkpw(password.encode("utf8"), self.password_digest)

    def verify_session_token(self, session_token):
        """
        Verifies the session token of a user
        """
        return session_token == self.session_token and datetime.datetime.now() < self.session_expiration

    def verify_update_token(self, update_token):
        """
        Verifies the update token of a user
        """
        return update_token == self.update_token

    def serialize(self):
        """serializes a user object"""
        return {
            "id": self.id,
            "name": self.name,
            "username": self.username,
            "courses":self.courses,
            "comments": [m.serialize() for m in self.comments]
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
    courses = db.relationship("Course", secondary = associate_professors_with_courses, back_populates="professors")

    def __init__(self, **kwargs):
        """Initializes a Professor object"""
        self.first_name = kwargs.get("first_name", "")
        self.last_name = kwargs.get("last_name", "")

    def simple_serialize(self):
        """simple serializes a professor object"""
        return {
            "first_name": self.first_name,
            "last_name": self.last_name
        }

class Comment(db.Model):
    """
    Comment Model

    has a many to one relationship with Course 
    and has a many to one relationship with users
    """
    __tablename__ = "comments"
    id = db.Column(db.Integer, primary_key = True, autoincrement=True)
    username = db.Column(db.String, db.ForeignKey("users.username"), nullable=False)
    course_id = db.Column(db.Integer, db.ForeignKey("courses.id"), nullable=False)
    sortedByRating_subandnum = db.Column(db.String, db.ForeignKey("sortedByRating.subandnum"), nullable=False)
    sortedByDifficulty_subandnum = db.Column(db.String, db.ForeignKey("sortedByDifficulty.subandnum"), nullable=False)
    sortedByWorkload_subandnum = db.Column(db.String, db.ForeignKey("sortedByWorkload.subandnum"), nullable=False)
    description = db.Column(db.String, nullable = False) 

    def __init__(self, **kwargs):
        """ 
        Initializes an Comment object
        """
        self.course_id= kwargs.get("course_id")
        subandnum = kwargs.get("subandnum")
        self.sortedByRating_subandnum = subandnum
        self.sortedByDifficulty_subandnum = subandnum
        self.sortedByWorkload_subandnum = subandnum
        self.username=kwargs.get("username")
        self.description= kwargs.get("description")

    def serialize(self):
        """
        serialize an Comment object
        """
        return {
            "id": self.id,
            "course_id": self.course_id,
            "username":self.username,
            "description": self.description
        }