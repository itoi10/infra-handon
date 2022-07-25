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

    # 初期表示処理
    def start(self):
        self._model.load_all_todos()

    # todos-updated受信時処理
    def _on_todos_updated(self, event):
        self._view.render_todo_list(self._model.get_all_todos())
