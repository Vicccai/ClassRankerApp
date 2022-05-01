from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Course(db.Model):
     """
    Course model 

    has a many to many model with users
    """
    __tablename__ = "courses"
    id = db.Column(db.Integer, primary_key = True, autoincrement=True)
    catalognbr = db.Column(db.Integer, nullable = False)
    subject = db.Column(db.String, nullable = False)
    title = db.Column(db.String, nullable = False)
    description = db.Column(db.String, nullable = False)
    breadth = db.Column(db.String)
    distribution = db.Column(db.String)
    professors = db.Column(db.List)
    users = db.relationship("User", secondary = association_table, back_populates="courses")

    def __init__(self, **kwargs): 
        """
        initialize Course object
        """
        self.catalognbr = kwargs.get("catalognbr", "")
        self.subject = kwargs.get("subject", "")
        self.title = kwargs.get("title", "")
        self.description = kwargs.get("description", "")
        self.professors = kwargs.get("professors", "")

    def serialize(self):
    """
    Serialize Course object
    """
    return {
        "id": self.id,
        "catalognbr": self.catalognbr,
        "subject":self.subject,
        "title": self.title,
        "description": self.description,
        "breadth":self.breadth,
        "distribution": self.distribution,
        "professors": self.professors,
        "users": [c.simple_serialize() for c in self.users

    }
    
class User(db.Model):
    """
    User model 
    """
    __tablename__="users"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name =db.Column(db.String, nullable = False)
    username = db.Column(db.String, nullable = False)
    courses = db.relationship("Course", secondary = association_table, back_populates="users")
    
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