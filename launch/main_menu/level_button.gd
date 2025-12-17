extends Button

@onready var level_data : LevelData = $"LevelData"

func _ready() -> void:
	mouse_entered.connect(_emit_level_data)
	mouse_exited.connect(_clear_level_data)

func _emit_level_data() -> void:
	var level_data_visual : LevelDataVisualizer = get_tree().get_first_node_in_group("level_data_visual")
	if level_data_visual:
		level_data_visual.set_shown_leveldata(level_data)
	
func _clear_level_data() -> void:
	var level_data_visual : LevelDataVisualizer = get_tree().get_first_node_in_group("level_data_visual")
	if level_data_visual:
		level_data_visual.reset()
