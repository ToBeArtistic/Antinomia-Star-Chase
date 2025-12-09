@tool
extends Node

class_name SceneSwapper

@export_file("*.tscn", "*.scn") var scene_file : String
@export var add_to_history : bool = true
@export var back_button : bool = false
@export var load_scene_on_ready : bool = true

var scene : PackedScene

static var scene_history : Array[String] = []

func _ready() -> void:
	print_debug("sceneswapper initialized: " + scene_file)
	if load_scene_on_ready:
		scene = load(scene_file)
	if get_parent() and get_parent().has_signal("pressed"):
		get_parent().pressed.connect(swap_scene)

func swap_scene() -> void:	
	print_debug("trying scene swap")
	if not scene:
		print_debug("loading scene " + scene_file)
		scene = load(scene_file)

	if add_to_history and not back_button:
		scene_history.append(get_tree().current_scene.scene_file_path)
	
	if back_button:
		swap_to_previous_scene()
	else:
		get_tree().change_scene_to_packed(scene)
	print_debug("end of scene swap")

func swap_to_previous_scene() -> void:
	if scene_history.is_empty():
		return
	get_tree().change_scene_to_file(scene_history.pop_back() as String)
