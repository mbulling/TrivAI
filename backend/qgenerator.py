import openai
import json

try:
    from secrets import OPENAI_API_KEY
    mason_api_key = OPENAI_API_KEY
except:
    mason_api_key = 'no api key found'


# get ChatGPT response to given prompt
def get_chatgpt(prompt) -> str:
    completion = openai.ChatCompletion.create(
        api_key=mason_api_key,
        model="gpt-3.5-turbo",
        messages=[{"role": "user",
                   "content": prompt}]
    )
    content = completion["choices"][0]["message"]["content"]

    try:
        json.loads(content)
        return content
    except:
        print(content)
        return json.dumps({"error": "OpenAI did not return a json string"})


# get MCQs based on a passage
def get_mcqs_passage(passage, num_questions):
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


# get MCQs based on a topic
def get_mcqs_topic(topic, num_questions):
    mcq_topic_prompt = """
    Create %d questions about %s in the following json format:
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


# get TF questions based on a passage
def get_tfs_passage(passage, num_questions):
    tf_passage_prompt = """
    Create %d true or false questions about the following passage in exactly the following json format:
    [
        {
            "question": question,
            "answer": answer
        },
        {
            "question": question,
            "answer": answer
        }, ...
    ]
    Passage: %s
    """ % (num_questions, passage)
    return get_chatgpt(tf_passage_prompt)


# get TF questions based on a topic
def get_tfs_topic(topic, num_questions):
    tf_topic_prompt = """
    Create %d true or false questions about %s in the following json format:
    [
        {
            "question": question,
            "answer": answer
        },
        {
            "question": question,
            "answer": answer
        }, ...
    ]
    """ % (num_questions, topic)
    return get_chatgpt(tf_topic_prompt)
