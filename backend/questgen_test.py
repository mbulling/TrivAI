# import nltk
# nltk.download('stopwords')
from pprint import pprint
from Questgen import main
# qe= main.BoolQGen()
payload = {
            "input_text": "Questgen AI is an opensource NLP library focused on developing easy to use Question generation algorithms. It is on a quest build the world's most advanced question generation AI leveraging on state-of-the-art transformer models like T5, BERT and OpenAI GPT-2 etc."
        }

qg = main.QGen()
output = qg.predict_mcq(payload)
for question in output["questions"]:
    answer = question["answer"]
    options = question["options"]
    question_statement = question["question_statement"]
    

# qe= main.BoolQGen()
# payload = {
#             "input_text": "Sachin Ramesh Tendulkar is a former international cricketer from India and a former captain of the Indian national team. He is widely regarded as one of the greatest batsmen in the history of cricket. He is the highest run scorer of all time in International cricket."
#         }
# output = qe.predict_boolq(payload)
# pprint (output['Boolean Questions'][0])


# output = qe.predict_boolq(payload)
# pprint (output['Boolean Questions'][0])
# qg = main.QGen()


# qg = main.QGen()
# output = qg.predict_mcq(payload)
# output = qg.predict_shortq(payload)


# answer = main.AnswerPredictor()
# payload3 = {
#     "input_text" : '''Sachin Ramesh Tendulkar is a former international cricketer from 
#               India and a former captain of the Indian national team. He is widely regarded 
#               as one of the greatest batsmen in the history of cricket. He is the highest
#                run scorer of all time in International cricket.''',
#     "input_question" : "Who is Sachin tendulkar ? "

# }
# answer.predict_answer(payload3)