from chalice import NotFoundError
import pytest
import app


class TestGetTodo:
    # ダミーデータ
    expected_dic = {
        "id": 201,
        "title": "行きたいところ",
        "memo": "銀山温泉",
        "priority": 1,
        "completed": False,
    }

    # データが正しく取得できること
    def test_get_todo_normal(self, monkeypatch):
        # DB取得関数の戻り値にダミーデータを設定
        monkeypatch.setattr("chalicelib.database.get_todo", lambda _: self.expected_dic)

        actual_dic = app.get_todo(201)
        assert actual_dic == self.expected_dic

    # データがなければNotFoundErrorを返すこと
    def test_get_todo_anomalous(self, monkeypatch):

        with pytest.raises(NotFoundError):
            monkeypatch.setattr("chalicelib.database.get_todo", lambda _: 0)
            app.get_todo(202)
