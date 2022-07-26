# ----------------
# Presenter
# ----------------

__pragma__("alias", "S", "$")

from model import Model
from view import View


class Presenter:
    def __init__(self):
        self._model = Model()
        self._view = View()
        self._bind()

    # イベントをバインドする
    def _bind(self):
        S("body").on("todos-updated", self._on_todos_updated)
        # モーダルダイアログ表示の直前
        S("#input-form").on("show.bs.modal", self._on_show_modal)
        # 登録ボタンクリック
        S("#register-button").on("click", self._on_click_register)
        # 完了状態ボタンクリック
        S("#todo-list").on("click", ".toggle-checkbox", self._on_click_checkbox)
        # 削除ボタンクリック
        S("#todo-list").on("click", ".delete-button", self._on_click_delete)

    # 初期表示処理
    def start(self):
        self._model.load_all_todos()

    # todos-updated受信時処理
    def _on_todos_updated(self, event):
        self._view.render_todo_list(self._model.get_all_todos())

    # モーダルダイアログ表示時の処理
    def _on_show_modal(self, event):
        target_id = S(event.relatedTarget).attr("id")
        # 新規登録用モーダル表示
        if target_id == "new-todo":
            self._view.show_new_modal()
        # 更新用モーダル表示
        elif target_id.startswith("update-"):
            todo_id = target_id[7:]
            todo = self._model.get_todo(todo_id)
            self._view.show_update_modal(todo)

    # 登録ボタンクリック受信時の処理
    def _on_click_register(self, event):
        # 入力内容取得
        input_data = self._view.get_input_data()
        # idがあれば更新処理
        if input_data["id"]:
            self._model.update_todo(input_data["id"], input_data)
        # idがなければ新規登録処理
        else:
            self._model.create_todo(input_data)
        # モーダルを閉じる
        self._view.close_modal()

    # 完了状態ボタンクリック時の処理
    def _on_click_checkbox(self, event):
        target_id = S(event.target).attr("id")
        if target_id.startswith("check-"):
            todo_id = target_id[6:]
            self._model.toggle_todo(todo_id)

    # 削除ボタンクリック時の処理
    def _on_click_delete(self, event):
        target_id = S(event.target).attr("id")
        if target_id.startswith("delete-"):
            todo_id = target_id[7:]
            self._model.delete_todo(todo_id)
