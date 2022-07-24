import os
import boto3
from boto3.dynamodb.conditions import Key

# 環境変数からDB接続情報を取得
def _get_database():
    endpoint = os.environ.get('DB_ENDPOINT')
    if endpoint:
        return boto3.resource('dynamodb', endpoint_url=endpoint)
    else:
        boto3.resource('dynamodb')

# 全レコード取得
def get_all_todos():
    table = _get_database().Table(os.environ['DB_TABLE_NAME'])
    responce = table.scan()
    return responce['Items']

# 指定されたIDのレコード取得
def get_todo(todo_id):
    table = _get_database().Table(os.environ['DB_TABLE_NAME'])
    responce = table.query(
        KeyConditionExpression=Key('id').eq(todo_id)
    )
    items = responce['Items']
    if items:
        return items[0] 
    else:
        return None
