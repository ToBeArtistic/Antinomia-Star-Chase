extends Control

class_name LevelUI

@export var record_name : String
@export var level_data_scene : PackedScene
@export_file("*.tscn", "*.scn") var next_level_file : String

var level_data : LevelData

@onready var goal : GoalHandler = $Goal

func _ready() -> void:
	level_data = level_data_scene.instantiate()
	add_child(level_data)
	goal.level_data = level_data
