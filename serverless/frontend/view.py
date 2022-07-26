# ----------------
# ビュー
# ----------------

__pragma__("alias", "S", "$")


class View:

    ## Todoリスト描画
    def render_todo_list(self, data):
        S("#todo-list").empty()
        for todo in data:
            S("#todo-list").append(self._create_todo_row(todo))

    # Todo1行作成
    def _create_todo_row(self, todo):
        return f"""
            <tr>
                <td>
                    <input type='checkbox' class="toggle-checkbox"
                        id='check-{todo['id']}'
                        {'checked' if todo['completed'] else ''}>
                </td>
                <td>{todo['title']}</td>
                <td>{todo['memo']}</td>
                <td>{['低', '中', '高'][int(todo['priority']) - 1]}</td>
                <td>
                    <button class='btn btn-outline-primary update-button'
                        id='update-{todo['id']}' data-toggle='modal'
                        data-target='#input-form'>変更</button>
                </td>
                <td>
                    <button class='btn btn-outline-danger delete-button'
                        id='delete-{todo['id']}'>削除</button>
                </td>
            </tr>
        """

    # 新規登録モーダルダイアログ表示
    def show_new_modal(self):
        S("#modal-title").text("新規登録")
        S("#modal-todo-id").val("")
        S("#modal-todo-title").val("")
        S("#modal-todo-memo").val("")
        S("#modal-todo-priority").val(1)

    # モーダルダイアログを閉じる
    def close_modal(self):
        S("#input-form").modal("hide")

    # モーダルダイアログの入力内容取得
    def get_input_data(self):
        return {
            "id": S("#modal-todo-id").val(),
            "title": S("#modal-todo-title").val(),
            "memo": S("#modal-todo-memo").val(),
            "priority": S("#modal-todo-priority").val(),
        }

    # 変更用モーダルダイアログ表示
    def show_update_modal(self, todo):
        S("#modal-title").text("変更")
        S("#modal-todo-id").val(todo["id"])
        S("#modal-todo-title").val(todo["title"])
        S("#modal-todo-memo").val(todo["memo"])
        S("#modal-todo-priority").val(todo["priority"])
