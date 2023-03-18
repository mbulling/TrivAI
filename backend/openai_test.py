import openai
import json
from secrets import mason_api_key

prompt = """
Create 3 questions about Python (the programming language) in the following json format:
[
  {
    "question": [question],
    "options": [option 0, option 1, option 2, option 3],
    "answer_id": [answer_id]
  },
  {
    "question": [question],
    "options": [option 0, option 1, option 2, option 3],
    "answer_id": [answer_id]
  }, ...
]
"""

completion = openai.ChatCompletion.create(
    api_key=mason_api_key,
    model="gpt-3.5-turbo",
    messages=[{"role": "user",
               "content": prompt}]
)

data_res = completion

choices = data_res["choices"]

print("CHOICES")
print(choices)

choice = choices[0]

print("CHOICE")
print(choice)

message = choice["message"]

print("MESSAGE")
print(message)

content = message["content"]

print("CONTENT")
print(content)

questions = json.loads(content)

print(questions)
