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
            "": self.code,
            "name":self.name,
            "assignments": [a.serialize() for a in self.assignments],
            "instructors": [c.simple_serialize() for c in self.users if c.sori =="instructor"],
            "students": [c.simple_serialize() for c in self.users if c.sori == "student"]
        }

    
