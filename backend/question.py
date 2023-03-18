from typing import List


class MCQ:
    def __init__(self, statement: str, options: List[str], answer_idx: int):
        ''' Creates a new Multiple Choice Question with the given info. '''
        self.statement = statement
        self.options = options
        self.answer_idx = answer_idx

    def to_dict(self):
        return {'statement': self.statement,
                'options': self.options,
                'answer_idx': self.answer_idx}
