extends Node

@export var label : RichTextLabel

var fade_duration = 2.0

func _ready():
	fade_in()

func fade_in():
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate:a", 0, 0)
	tween.tween_property(label, "modulate:a", 1, fade_duration)
	tween.play()
	await tween.finished
	tween.kill()
