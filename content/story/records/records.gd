extends Control

@onready var level_data : Node = $LevelData

@export var record_scene : PackedScene
@export var container : Container

var format : String = "%d:%05.2f"

var record_names : Array[String]

func _ready() -> void:
	for child : Node in container.get_children():
		child.queue_free()
	record_names = Config.record_names
	for level : LevelData in level_data.get_children():
		var record : Control = record_scene.instantiate()
		var name_label : Label = record.find_child("Name")
		var record_time_label : Label = record.find_child("RecordTime")
		name_label.text = level.record_name
		var record_value : Variant = Config.get_setting(Config.SECTION.RECORDS, level.record_name)
		if record_value is float and record_value > 0.0:
			record_time_label.text = get_timer_text(record_value)
			handle_rank_text(record, level, record_value)
		else:
			record_time_label.text = "--"
			var rank_text : Label = record.find_child("Rank")
			rank_text.text = "  "

			

		container.add_child(record)

func get_timer_text(_time : float) -> String:
	@warning_ignore("integer_division")
	var minutes : int = int(_time)/60
	var seconds : float = fmod(_time, 60)
	return format % [minutes, seconds]

func handle_rank_text(record : Node, level : LevelData, record_value : float) -> void:
	var rank_text : Label = record.find_child("Rank")
	rank_text.text = "  "
	if record_value < level.rank_s:
		rank_text.text = "S"
	elif record_value < level.rank_a:
		rank_text.text = "A"
	elif record_value < level.rank_b:
		rank_text.text = "B"
	elif record_value < level.rank_c:
		rank_text.text = "C"