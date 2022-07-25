# ----------------
# モデル
# ----------------

__pragma__("alias", "S", "$")

from const import BASE_URL


class Model:
    def __init__(self):
        self._todos = []

    # 指定されたIDのTodo取得
    def get_todo(self, todo_id):
        for todo in self._todos:
            if todo["id"] == todo_id:
                return todo
        # no hit
        return None

    # 全Todo取得
    def get_all_todos(self):
        return self._todos

    # 全件取得APIコール
    def load_all_todos(self):
        S.ajax({"url": f"{BASE_URL}todos", "type": "GET",}).done(
            # 成功
            self._success_load_all_todos()
        ).fail(
            # 失敗
            lambda d: alert("APIサーバとの通信に失敗しました")
        )

    def _success_load_all_todos(self, data):
        self._todos = data
        S("body").trigger("todos-updated")
