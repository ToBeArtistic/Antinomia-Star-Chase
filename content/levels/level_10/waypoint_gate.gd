extends Node3D

@export var waypoint : Waypoint

var open_gate : bool = false

func _ready() -> void:
	visible = open_gate
	waypoint.connect_to_trigger(open)

func open(_body : Node3D) -> void:
	open_gate = true
	visible = open_gate

