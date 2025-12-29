extends Button

@export var ui_root : LevelUI 
@onready var scene_swapper : SceneSwapper = $SceneSwapper

func _ready() -> void:
	if not ui_root.next_level_file:
		visible = false
		return
	scene_swapper.scene_file = ui_root.next_level_file
	
