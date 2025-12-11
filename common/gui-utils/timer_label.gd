extends Label

class_name SimpleTimerElement

var stopped : bool = false
var time : float = 0.0
var format : String = "%d:%05.2f"

func _process(delta: float) -> void:
	if stopped:
		return
	_update_time(delta)	

func _update_time(delta : float) -> void:
	time += delta
	text = get_timer_text(time)

func get_timer_text(_time : float) -> String:
	@warning_ignore("integer_division")
	var minutes : int = int(_time)/60
	var seconds : float = fmod(_time, 60)
	return format % [minutes, seconds]
