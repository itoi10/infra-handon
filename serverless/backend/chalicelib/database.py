# NOTE 本格的な実装は後でする
# とりあえずスタブ

# 擬似データベース定義
SAMPLE_DB = [
    {
    'id': '1',
    'title': '次に見る',
    'memo': 'ゴールデンカムイ',
    'priority': 3,
    'completed': False,
    },
    {
    'id': '2',
    'title': '買い物',
    'memo': '納豆',
    'priority': 2,
    'completed': False,
    },
    {
    'id': '3',
    'title': '本',
    'memo': '『渋谷ではたらく社長の告白』',
    'priority': 1,
    'completed': False,
    },
]

# 全レコード取得
def get_all_todos():
    return SAMPLE_DB

# 指定されたIDのレコード取得
def get_todo(todo_id):
    for todo in SAMPLE_DB:
        if todo['id'] == todo_id:
            return todo
    return None