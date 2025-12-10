extends Node

@export var label : RichTextLabel

var fade_duration : float = 2.0

func _ready() -> void:
	fade_in()

func fade_in() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(label, "modulate:a", 0, 0)
	tween.tween_property(label, "modulate:a", 1, fade_duration)
	tween.play()
	await tween.finished
	tween.kill()
