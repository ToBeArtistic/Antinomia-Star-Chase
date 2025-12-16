extends AudioStreamPlayer

class_name ButtonSoundHandler

@onready var parent : Button = get_parent()

var sounds : Dictionary = {
	"hover" : load("res://assets/audio/effects/run_sound.wav"),  
	"press" : load("res://assets/audio/effects/pickup_glass_reverb.wav")
}

func _ready() -> void:
	bus = "SFX"
	parent.pressed.connect(_emit_sound.bind("press"))
	parent.mouse_entered.connect(_emit_sound.bind("hover"))



func _emit_sound(sound_name : String) -> void:
	if parent.disabled:
		return
	AudioGlobal.play_sfx(sounds.get(sound_name))
	
