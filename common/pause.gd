extends Control

class_name PauseMenu

func _ready() -> void:
	visible = false
	Signals.pause_game.connect(toggle_pause)
	if get_tree().paused:
		toggle_pause()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	visible = get_tree().paused
	if visible:
		mouse_filter = Control.MOUSE_FILTER_STOP
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	 