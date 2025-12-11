extends Node3D

class_name Waypoint

@onready var area : Area3D = $Area3D
@onready var mesh : MeshInstance3D = $Area3D/Mesh
var active : bool = false

func _process(_delta: float) -> void:
	mesh.visible = active

func connect_to_trigger(callable : Callable) -> void:
	print_debug("waypoint bound: " + name)
	area.body_entered.connect(callable)