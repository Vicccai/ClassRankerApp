import datetime
import hashlib
import os
from flask_sqlalchemy import SQLAlchemy
import bcrypt

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

associate_breadths = db.Table(
    "associate_breadths",
    db.Column("breadth_id", db.Integer, db.ForeignKey("breadth.id")),
    db.Column("course_id", db.Integer, db.ForeignKey("courses.id"))
)

associate_distributions = db.Table(
    "associate_distributions",
    db.Column("distribution_id", db.Integer, db.ForeignKey("distribution.id")),
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
    creditsMin = db.Column(db.Integer, nullable = False)
    creditsMax = db.Column(db.Integer, nullable = False)
    description = db.Column(db.String, nullable = False)
    workload = db.Column(db.Float)
    difficulty = db.Column(db.Float)
    rating = db.Column(db.Float)
    breadths = db.relationship("Breadth", secondary = associate_breadths, back_populates = "courses")
    distributions = db.relationship("Distribution", secondary = associate_distributions, back_populates = "courses")
    users = db.relationship("User", secondary = associate_users, back_populates="courses") 
    professors = db.relationship("Professor", secondary = associate_professors, back_populates="courses")
    comments = db.relationship("Comment", cascade = "delete")

    def __init__(self, **kwargs): 
        """
        initialize Course object
        """
        self.subject = kwargs.get("subject", "")
        self.number = kwargs.get("number", 0)
        self.title = kwargs.get("title", "")
        self.creditsMin = kwargs.get("creditsMin", 0)
        self.creditsMax = kwargs.get("creditsMax", 0)
        self.description = kwargs.get("description", "")
        self.workload = kwargs.get("workload", 0)
        self.difficulty = kwargs.get("difficulty", 0)
        self.rating = kwargs.get("rating", 0)

    def serialize(self):
        """
        Serialize Course object
        """
        return {
            "id": self.id,
            "subject": self.subject,
            "number": self.number,
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
    __table_name__="breadth"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable = False)
    courses = db.relationship("Course", secondary = associate_breadths, back_populates = "breadths")

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
    __table_name__="distribution"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable = False)
    courses = db.relationship("Course", secondary = associate_distributions, back_populates = "distributions")

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
    courses = db.relationship("Course", secondary = associate_users, back_populates="users")
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
    rating = db.Column(db.Float, nullable = False)
    courses = db.relationship("Course", secondary = associate_professors, back_populates="professors")

    def __init__(self, **kwargs):
        """Initializes a Professor object"""
        self.first_name = kwargs.get("first_name", "")
        self.last_name = kwargs.get("last_name", "")
        self.rating = kwargs.get("rating", 0)

    def simple_serialize(self):
        """simple serializes a professor object"""
        return {
            "first_name": self.first_name,
            "last_name": self.last_name,
            "rating": self.rating
        }
class Comment(db.Model):
    """
    Comment Model

    has a many to one relationship with Course 
    and has a many to one relationship with users
    """
    __tablename__ = "comments"
    id = db.Column(db.Integer, primary_key = True, autoincrement=True)
    course_id = db.Column(db.Integer, db.ForeignKey("courses.id"), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    description = db.Column(db.String, nullable = False)

    def __init__(self, **kwargs):
        """ 
        Initializes an Comment object
        """
        self.course_id= kwargs.get("course_id")
        self.user_id= kwargs.get("user_id")
        self.description= kwargs.get("description")

    def serialize(self):
        """
        serialize an Comment object
        """
        return {
            "id": self.id,
            "course_id": self.course_id,
            "user_id":self.user_id,
            "description": self.description
        }