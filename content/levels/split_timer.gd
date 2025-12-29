extends Label

class_name SplitTimerElement

@export var neutral_color : Color = Color.WHITE
@export var fast_color : Color = Color.BLUE
@export var slow_color : Color = Color.RED

var time : float = 0.0
var format : String = "%d:%05.2f"

func _ready() -> void:
	visible = false

func set_time(_time : float, neutral : bool = false) -> void:
	time = _time
	visible = true
	text = get_timer_text(time, neutral)

	if neutral:
		add_theme_color_override("font_color", neutral_color)
	elif time >= 0.0:
		add_theme_color_override("font_color", slow_color)
	else:
		add_theme_color_override("font_color", fast_color)

func get_timer_text(_time : float, neutral : bool) -> String:
	var prefix_sign : String = "+"
	var minutes : int = int(_time/60)
	var seconds : float = fmod(_time, 60)
	if seconds < 0.0:
		seconds = seconds * -1
		prefix_sign = "-"
	if neutral:
		prefix_sign = ""
	return prefix_sign + format % [minutes, seconds]