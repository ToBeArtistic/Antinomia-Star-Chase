extends CharacterBody3D

class_name Player

var data : PlayerData = PlayerData.new()

var _direction : Vector3 = Vector3()
var _speed : float = STARTING_SPEED
var _acceleration : float = ACCELERATION
var _slowdown_acceleration : float = SLOWDOWN_ACCELERATION

var _max_speed : float = MAX_SPEED
var _dash_timer : float = 0.0
var _dash_cooldown : float = 0.0
var _dash_active : bool = false
var _double_jump : bool = true
var _is_jumping : bool = false

var _coyote_timer : float = 0.0

const STARTING_SPEED = 8.0
const MAX_SPEED = 30.0
const MAX_OVERSPEED = 400.0
const ACCELERATION = 10.0
const SLOWDOWN_ACCELERATION = 5.0
const AIR_ACCELERATION = 0.7
const SLOWDOWN_AIR_ACCELERATION = 0.1
const JUMP_VELOCITY = 30.0
const DOUBLE_JUMP_FACTOR = 1.3
const DASH_VELOCITY = 1000.0
const AIR_DASH_VELOCITY = 300.0
const DASH_ACTIVATION_TIME = 0.2
const DASH_COOLDOWN = 0.3
const COYOTE_TIME = 0.3
const MOMENTUM_FACTOR = 8

#Camera variables
var _rotation_input : float
var _tilt_input : float
var _mouse_rotation : Vector3

var _player_rotation : Vector3
var _camera_rotation : Vector3

@export var player_gravity : float = 60.0
@export var debug_mode : bool

@export var TILT_LOWER_LIMIT := deg_to_rad(-89)
@export var TILT_UPPER_LIMIT := deg_to_rad(89)
@export var CAMERA_CONTROLLER : Camera3D

var MOUSE_SENS_Y := 0.5
var MOUSE_SENS_X := 0.5

@onready var camera : Camera3D = $camera_player
@onready var run_sound : AudioStreamPlayer = $run_sound
@onready var dash_sound : AudioStreamPlayer = $dash_sound
@onready var sprint_sound : AudioStreamPlayer = $sprint_sound
@onready var jump_sound : AudioStreamPlayer = $jump_sound
@onready var wind_sound : AudioStreamPlayer = $wind_sound


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_load_configs()
	Config.settings_changed.connect(_load_configs)
	
func _load_configs() -> void:
	MOUSE_SENS_X = Config.get_setting(Config.SECTION.GAME, "sensitivity_x") / 100.0
	MOUSE_SENS_Y = Config.get_setting(Config.SECTION.GAME, "sensitivity_y") / 100.0


func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouse_event : InputEventMouseMotion = event as InputEventMouseMotion
		_rotation_input = -mouse_event.relative.x
		_tilt_input = -mouse_event.relative.y

func _update_camera(delta: float) -> void:
	_mouse_rotation.x += _tilt_input * delta * MOUSE_SENS_X
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta * MOUSE_SENS_Y
	
	_player_rotation = Vector3(0.0, _mouse_rotation.y, 0.0)
	_camera_rotation = Vector3(_mouse_rotation.x, 0.0, 0.0)
	
	transform.basis = Basis.from_euler(_player_rotation)
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	CAMERA_CONTROLLER.rotation.z = 0.0
	_rotation_input = 0.0
	_tilt_input = 0.0

func _physics_process(delta : float) -> void:
	var input_dir : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	_acceleration = ACCELERATION
	_slowdown_acceleration = SLOWDOWN_ACCELERATION
	_max_speed = MAX_SPEED
	
	if not is_on_floor():
		velocity.y -= player_gravity * delta
		_coyote_timer -= delta
		_acceleration = AIR_ACCELERATION
		_slowdown_acceleration = SLOWDOWN_AIR_ACCELERATION
	else:
		_coyote_timer = COYOTE_TIME
		_double_jump = true

	if Input.is_action_pressed("dash") and _dash_cooldown < 0.01:
		_dash_active = true
		_dash_timer = DASH_ACTIVATION_TIME
		_dash_cooldown = DASH_COOLDOWN
	
	if _dash_cooldown > 0.01:
		_dash_cooldown -= delta
	
	if _dash_timer < 0.01:
		_dash_active = false
	
	if _dash_active:
		if not is_on_floor():
			_acceleration = AIR_DASH_VELOCITY
		else:
			_acceleration = DASH_VELOCITY
		_max_speed = MAX_OVERSPEED
		_dash_timer -= delta
		
	if input_dir.length() < 0.01 and _dash_active:
		input_dir.y -= 1.0
		
	if input_dir.length() < 0.01:
		_acceleration = SLOWDOWN_ACCELERATION	
	
	handle_jump()

	# Handle camera rotation
	_update_camera(delta)

	# Get the input _direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var velocity_direction = Vector3(velocity.x, 0.0, velocity.z).normalized()
	_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if _direction:
		_speed = clampf(_speed + _acceleration * delta, STARTING_SPEED, _max_speed)
		velocity.x = (_direction.x * _speed + MOMENTUM_FACTOR * velocity.x) / (MOMENTUM_FACTOR+1)
		velocity.z = (_direction.z * _speed + MOMENTUM_FACTOR * velocity.z) / (MOMENTUM_FACTOR+1)
	else:
		_speed = clampf(_speed - _slowdown_acceleration * 10 * delta, STARTING_SPEED, _max_speed)
		
		velocity.x = move_toward(velocity.x, 0, _slowdown_acceleration)
		velocity.z = move_toward(velocity.z, 0, _slowdown_acceleration)

	move_and_slide()
	data.velocity = velocity.length()
	Signals.player_data_updated.emit(data)

	_play_sounds()
	
	
func handle_jump() -> void:
	_is_jumping = false
	if not Input.is_action_just_pressed("jump"): 
		return
	var jump_velocity : float = JUMP_VELOCITY
	if not (_coyote_timer >= 0.0 or _double_jump):
		return
	if not _coyote_timer >= 0.0 and _double_jump:
		_double_jump = false
		jump_velocity = JUMP_VELOCITY / DOUBLE_JUMP_FACTOR
	velocity.y = jump_velocity
	_is_jumping = true
	

func _play_sounds() -> void:
	if is_on_floor() and velocity.length() >= STARTING_SPEED and velocity.length() < MAX_SPEED*2 and not run_sound.playing:
		run_sound.pitch_scale = randf_range(0.9, 1.05)
		run_sound.play()
	if is_on_floor() and velocity.length() >= MAX_SPEED * 2 and not sprint_sound.playing:
		sprint_sound.pitch_scale = randf_range(0.6, 0.8)
		sprint_sound.play()
	if _dash_active and not dash_sound.playing:
		if is_on_floor():
			dash_sound.volume_db = -11
		else:
			dash_sound.volume_db = -18
		dash_sound.pitch_scale = randf_range(0.9, 1.1)
		dash_sound.play()
	if _is_jumping:
		jump_sound.pitch_scale = randf_range(1.0, 1.2)
		jump_sound.play()

	wind_sound.volume_db = clampf(-75.0 + velocity.length(), -80.0, -2.0) 
	if not wind_sound.playing:
		wind_sound.play()
	