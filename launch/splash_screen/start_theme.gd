extends AudioStreamPlayer

@export var theme_context_key : String

var started : bool = false

func _ready() -> void:
	tree_exiting.connect(_save_offset)
	volume_db = -80.0

func _process(_delta: float) -> void:
	_fade_in(_delta)

	if playing:
		started = true
		return
	if not theme_context_key || started:
		play()
		return

	if not Context.theme_offsets.has(theme_context_key):
		play()
		return
	
	play(Context.theme_offsets.get(theme_context_key))

func _fade_in(_delta : float) -> void:
	volume_db = move_toward(volume_db, 0.0, _delta * 300)

func _save_offset() -> void:
	Context.reset_theme_offsets()
	if theme_context_key:
		Context.theme_offsets.set(theme_context_key, get_playback_position())
