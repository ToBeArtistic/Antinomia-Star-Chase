extends Button

func _ready() -> void:
	pressed.connect(resume)

func resume() -> void:
	Signals.pause_game.emit()