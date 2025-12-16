extends Node

@onready var sprite : Sprite3D = get_parent()

func _ready() -> void:
	Signals.player_data_updated.connect(_handle_billboarding)

func _handle_billboarding(player_data : PlayerData) -> void:
	sprite.look_at(player_data.position)