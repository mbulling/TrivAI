from Questgen import main
# from pprint import pprint
from flask import Flask, render_template, request
import random
import nltk
import json
from question import MCQ
# nltk.download('stopwords')  # ???

app = Flask(__name__)


@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        # Get the user input string from the form
        user_input = request.form['user_input']

        # Generate four multiple choice questions
        questions = generate_mcqs(user_input)

        questions_dict = [question.to_dict() for question in questions]

        # Render the questions template with the questions and user input
        return render_template('questions.html',
                               questions=questions_dict,
                               user_input=user_input)
    else:
        # Render the index template with a form for user input
        return render_template('index.html')


@app.route('/mcq/', methods=['POST'])
def get_mcq():
    ''' Create multiple choice questions '''
    body = json.loads(request.data)
    user_input = body["user_input"]
    questions = generate_mcqs(user_input)
    return json.dumps([question.to_dict() for question in questions])


@app.route('/tf/', methods=['POST'])
def get_tf():
    ''' Create a True/False questions '''
    body = json.loads(request.data)
    user_input = body["user_input"]
    questions = generate_tfs(user_input)
    return json.dumps(questions)


def generate_mcqs(user_input):
    # Generate num_questions random questions based on the user input
    question_list = []
    qg = main.QGen()
    payload = {
        "input_text": user_input
    }
    output = qg.predict_mcq(payload)
    for q in output["questions"]:
        answer = q["answer"]  # string
        options = q["options"]  # list of strings
        question_statement = q["question_statement"]  # string
        options.append(answer)
        random.shuffle(options)
        answer_idx = options.index(answer)

        question = MCQ(question_statement, options, answer_idx)
        question_list.append(question)
    return question_list


def generate_tfs(user_input):
    # Generate num_questions random questions based on the user input
    question_list = []
    qg = main.BoolQGen()
    payload = {
        "input_text": user_input
    }
    output = qg.predict_boolq(payload)
    for q in output["Boolean Questions"]:
        print(q)
        question_list.append(q)
    return question_list
