extends SubViewportContainer

func _ready() -> void:
	Signals.pause_game.connect(handle_game_paused)

func handle_game_paused() -> void:
	if get_tree().paused:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_PASS