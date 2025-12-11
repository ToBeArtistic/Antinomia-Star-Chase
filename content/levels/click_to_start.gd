extends Button

var has_paused_tree : bool = false

func _ready() -> void:
	pressed.connect(_remove_self)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_remove_self()

func _process(_delta: float) -> void:
	if not has_paused_tree:
		get_tree().paused = true
		has_paused_tree = true

func _remove_self() -> void:
	get_tree().paused = false
	queue_free()