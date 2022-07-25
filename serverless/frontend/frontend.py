# Sを$に置き換えるTranscryptのエイリアス定義
__pragma__("alias", "S", "$")

from presenter import Presenter

presenter = Presenter()
# $(presenter.start());
S(presenter.start())
