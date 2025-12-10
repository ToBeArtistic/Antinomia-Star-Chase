extends Node

var config : ConfigFile = ConfigFile.new()
const CONFIG_FILE_PATH = "user://config.ini"

func _ready() -> void:
	if !FileAccess.file_exists(CONFIG_FILE_PATH):
		config.set_value("game", "hyper_mode", false)
		config.set_value("game", "sensitivity_x", 0.5)
		config.set_value("game", "sensitivity_y", 0.5)

		config.set_value("keybind", "move_left", "A")
		config.set_value("keybind", "move_right", "D")
		config.set_value("keybind", "move_forward", "W")
		config.set_value("keybind", "move_back", "S")
		config.set_value("keybind", "dash", "Shift")
		config.set_value("keybind", "jump", "Space")

		config.set_value("video", "display", "full_screen")
		config.set_value("video", "minimum_fov", 80)
		config.set_value("video", "maximum_fov", 100)

		config.set_value("audio", "master", 100)
		config.set_value("audio", "music", 75)
		config.set_value("audio", "sound_effects", 75)

		config.save(CONFIG_FILE_PATH)
	else:
		config.load(CONFIG_FILE_PATH)
	