extends Control

@export var record_scene : PackedScene
@export var container : Container

var format : String = "%d:%05.2f"

var record_names : Array[String]

func _ready() -> void:
	for child : Node in container.get_children():
		child.queue_free()
	record_names = Config.record_names
	for record_name in record_names:
		var record : Control = record_scene.instantiate()
		var name_label : Label = record.find_child("Name")
		var record_time_label : Label = record.find_child("RecordTime")
		name_label.text = record_name
		var record_value : Variant = Config.get_setting(Config.SECTION.RECORDS, record_name)
		if record_value is float and record_value > 0.0:
			record_time_label.text = get_timer_text(record_value)
		else:
			record_time_label.text = "N0Ne FnD"
		container.add_child(record)

func get_timer_text(_time : float) -> String:
	@warning_ignore("integer_division")
	var minutes : int = int(_time)/60
	var seconds : float = fmod(_time, 60)
	return format % [minutes, seconds]
