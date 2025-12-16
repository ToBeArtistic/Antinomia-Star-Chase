extends Button

func _ready() -> void:
	pressed.connect(_reset_records)

func _reset_records() -> void:
	Config.reset_records()
	get_tree().reload_current_scene()
