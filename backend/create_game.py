import boto3
import json

# assign DynamoDB table to modify
table_name = "multiplayer-games"
dynamo = boto3.resource('dynamodb')
game_table = dynamo.Table(table_name)

def lambda_handler(event, context):
    ''' event should have the following fields:
        - game_id: int,
        - topic: string,
        - questions: list of dicts
        Adds the game to the game table. Returns an empty dictionary if success.
    '''
    try:
        data = json.loads(event["body"])
        game_id = data["game_id"]
        topic = data["topic"]
        questions = json.dumps(data["questions"])
        
        if game_id == 0:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Game ID cannot be 0'})
            }
        
        item = {"game_id": game_id, "topic": topic, "questions": questions, "players": "{}"}
        game_table.put_item(Item=item)
        
        return {
            'statusCode': 200,
            'body': json.dumps({})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': str(e)})
        }