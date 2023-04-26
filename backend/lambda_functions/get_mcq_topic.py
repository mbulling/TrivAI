import boto3
import json
import os
import openai
import random


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
        - topic: subject to generate questions for
        - num_questions:  number of questions to generate
    '''

    try:
        data = json.loads(event["body"])
        topic = data["topic"]
        num_questions = data["num_questions"]

        if num_questions > MAX_QUESTIONS:  # FIXME: cap instead of error?
            return {
                'statusCode': 400,
                'body': json.dumps({"error": "Cannot generate more than %d questions at a time." % MAX_QUESTIONS})
            }

        res = ""
        key = {'topic_id': topic}
        response = questions_table.get_item(Key=key)
        if 'Item' in response:
            # list of dictionaries
            questions = json.loads(response['Item']['questions'])
            if len(questions) < num_questions:
                # Generate more questions and put the updated list of questions into the database
                status, more_questions = mcq_topic(
                    topic, num_questions - len(questions))
                questions = questions + \
                    json.loads(more_questions)  # list of dicts
                response = questions_table.update_item(
                    Key=key,
                    UpdateExpression="set questions=:q",
                    ExpressionAttributeValues={
                        ':q': json.dumps(questions)},
                    ReturnValues="UPDATED_NEW")
            else:
                # Randomly choose num_questions questions to return
                questions = random.sample(questions, num_questions)
            # return questions
            return {
                'statusCode': 200,
                'body': json.dumps(questions)
            }
        else:
            status, res = mcq_topic(topic, num_questions)
            # store if not error
            if status == 200:
                item = {"topic_id": topic, "questions": res}
                print(item)
                questions_table.put_item(Item=item)
                # return json.loads(res)
                return {
                    'statusCode': 200,
                    'body': res
                }
    except Exception as e:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': e})
        }


def mcq_topic(topic, num_questions):  # (int, str)
    mcq_topic_prompt = """
    Create %d questions about %s in exactly the following json format, including the outer brackets:
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
    """ % (num_questions, topic)
    return get_chatgpt(mcq_topic_prompt)


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
