import os
import boto3
from boto3.dynamodb.conditions import Key
import uuid

# 環境変数からDB接続情報を取得しDynamoDBオブジェクトを取得
def _get_database():
    endpoint = os.environ.get('DB_ENDPOINT')
    if endpoint:
        return boto3.resource('dynamodb', endpoint_url=endpoint)
    else:
        return boto3.resource('dynamodb')

# 全取得
def get_all_todos():
    table = _get_database().Table(os.environ['DB_TABLE_NAME'])
    responce = table.scan()
    return responce['Items']

# 取得
def get_todo(todo_id:str):
    table = _get_database().Table(os.environ['DB_TABLE_NAME'])
    responce = table.query(
        KeyConditionExpression=Key('id').eq(todo_id)
    )
    items = responce['Items']
    if items:
        return items[0] 
    else:
        return None

# 登録
def create_todo(todo:dict):
    item = {
        'id': uuid.uuid4().hex,
        'title': todo['title'],
        'memo': todo['memo'],
        'priority': todo['priority'],
        'completed': False,
    }

    table = _get_database().Table(os.environ['DB_TABLE_NAME'])
    table.put_item(Item=item)
    return item

# 更新
def update_todo(todo_id:str, changes:dict):
    table = _get_database().Table(os.environ['DB_TABLE_NAME'])

    # クエリ構築         e.g. changes = {'title' 'タイトル', 'memo': 'メモ'}
    update_expression = []          # ['title = :t', 'memo = :m']     
    expression_attribute_value = {} # {':t': 'タイトル', ':m': 'メモ'}
    for key in ['title', 'memo', 'priority', 'completed']:
        if key in changes:
            update_expression.append(f'{key} = :{key[0:1]}')
            expression_attribute_value[f':{key[0:1]}'] = changes[key]
    
    # DynamoDBのデータ更新
    result = table.update_item(
        Key={'id': todo_id},
        UpdateExpression='set ' + ','.join(update_expression),
        ExpressionAttributeValues=expression_attribute_value,
        ReturnValues='ALL_NEW' # 更新後の値
    )
    return result['Attributes']

# 削除
def delete_todo(todo_id:str):
    table = _get_database().Table(os.environ['DB_TABLE_NAME'])
    # DynamoDBのデータ削除
    result = table.delete_item(
        Key={'id': todo_id},
        ReturnValues='ALL_OLD' # 更新後の値
    )
    return result['Attributes']