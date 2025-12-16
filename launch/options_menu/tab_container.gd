extends TabContainer

func _ready() -> void:
	var tabs : TabBar = get_tab_bar()
	tabs.tab_changed.connect(_play_sound.bind("pressed"))
	tabs.tab_hovered.connect(_play_sound.bind("hover"))

func _play_sound(_index : int, sound : String) -> void:
	AudioGlobal.play_named_sfx(sound)


