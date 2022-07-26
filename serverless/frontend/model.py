# ----------------
# モデル
# ----------------

__pragma__("alias", "S", "$")

from const import BASE_URL


class Model:
    def __init__(self):
        self._todos = []

    # ----------------
    # Todo取得
    # ----------------

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
            self._success_load_all_todos
        ).fail(
            # 失敗
            lambda d: alert("サーバーとの通信に失敗しました。")
        )

    def _success_load_all_todos(self, data):
        self._todos = data
        S("body").trigger("todos-updated")

    # ----------------
    # Todo登録
    # ----------------

    # 登録APIコール
    def create_todo(self, data):
        S.ajax(
            {
                "url": f"{BASE_URL}todos",
                "type": "POST",
                "contentType": "application/json",
                # Pythonのjsonモジュールだとトランスコンパイル時にエラーになるのでJSの機能を使用
                "data": JSON.stringify(data),
            }
        ).done(
            # 成功
            self._success_create_todo
        ).fail(
            # 失敗
            lambda d: alert("サーバーとの通信に失敗しました。")
        )

    def _success_create_todo(self, data):
        self._todos.append(data)
        S("body").trigger("todos-updated")

    # ----------------
    # Todo更新
    # ----------------

    # 更新APIコール（内容変更）
    def update_todo(self, todo_id, data):
        send_data = {}
        for key in ["title", "memo", "priority", "completed"]:
            if key in data:
                send_data[key] = data[key]
        S.ajax(
            {
                "url": f"{BASE_URL}todos/{todo_id}",
                "type": "PUT",
                "contentType": "application/json",
                "data": JSON.stringify(send_data),
            }
        ).done(
            # 成功
            self._success_update_todo
        ).fail(
            # 失敗
            lambda d: alert("サーバーとの通信に失敗しました。")
        )

    def _success_update_todo(self, data):
        for i, todo in enumerate(self._todos):
            if todo["id"] == data["id"]:
                self._todos[i] = data
        S("body").trigger("todos-updated")

    # 更新APIコール（完了状態反転）
    def toggle_todo(self, todo_id):
        todo = self.get_todo(todo_id)
        self.update_todo(todo_id, {"completed": not todo["completed"]})

    # ----------------
    # Todo削除
    # ----------------
    def delete_todo(self, todo_id):
        S.ajax({"url": f"{BASE_URL}todos/{todo_id}", "type": "DELETE",}).done(
            # 成功
            self._success_delete_todo
        ).fail(
            # 失敗
            lambda d: alert("サーバーとの通信に失敗しました。")
        )

    def _success_delete_todo(self, data):
        for i, todo in enumerate(self._todos):
            # 削除されたidのレコードをリストから削除
            if todo["id"] == data["id"]:
                self._todos.pop(i)
                break
        S("body").trigger("todos-updated")
