extends ColorRect


func _ready() -> void:
	var crosshair_setting : Variant = Config.get_setting(Config.SECTION.GAME, "crosshair")
	if crosshair_setting != null:
		visible = crosshair_setting
