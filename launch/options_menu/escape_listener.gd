extends Node

var button : Button

func _ready() -> void:
		if get_parent() is Button:
			button = get_parent()
		

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		button.pressed.emit()
