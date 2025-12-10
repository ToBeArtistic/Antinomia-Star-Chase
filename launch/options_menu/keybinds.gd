extends Control

@export var keybind_button_scene : PackedScene
@export var keybind_container : Container

var is_remapping : bool = false
var action_to_remap : String
var keybind_remap_button : Button

func _ready() -> void:
	_initialize_actions()

func _initialize_actions() -> void:
	for item in keybind_container.get_children():
		item.queue_free()

	var keybinds : Dictionary[String, Variant] = Config.get_all_settings_in_section(Config.SECTION.KEYBIND)
	for action : String in keybinds.keys():
		var button : Button = keybind_button_scene.instantiate()
		var label_action : Label = button.find_child("Action")
		var label_keybind : Label = button.find_child("Keybind")

		label_action.text = action
		label_keybind.text = keybinds.get(action)
		label_keybind.text = label_keybind.text.trim_suffix(" (Physical)")	
		keybind_container.add_child(button)
		button.pressed.connect(_on_keybind_button_pressed.bind(button, action))

func _on_keybind_button_pressed(button : Button, action : String) -> void:
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		keybind_remap_button = button
		var label_keybind : Label = keybind_remap_button.find_child("Keybind") as Label
		label_keybind.text = "Press key to bind..."

func _input(event: InputEvent) -> void:
	if is_remapping:
		if (
			event is InputEventKey || (event is InputEventMouseMotion && event.is_pressed())
		):
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(keybind_remap_button, event)
			accept_event()
			is_remapping = false
			

func _update_action_list(button : Button, event : InputEvent) -> void:
	var label_keybind : Label = button.find_child("Keybind") as Label
	label_keybind.text = event.as_text().trim_suffix(" (Physical)")	
	Config.save_setting(Config.SECTION.KEYBIND, action_to_remap, event.as_text())		