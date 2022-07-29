import requests

endpoint = "http://127.0.0.1:8000/todos"
expected_dic = {
    "id": "1",
    "title": "次に見る",
    "memo": "ゴールデンカムイ",
    "priority": 3,
    "completed": False,
}

# 指定のTodoが含まれていること
def test_get_all_todos():
    res = requests.get(endpoint)
    actual_json = res.json()

    assert expected_dic in actual_json
