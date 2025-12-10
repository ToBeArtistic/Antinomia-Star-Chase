extends Control

@export var container : Container
@export var sensitivity_scene : PackedScene

func _ready() -> void:
	_initialize_actions()

func _initialize_actions() -> void:
	for item in container.get_children():
		item.queue_free()

	var settings : Dictionary[String, Variant] = Config.get_all_settings_in_section(Config.SECTION.GAME)
	for action : String in settings.keys():
		if action.contains("sensitivity_"):
			print_debug("add sens " + action)
			_add_sensitivity(action)


func _add_sensitivity(action : String) -> void:
		var sensitivity : Control = sensitivity_scene.instantiate()
		var label_action : Label = sensitivity.find_child("Action")
		var slider : HSlider = sensitivity.find_child("Slider")
		var label_value : Label = sensitivity.find_child("Value")

		label_action.text = action
		slider.value = Config.get_setting(Config.SECTION.GAME, action)
		label_value.text = "%d" % Config.get_setting(Config.SECTION.GAME, action)
		container.add_child(sensitivity)
		slider.value_changed.connect(_on_sens_slider_changed.bind(sensitivity, action))

func _on_sens_slider_changed(value : float, sensitivity : Control, action : String) -> void:
	var label_value : Label = sensitivity.find_child("Value")
	label_value.text = "%d" % value
	Config.save_setting(Config.SECTION.GAME, action, value)
		
