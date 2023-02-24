from flask import Flask, render_template, request
import random
import nltk
nltk.download('stopwords') # ???
from pprint import pprint
from Questgen import main

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        # Get the user input string from the form
        user_input = request.form['user_input']

        # Generate four multiple choice questions
        questions = generate_questions(user_input)

        # Render the questions template with the questions and user input
        return render_template('questions.html', questions=questions, user_input=user_input)
    else:
        # Render the index template with a form for user input
        return render_template('index.html')

def generate_questions(user_input):
    # Generate num_questions random questions based on the user input
    question_list = []
    qg = main.QGen()
    payload = {
            "input_text": user_input
        }
    output = qg.predict_mcq(payload)
    for q in output["questions"]:
        answer = q["answer"]  # string
        options = q["options"] # string
        question_statement = q["question_statement"] # list of strings
        options.append(answer)
        answers = options
        random.shuffle(answers)
        question = {'text': question_statement, 'answers': answers}
        question_list.append(question)
    # for i in range(3):
    #     # Dummy example: generate random answers based on user input
    #     answers = [user_input + str(i) for i in range(4)]
    #     random.shuffle(answers)
    #     question = {'text': f"What is {user_input}?", 'answers': answers}
    #     question_list.append(question)
    print(question_list)
    return question_list
