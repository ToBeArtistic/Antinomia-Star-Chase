extends Control

var waypoint_manager : WaypointManager

@onready var left : Control = $Left
@onready var right : Control = $Right
@onready var top : Control = $Top
@onready var bottom : Control = $Bottom
@onready var marker : TextureRect = $WaypointMarker
var margin : int = 3
var offset : Vector2
var random_offset : Vector2

func _enter_tree() -> void:
	Signals.waypoint_manager_changed.connect(_handle_waypointmanager)
	

func _ready() -> void:
	offset = marker.size / 2.0


func _process(_delta: float) -> void:
	if not waypoint_manager || not waypoint_manager.has_active_waypoint():
		marker.visible = false
		return
	
	marker.visible = true
	random_offset = Vector2(randf_range(-3,3), randf_range(-3, 3))

	var unproject_position : Vector2 = waypoint_manager.get_waypoint_unproject_position()

	if waypoint_manager.is_waypoint_behind():
		marker.position = get_edge_vector2(unproject_position, true) - offset + random_offset
	else:
		marker.position = get_clamped_vector2(unproject_position) - offset + random_offset

	marker.rotation_degrees = randf_range(-3.5, 3.5)

func _handle_waypointmanager(_waypoint_manager : WaypointManager) -> void:
	waypoint_manager = _waypoint_manager
	print_debug(name + " changed waypoint manager to " + waypoint_manager.name)


	


func get_clamped_vector2(coordinates:Vector2) -> Vector2:
	var x : float = clamp(coordinates.x, left.position.x+margin, right.position.x-margin)
	var y : float = clamp(coordinates.y, top.position.y+margin, bottom.position.y-margin)
	var clamped : Vector2 = Vector2(x,y)
	return clamped

func get_edge_vector2(coordinates:Vector2, only_sides:bool) -> Vector2:
	var clamped : Vector2 = get_clamped_vector2(coordinates)
	var closest_to_top : float = clamped.y > (bottom.position.y / 2.0)
	var closest_to_left : float = left.position.x + clamped.x > (right.position.x / 2.0)
	
	var y : float
	var x : float
	if closest_to_top:
		y = top.position.y + margin
	else:
		y = bottom.position.y - margin
	if only_sides:
		y = clamped.y
	
	if closest_to_left:
		x = left.position.x + margin
	else:
		x = right.position.x - margin
	return Vector2(x, y)