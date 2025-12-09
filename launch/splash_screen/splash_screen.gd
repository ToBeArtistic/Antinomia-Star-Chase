extends Control

@onready var swap : SceneSwapper = $"swap-scene"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		swap.swap_scene()
	
