extends Node

var _config : ConfigFile = ConfigFile.new()
const CONFIG_FILE_PATH = "user://_config.ini"

signal settings_changed

enum SECTION 
{
	GAME,
	KEYBIND,
	VIDEO,
	AUDIO,
	RECORDS
}

var record_names : Array[String] = [
	"LEVEL ONE",
	"LEVEL TWO",
	"LEVEL THREE",
	"LEVEL FOUR",
	"LEVEL FIVE",
	"LEVEL SIX",
	"LEVEL SEVEN",
	"LEVEL EIGHT",
	"LEVEL NINE",
	"LEVEL TEN",
]

func _ready() -> void:
	if !FileAccess.file_exists(CONFIG_FILE_PATH):
		_reset_config_file()
	else:
		_config.load(CONFIG_FILE_PATH)

	for section : SECTION in SECTION.values():
		if not _config.has_section(_get_section(section)):
			_reset_config_file()
	
	for _name in record_names:
		if not _config.has_section_key("records", _name):
			reset_records()
	_initialize_settings_in_game()

func _initialize_settings_in_game() -> void:
	_load_keybinds()
	_load_display_setting()
	_load_audio_setting()

func save_setting(section : SECTION, key : String, value : Variant) -> void:
	_config.set_value(_get_section(section), key, value)
	_config.save(CONFIG_FILE_PATH)

func get_setting(section : SECTION, key : String) -> Variant:
	return _config.get_value(_get_section(section), key, null)

func has_setting(section : SECTION, key : String) -> bool:
	return _config.has_section_key(_get_section(section), key)

func get_all_settings_in_section(section: SECTION) -> Dictionary[String, Variant]:
	var settings : Dictionary[String, Variant] = {}
	for key in get_section_keys(section):
		var value : Variant = get_setting(section, key)
		settings.set(key, value)
	return settings

func get_section_keys(section : SECTION) -> PackedStringArray:
	return _config.get_section_keys(_get_section(section))

func _get_section(section : SECTION) -> String:
	match section:
		SECTION.GAME:
			return "game"
		SECTION.KEYBIND:
			return "keybind"
		SECTION.VIDEO:
			return "video"
		SECTION.AUDIO:
			return "audio"
		SECTION.RECORDS:
			return "records"
	return ""

func _load_keybinds() -> void:
	for action in get_section_keys(SECTION.KEYBIND):
		var keybind : String = get_setting(SECTION.KEYBIND, action)
		InputMap.action_erase_events(action)
		if keybind.contains("mouse_"):
			var mouse_input : InputEventMouseButton = InputEventMouseButton.new()
			mouse_input.button_index =  int(keybind.split("_")[1]) as MouseButton
			InputMap.action_add_event(action, mouse_input)
		else:
			var input : InputEventKey = InputEventKey.new()
			input.keycode = OS.find_keycode_from_string(keybind)
			InputMap.action_add_event(action, input)

func _load_display_setting() -> void:
	var display_mode : String = get_setting(Config.SECTION.VIDEO, "display") 
	var full_screen: bool = display_mode == "full_screen"
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if full_screen else DisplayServer.WINDOW_MODE_WINDOWED)

func refresh_audio() -> void:
	_load_audio_setting()

func _load_audio_setting() -> void:
	var audio_settings : Dictionary[String, Variant] = get_all_settings_in_section(Config.SECTION.AUDIO)
	var master_volume : float = audio_settings.get("master") / 100.0
	var music_volume : float = audio_settings.get("music") /100.0
	var sfx_volume : float = audio_settings.get("sound_effects") /100.0
	_set_bus_volume("Master", master_volume)
	_set_bus_volume("Music", music_volume)
	_set_bus_volume("SFX", sfx_volume)

func _set_bus_volume(bus_name : String, value : float) -> void:
		AudioServer.set_bus_volume_linear(
		AudioServer.get_bus_index(bus_name),
		value
	)
		

func set_full_screen(value : bool) -> void:
	var string_value : String = "windowed"
	if value:
		string_value = "full_screen"
	save_setting(Config.SECTION.VIDEO, "display", string_value)
	_load_display_setting()

func _reset_config_file() -> void:
		_config = ConfigFile.new()
		_config.set_value("game", "hyper_mode", false)
		_config.set_value("game", "sensitivity_x", 50)
		_config.set_value("game", "sensitivity_y", 50)

		_config.set_value("keybind", "move_left", "A")
		_config.set_value("keybind", "move_right", "D")
		_config.set_value("keybind", "move_forward", "W")
		_config.set_value("keybind", "move_back", "S")
		_config.set_value("keybind", "dash", "Shift")
		_config.set_value("keybind", "jump", "Space")

		_config.set_value("video", "display", "full_screen")
		_config.set_value("video", "minimum_fov", 80)
		_config.set_value("video", "maximum_fov", 100)

		_config.set_value("audio", "master", 100)
		_config.set_value("audio", "music", 75)
		_config.set_value("audio", "sound_effects", 75)

		reset_records()

		_config.save(CONFIG_FILE_PATH)

func reset_records() -> void:
	for _name in record_names:
		_config.set_value("records", _name, -1.0)
