extends CheckBox

func _ready() -> void:
	button_pressed = Config.get_setting(Config.SECTION.VIDEO, "display") == "full_screen"
	toggled.connect(_toggle_full_screen)

func _toggle_full_screen(toggled_on : bool) -> void:
	Config.set_full_screen(toggled_on)