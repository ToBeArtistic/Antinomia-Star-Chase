extends Button

func _ready() -> void:
	pressed.connect(yell)

func yell() -> void:
	print_debug("I'm here!")