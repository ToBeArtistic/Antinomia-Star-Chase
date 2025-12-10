extends Label

var _time : float = 0.0
var _format : String = "%d:%05.2f"

func _process(delta: float) -> void:
	_time += delta
	@warning_ignore("integer_division")
	var minutes : int = int(_time)/60
	var seconds : float = fmod(_time, 60)
	text = _format % [minutes, seconds]
