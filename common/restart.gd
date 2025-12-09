extends Button

func _ready() -> void:
	pressed.connect(restart)

func restart() -> void:
	get_tree().reload_current_scene()