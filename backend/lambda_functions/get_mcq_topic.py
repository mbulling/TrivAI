import boto3
import json
import os
import openai


# assign DynamoDB table to modify
tableName = "trivai-questions"
dynamo = boto3.resource('dynamodb').Table(tableName)

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
        topic = event["topic"]
        num_questions = event["num_questions"]
        topic_id = topic + str(num_questions) # FIXME: change after finalizing how dbs will be set up
        if num_questions > MAX_QUESTIONS: # FIXME: cap instead of error?
            return {
                'statusCode': 400, # FIXME: should have different error code?
                'body': json.dumps({"error": "Cannot generate more than %d questions at a time." % MAX_QUESTIONS})
            }
       
        res = ""
        key = {'topic_id': topic_id}
        response = dynamo.get_item(Key=key)
        if 'Item' in response:
            res = response['Item']['questions']
        else:
            status, res = mcq_topic(topic, num_questions)
            # store if not error
            if status == 200:
                item = {"Item": {"topic_id": topic_id, "questions": res}}
                dynamo.put_item(**item)
        
        return {
            'statusCode': 200,
            'body': res
        }
    except:
        return {
            'statusCode': 400,
            'body': json.dumps({"error": "The provided event was malformed."}) # not necessarily the case
        }
        
    
def mcq_topic(topic, num_questions):
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
def get_chatgpt(prompt) -> str:
    completion = openai.ChatCompletion.create(
        api_key=OPENAI_API_KEY,
        model="gpt-3.5-turbo",
        messages=[{"role": "user",
                   "content": prompt}]
    )
    content = completion["choices"][0]["message"]["content"]

    try:
        json.loads(content)
        return 200, content
    except:
        return 400, json.dumps({"error": "OpenAI did not return a json string"})