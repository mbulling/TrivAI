import boto3
import json


table_name = "multiplayer-games"
dynamo = boto3.resource('dynamodb')
questions_table = dynamo.Table(table_name)


def lambda_handler(event, context):
    ''' [event] contains the following keys:
        - game_id: id of game to get results for
        Returns all finished players for game game_id
    '''
    try:
        data = json.loads(event["body"])
        id = data["game_id"]
        
        key = {'game_id': id}
        response = questions_table.get_item(Key=key)
        if 'Item' in response:
            players = json.loads(response['Item']['players'])
            players = json.dumps(players)
            return {
                'statusCode': 200,
                'body': players
            }
        else:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': "couldn't load players"})
            }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': str(e)})
        }
        
            
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
