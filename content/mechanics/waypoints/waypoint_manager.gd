extends Node3D

class_name WaypointManager

signal waypoints_completed

@onready var pickup_sound : AudioStreamPlayer = $PickupSound

var _waypoints : Array[Waypoint] = []
var _active_waypoint : Waypoint
var _current_index : int = 0

func _ready() -> void:
	for child in get_children():
		if child is Waypoint:
			var waypoint : Waypoint = child
			waypoint.connect_to_trigger(_handle_waypoint_trigger.bind(waypoint))
			_waypoints.append(waypoint)
	if not _waypoints.is_empty():
		_active_waypoint = _waypoints[0]
		_active_waypoint.active = true
	print_debug("active waypoint: " + _active_waypoint.name)
	
	Signals.waypoint_manager_changed.emit(self)

func _handle_waypoint_trigger(_colission_object : Node3D, waypoint : Waypoint) -> void:
	print_debug("waypoint triggered: " + waypoint.name)
	if waypoint.name == _active_waypoint.name and _active_waypoint.active:
		_next_waypoint()
	pass

func _next_waypoint() -> void:
	_play_pickup_sound()

	_active_waypoint.active = false
	if _waypoints.size() > (_current_index+1):
		_current_index += 1
		_active_waypoint = _waypoints[_current_index]
		_active_waypoint.active = true
		print_debug("active waypoint: " + _active_waypoint.name)
	else:
		waypoints_completed.emit()

func get_waypoint_unproject_position() -> Vector2:
	var camera : Camera3D = get_viewport().get_camera_3d()
	var screeenspace_vector : Vector2 = camera.unproject_position(_active_waypoint.global_position)
	return screeenspace_vector

func is_waypoint_behind() -> bool:
	var camera : Camera3D = get_viewport().get_camera_3d()
	return camera.is_position_behind(_active_waypoint.global_position)

func has_active_waypoint() -> bool:
	return _active_waypoint.active

func _play_pickup_sound() -> void:
	pickup_sound.play()