extends Control

@export var record_name : String

@onready var goal : GoalHandler = $Goal

func _ready() -> void:
	goal.record_name = record_name
