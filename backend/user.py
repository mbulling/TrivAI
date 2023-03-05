from enum import Enum


class UserType(Enum):
    STUDENT = "student",
    TEACHER = "teacher",
    OTHER = "other"


class User:
    def __init__(self, username: str, password: str, user_type: UserType):
        self.username = username
        self.password = password
        self.user_type = user_type
        self.score = 0

    def to_dict(self):
        return {
            "username": self.username,
            "password": self.password,
            "user_type": self.user_type.value[0],
            "score": self.score
        }
