extends ColorRect

var velocity : float = 50.0

func _ready() -> void:
	Signals.player_data_updated.connect(update_velocity)

func update_velocity(data : PlayerData) -> void:
	if data:
		velocity = clampf(data.velocity, 0.0, 50.0)

func _physics_process(_delta: float) -> void:		
	update_speed_lines()

func update_speed_lines() -> void:
	var speedline_intensity : float = 0.001
	
	#handle lines intensifying with player velocity
	if velocity > 20.0:
		speedline_intensity = velocity/100.0
	
	var shader_material : ShaderMaterial = material as ShaderMaterial
	shader_material.set_shader_parameter("line_density", speedline_intensity)
