from chalice import Chalice, NotFoundError, BadRequestError
from chalicelib import database

app = Chalice(app_name='backend')


@app.route('/')
def index():
    return {'hello': 'world'}

# ----------------
# Todo CRUD
# ----------------

# 全取得
@app.route('/todos', methods=['GET'])
def get_all_todos():
    return database.get_all_todos()

# 取得
@app.route('/todos/{todo_id}', methods=['GET'])
def get_todo(todo_id):
    todo = database.get_todo(todo_id)
    if todo:
        return todo
    # データが見つかれなければ404を返す
    else:
        raise NotFoundError('Todo not found.')

# 登録
@app.route('/todos', methods=['POST'])
def create_todo():
    # リクエストボディ取得
    todo = app.current_request.json_body
    # 必須項目チェック
    for key in ['title', 'memo', 'priority']:
        if key not in todo:
            raise BadRequestError(f'{key} is required.')
    # DB登録
    # NOTE: 200が返るが201にしたほう方が良い？
    return database.create_todo(todo)

# 更新
@app.route('/todos/{todo_id}', methods=['PUT'])
def update_todo(todo_id):
    changes = app.current_request.json_body
    # データ更新
    return database.update_todo(todo_id, changes)

# 削除
@app.route('/todos/{todo_id}', methods=['DELETE'])
def delete_todo(todo_id):
    # データ削除
    return database.delete_todo(todo_id)