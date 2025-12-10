extends Button


func _ready() -> void:
	pressed.connect(exit_game)

func exit_game() -> void:
	get_tree().quit()