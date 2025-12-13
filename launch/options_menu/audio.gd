extends Control

@export var container : Container
@export var setting_scene : PackedScene

func _ready() -> void:
	_initialize_actions()

func _initialize_actions() -> void:
	for item in container.get_children():
		item.queue_free()

	var settings : Dictionary[String, Variant] = Config.get_all_settings_in_section(Config.SECTION.AUDIO)
	for action : String in settings.keys():
		print_debug("add sens " + action)
		_add_setting(action)

func _add_setting(action : String) -> void:
	var setting : Control = setting_scene.instantiate()
	var label_action : Label = setting.find_child("Action")
	var slider : HSlider = setting.find_child("Slider")
	var label_value : Label = setting.find_child("Value")
	
	label_action.text = action
	slider.value = Config.get_setting(Config.SECTION.AUDIO, action)
	label_value.text = "%d" % Config.get_setting(Config.SECTION.AUDIO, action)
	container.add_child(setting)
	slider.value_changed.connect(_on_audio_setting_changed.bind(setting, action))

func _on_audio_setting_changed(value : float, setting : Control, action : String) -> void:
	var label_value : Label = setting.find_child("Value")
	label_value.text = "%d" % value
	Config.save_setting(Config.SECTION.AUDIO, action, value)
	Config.refresh_audio()
