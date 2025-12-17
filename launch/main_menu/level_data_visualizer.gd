extends MarginContainer

class_name LevelDataVisualizer


@onready var title : Label = $"VBoxContainer/LevelTitleLabel"
@onready var description : Label = $"VBoxContainer/LevelDescriptionLabel"

func _ready() -> void:
	reset()

func set_shown_leveldata(data : LevelData) -> void:
	title.text = data.title
	description.text = data.description

func reset() -> void:
	title.text = ""
	description.text = ""

