extends Node

class_name PlayerData

var health : float = 100
var max_health : float = 100

var velocity : float = 0.0

var has_jump : bool = true
var has_double_jump : bool = true

var dash_cooldown : float = 0.0
var dash_max_time : float = 1.0

func get_jump_pct() -> float:
	var result := 0.0
	if has_jump:
		result += 50.0
	if has_double_jump:
		result += 50.0
	return result

func get_dash_pct() -> float:
	dash_cooldown = clampf(dash_cooldown, 0.0, dash_cooldown)
	return 100.0 - (dash_cooldown / dash_max_time * 100.0)

