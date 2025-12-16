extends Node

class_name MusicOnReadyRequester

@export var theme_name : String = "main_theme"

func _process(_delta: float) -> void:
	if not AudioGlobal.current_theme == theme_name:
		AudioGlobal.start_music(theme_name)
	queue_free()
