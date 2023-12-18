import boto3
import json

# assign DynamoDB table to modify
table_name = "multiplayer-games"
dynamo = boto3.resource('dynamodb')
game_table = dynamo.Table(table_name)

def lambda_handler(event, context):
    ''' event should have the following fields:
        - game_id: int
        Returns (topic, questions, num_players). If the game is not found, return ('', [], -1).
        
    '''
    try:
        data = json.loads(event["body"])
        game_id = data["game_id"]
        
        if game_id == 0:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Game ID cannot be 0'})
            }
        
        response = game_table.get_item(Key={"game_id": game_id})
        if 'Item' not in response:
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'topic': '',
                    'questions': [],
                    'num_players': -1
                })
            }
        else:
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'topic': response['Item']['topic'],
                    'questions': json.loads(response['Item']['questions']),
                    'num_players': len(json.loads(response['Item']['players']))
                })
            }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': str(e)})
        }