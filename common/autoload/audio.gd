extends Node

@onready var music_stream : AudioStreamPlayer = AudioStreamPlayer.new()
@onready var sfx_stream : AudioStreamPlayer = AudioStreamPlayer.new()

var music : Dictionary = {
	"start_theme" : load("res://assets/audio/music/Theme_Death.mp3"),
	"main_theme" : load("res://assets/audio/music/Theme_Main.mp3"),
	"level_1" : load("res://assets/audio/music/Theme_Foot.mp3"),
	"level_2" : load("res://assets/audio/music/Theme_Cave_Ziggurat.mp3"),
	"level_3" : load("res://assets/audio/music/Theme_Main.mp3"),
	"level_4" : load("res://assets/audio/effects/throat_singing_looped.wav")
}

var sfx : Dictionary = {
	"level_failed" : load("res://assets/audio/effects/yeuww.wav"),
	"level_completed" : null,
	"pressed" : load("res://assets/audio/effects/pickup_glass_reverb.wav"),
	"hover" : load("res://assets/audio/effects/run_sound.wav")
}


var current_theme : String

func _ready() -> void:
	add_child(music_stream)
	music_stream.bus = "Music"
	add_child(sfx_stream)
	sfx_stream.bus = "SFX"

func _process(_delta: float) -> void:
	if not music_stream.playing:
		music_stream.play()

func start_music(theme_name : String) -> void:
	music_stream.stop()
	if music.has(theme_name):
		music_stream.stream = music.get(theme_name)
		current_theme = theme_name
	else:
		music_stream.stream = music.get("main_theme")
		current_theme = "main_theme"
	if music_stream.stream:
		music_stream.play()

func play_sfx(sound : Resource) -> void:
	sfx_stream.stop()
	if sound:
		sfx_stream.stream = sound
		sfx_stream.play()

func play_named_sfx(sound : String) -> void:
	if sfx.has(sound):
		play_sfx(sfx.get(sound))

func stop_sfx() -> void:
	sfx_stream.stop()

