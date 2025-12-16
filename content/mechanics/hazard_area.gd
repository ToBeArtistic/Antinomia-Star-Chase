extends Area3D

func _ready() -> void:
	body_entered.connect(_hazard_entered)

func _hazard_entered(body : Node3D) -> void:
	if body is Player:
		Signals.hazard_entered.emit()
	pass
