import boto3
import json


table_name = "multiplayer-games"
dynamo = boto3.resource('dynamodb')
questions_table = dynamo.Table(table_name)


def lambda_handler(event, context):
    ''' [event] contains the following keys:
        - game_id: id of game to add player results to
        - score: score of player
        - name: player name to display
        Adds player and score to game players
    '''
    
    try:
        data = json.loads(event["body"])
        id = data["game_id"]
        score = data["score"]
        name = data["name"]
        
        key = {'game_id': id}
        response = questions_table.get_item(Key=key)
        if 'Item' in response:
            players = json.loads(response['Item']['players'])
            
            # add to players
            if name in players:
                players[name] = max(players[name], score)
            else:
                players[name] = score
            

            # update table
            response = questions_table.update_item(
                    Key=key,
                    UpdateExpression="set players=:q",
                    ExpressionAttributeValues={
                        ':q': json.dumps(players)},
                    ReturnValues="UPDATED_NEW")
            return {
                'statusCode': 200,
                'body': json.dumps({})
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