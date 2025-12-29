extends Node

class_name WaypointVisibilityToggle

@export var waypoint : Waypoint
@export var waypoint_list : Array[Waypoint]
@export var toggled_on : bool = false

func _ready() -> void:
	update_parent()
	if waypoint:
		waypoint.connect_to_trigger(waypoint_triggered)
	for _waypoint in waypoint_list:
		_waypoint.connect_to_trigger(waypoint_triggered)

func update_parent() -> void:
	var parent3d : Variant = get_parent()
	parent3d.visible = toggled_on
	if parent3d is CSGShape3D:
		parent3d.use_collision = toggled_on
	update_child_csgs()

func update_child_csgs() -> void:
	var parent : Node = get_parent()
	for child in parent.get_children():
		if child is CSGShape3D:
			var csg : CSGShape3D = child as CSGShape3D
			csg.use_collision = toggled_on

func waypoint_triggered(_waypoint : Node3D) -> void:
	toggle()

func toggle() -> void:
	toggled_on = not toggled_on
	update_parent()