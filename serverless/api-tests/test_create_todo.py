import requests
import json

endpoint = "http://127.0.0.1:8000/todos"
headers_dic = {"content-type": "application/json"}
expected_dic = {
    "title": "次の次に見る",
    "memo": "SPYxFAMILY",
    "priority": 3,
}

# Todo作成できること
def test_create_todo():
    res = requests.post(
        endpoint,
        data=json.dumps(expected_dic),
        headers=headers_dic,
    )
    actual_json = res.json()

    assert actual_json["id"]
    for column in ["title", "memo", "priority"]:
        assert actual_json[column] == expected_dic[column]
