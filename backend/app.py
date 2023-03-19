from flask import Flask, render_template, request, jsonify
import json
import ast
# from question import MCQ
from user import User, UserType
from qgenerator import get_mcqs_passage, get_mcqs_topic, get_tfs_topic, get_tfs_passage

app = Flask(__name__)

MAX_QUESTIONS = 20


@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        # Get the user input string from the form
        user_input = request.form['user_input']

        # Generate four multiple choice questions
        questions = get_mcqs_passage(user_input)
        questions_dict = ast.literal_eval(questions)

        # Render the questions template with the questions and user input
        return render_template('questions.html',
                               questions=questions_dict,
                               user_input=user_input)
    else:
        # Render the index template with a form for user input
        return render_template('index.html')


# get MCQs based on user-provided passage
@app.route('/mcq/', methods=['POST'])
def get_mcq_by_passage():
    body = json.loads(request.data)
    passage = body["passage"]
    num_questions = body["num_questions"]
    if num_questions > MAX_QUESTIONS:
        return json.dumps({"error": "Cannot generate more than %d questions at a time." % MAX_QUESTIONS})
    print("Generating %d MCQs from text provided by user" % num_questions)
    return get_mcqs_passage(passage, num_questions)


# get MCQs based on user-chosen topic
@app.route('/mcq/topic/', methods=['POST'])
def get_mcq_by_topic():
    body = json.loads(request.data)
    topic = body["topic"]
    num_questions = body["num_questions"]
    if num_questions > MAX_QUESTIONS:
        return json.dumps({"error": "Cannot generate more than %d questions at a time." % MAX_QUESTIONS})
    print("Generating %d MCQs for topic %s" % (num_questions, topic))
    return get_mcqs_topic(topic, num_questions)


# get TF questions based on user-provided passage
@app.route('/tf/', methods=['POST'])
def get_tf():
    body = json.loads(request.data)
    passage = body["passage"]
    num_questions = body["num_questions"]
    if num_questions > MAX_QUESTIONS:
        return json.dumps({"error": "Cannot generate more than %d questions at a time." % MAX_QUESTIONS})
    print("Generating %d True/False questions from text provided by user" %
          num_questions)
    return get_tfs_passage(passage, num_questions)


# get TF questions based on user-chosen topic
@app.route('/tf/topic/', methods=['POST'])
def get_tf_by_topic():
    body = json.loads(request.data)
    topic = body["topic"]
    num_questions = body["num_questions"]
    if num_questions > MAX_QUESTIONS:
        return json.dumps({"error": "Cannot generate more than %d questions at a time." % MAX_QUESTIONS})
    print("Generating %d True/False questions for topic %s" %
          (num_questions, topic))
    return get_tfs_topic(topic, num_questions)


# register a new user
@app.route('/register/', methods=['POST'])
def register():
    body = json.loads(request.data)
    username = body["username"]  # string
    password = body["password"]  # string
    if body["user_type"].lower() == "student":
        user_type = UserType.STUDENT
    elif body["user_type"].lower() == "teacher":
        user_type = UserType.TEACHER
    else:
        user_type = UserType.OTHER
    user = User(username, password, user_type)
    return json.dumps(user.to_dict())

# return a dummy list of topics for testing


@app.route('/topics', methods=['GET'])
def get_topics():
    return jsonify(["Calculus", "Physics", "Chemistry", "Biology"])


# return a dummy question list for testing
@app.route('/questions', methods=['GET'])
def get_questions():
    return jsonify([
        {
            "question": "What are some common applications of maximum-flow algorithms?",
            "options": ["Resource allocation", "Network flow analysis", "image segmentation", "load balancing"],
            "answer_id": 1
        },
        {
            "question": "What is a min-cut in a flow network and how is it related to the maximum-flow?",
            "options": ["The min-cut is the minimum capacity needed to cut the flow network into two disjoint sets. The maximum-flow is equal to the min-cut.", "The min-cut is the minimum number of edges needed to cut the flow network into two disjoint sets. The maximum-flow is equal to the sum of capacities of edges in the min-cut.", "The min-cut is the maximum capacity needed to cut the flow network into two disjoint sets. The maximum-flow is equal to the min-cut.", "The min-cut is the maximum number of edges needed to cut the flow network into two disjoint sets. The maximum-flow is equal to the sum of capacities of edges in the min-cut."],
            "answer_id": 2
        },
        {
            "question": "Which of the following algorithms has the fastest asymptotic worst-case running time for solving the maximum flow problem?",
            "options": ["Edmonds-Karp algorithm", "Ford-Fulkerson algorithm", "Dinic's algorithm", "Push-relabel algorithm"],
            "answer_id": 3
        }])
