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
	if load_scene_on_ready and scene_file:
		scene = load(scene_file)
	if get_parent() is Button:
		var button : Button = get_parent()
		button.pressed.connect(swap_scene)
		print_debug(name + " connected to " + button.name)

func swap_scene() -> void:	
	print_debug(name + " trying scene swap to " + scene_file)
	if back_button:
		swap_to_previous_scene()
		return

	if not scene_file:
		print_debug("no scene file defined")
		return
	
	if not scene:
		print_debug("loading scene " + scene_file)
		scene = load(scene_file)

	if add_to_history:
		scene_history.append(get_tree().current_scene.scene_file_path)

	get_tree().change_scene_to_packed(scene)

func swap_to_previous_scene() -> void:
	var previous : String
	if scene_history.is_empty():
		print_debug("scene history is empty, using fallback scene")
		previous = scene_file
	else:
		previous = scene_history.pop_back()
	print_debug("try swap to " + previous)
	if not scene:
		scene = load(previous)
	get_tree().change_scene_to_packed(scene)
