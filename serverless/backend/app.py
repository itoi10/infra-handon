from chalice import Chalice, NotFoundError
from chalicelib import database

app = Chalice(app_name='backend')


@app.route('/')
def index():
    return {'hello': 'world'}

# 全Todo取得
@app.route('/todos', methods=['GET'])
def get_all_todos():
    return database.get_all_todos()

# 指定されたIDのTodo取得
@app.route('/todos/{todo_id}', methods=['GET'])
def get_todo(todo_id):
    todo = database.get_todo(todo_id)
    if todo:
        return todo
    # データが見つかれなければ404を返す
    else:
        raise NotFoundError('Todo not found.')

