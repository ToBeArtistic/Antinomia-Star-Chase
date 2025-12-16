extends Node

var data : Dictionary[String, Variant] = {

}

var theme_offsets : Dictionary[String, float] = {}

func _ready() -> void:
	print_debug(data)


func reset_theme_offsets() -> void:
	theme_offsets = {}
	

