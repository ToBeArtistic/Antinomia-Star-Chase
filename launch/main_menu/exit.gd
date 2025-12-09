extends Button


func _ready() -> void:
	pressed.connect(exit_game)

func exit_game():
	get_tree().quit()