extends Node3D

class_name Waypoint

@onready var area : Area3D = $Area3D
@onready var mesh : MeshInstance3D = $Area3D/Mesh
@onready var light : Light3D = $OmniLight3D
var active : bool = false

func _process(_delta: float) -> void:
	mesh.visible = active
	light.visible = active

func connect_to_trigger(callable : Callable) -> void:
	print_debug("waypoint bound: " + name)
	area.body_entered.connect(callable)