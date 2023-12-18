import boto3
import json
import os
import openai


# assign DynamoDB table to modify
table_name = "trivai-questions"
dynamo = boto3.resource('dynamodb')
questions_table = dynamo.Table(table_name)

# constants
OPENAI_API_KEY = os.environ["OPENAI_KEY"]
MAX_QUESTIONS = 20


# entry point for new events, parses event
def lambda_handler(event, context):
    ''' [event] contains the following keys:
        - passage: passage to generate questions for
        - num_questions:  number of questions to generate
    '''

    try:
        data = json.loads(event["body"])
        passage = data["passage"]
        num_questions = data["num_questions"]

        if num_questions > MAX_QUESTIONS:  # FIXME: cap instead of error?
            return {
                'statusCode': 400,
                'body': json.dumps({"error": "Cannot generate more than %d questions at a time." % MAX_QUESTIONS})
            }

        status, res = mcq_passage(passage, num_questions)
        if status == 200:
            return {
                'statusCode': 200,
                'body': res
            }
    except Exception as e:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': e})
        }


def mcq_passage(passage, num_questions):
    mcq_passage_prompt = """
    Create %d questions about the following passage in exactly the following json format, which is surrounded in brackets. Make sure each question has exactly 4 answer choices. Do not output anything other than the questions in the specified format:
    [
        {
            "question": question,
            "options": [option 0, option 1, option 2, option 3],
            "answer_id": answer_id
        },
        {
            "question": question,
            "options": [option 0, option 1, option 2, option 3],
            "answer_id": answer_id
        }, ...
    ]
    Passage: %s
    """ % (num_questions, passage)
    return get_chatgpt(mcq_passage_prompt)


# get ChatGPT response to given prompt
def get_chatgpt(prompt):  # (int, str)
    completion = openai.ChatCompletion.create(
        api_key=OPENAI_API_KEY,
        model="gpt-3.5-turbo",
        messages=[{"role": "user",
                   "content": prompt}]
    )
    content = completion["choices"][0]["message"]["content"]  # str

    try:
        return 200, content
    except:
        return 400, json.dumps({"error": "OpenAI did not return a json string"})
