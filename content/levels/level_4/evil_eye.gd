extends Sprite3D

@onready var starting_position : Vector3 = position
@export var wiggle_factor : float = 0.2

func _physics_process(_delta: float) -> void:
	position = starting_position + Vector3(
		randf_range(-wiggle_factor, wiggle_factor), 
		randf_range(-wiggle_factor, wiggle_factor), 
		randf_range(-wiggle_factor, wiggle_factor)
	)
	