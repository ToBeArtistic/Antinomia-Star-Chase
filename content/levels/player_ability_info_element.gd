extends MarginContainer

@onready var dash_slider : Slider = $"AbilityInfoContainer/DashContainer/DashSlider"
@onready var jump_slider : Slider = $"AbilityInfoContainer/JumpContainer/JumpSlider"

func _ready() -> void:
	Signals.player_data_updated.connect(_update_elements)

func _update_elements(data : PlayerData) -> void:
	dash_slider.value = data.get_dash_pct()
	jump_slider.value = data.get_jump_pct()
