extends Control

class_name GoalHandler

var waypoint_manager : WaypointManager 
@onready var timer : SimpleTimerElement = $Time
@onready var completed_text : Control = $CompletedText
@onready var completed_time_label : RichTextLabel = $CompletedTime
@onready var completed_best_label : RichTextLabel = $CompletedBest
@onready var failed_text : Control = $FailedText
@onready var failed_subtitle : Control = $FailedSubtitle
@onready var split_timer : SplitTimerElement = $SplitTimer
@onready var rank_text : RichTextLabel = $RankText

var completed : bool = false
var record_name : String = "" :
	get:
		return record_name
	set(value):
		if Config.has_setting(Config.SECTION.SPLITS, value):
			best_time_splits = Config.get_setting(Config.SECTION.SPLITS, value)
			print_debug(best_time_splits)
		record_name = value
var level_data : LevelData :
	get:
		return level_data
	set(value):
		level_data = value
		record_name = level_data.record_name

var best_time : float = 0.0
var current_time_splits : Dictionary[String, float]
var best_time_splits : Dictionary[String, float]

func _enter_tree() -> void:
	Signals.waypoint_manager_changed.connect(_handle_waypointmanager)
	Signals.hazard_entered.connect(_fail_level)

func _ready() -> void:
	completed_text.visible = false
	completed_time_label.visible = false
	completed_best_label.visible = false
	failed_subtitle.visible = false
	failed_text.visible = false
	current_time_splits = {}
	rank_text.visible = false
	

func _complete(success:bool = true) -> void:
	completed = true
	timer.stopped = true
	timer.visible = false
	split_timer.visible = false
	if not success:
		failed_text.visible = true
		failed_subtitle.visible = true
		waypoint_manager.end()
		return
	completed_time_label.visible = true
	completed_text.visible = true
	completed_best_label.visible = true
	completed_time_label.text = timer.text

	if Config.has_setting(Config.SECTION.RECORDS, record_name):
		best_time = Config.get_setting(Config.SECTION.RECORDS, record_name)

	if best_time < 0.5 || timer.time < best_time:
		Config.save_setting(Config.SECTION.RECORDS, record_name, timer.time)
		Config.save_setting(Config.SECTION.SPLITS, record_name, current_time_splits) 
		best_time = timer.time
	
	handle_rank_text(best_time)
	
	completed_best_label.text = "BEST " + timer.get_timer_text(best_time)
	AudioGlobal.play_named_sfx("level_completed")

func _handle_waypointmanager(_waypoint_manager : WaypointManager) -> void:
	if waypoint_manager:
		waypoint_manager.waypoint_triggered.disconnect(_handle_waypointmanager)
	
	waypoint_manager = _waypoint_manager

	waypoint_manager.waypoints_completed.connect(_complete)
	waypoint_manager.waypoint_triggered.connect(_handle_waypoint_split)
	print_debug(name + " changed waypoint manager to " + waypoint_manager.name)

func _handle_waypoint_split(waypoint : Waypoint) -> void:
	var current : float = timer.time 
	current_time_splits.set(waypoint.name, current)
	
	var ghost : float
	if best_time_splits.has(waypoint.name):
		ghost = best_time_splits.get(waypoint.name)
	if ghost:
		var difference : float = current - ghost
		split_timer.set_time(difference)
	else:
		split_timer.set_time(current, true)
	

func _fail_level() -> void:
	if not completed:
		_complete(false)
		AudioGlobal.play_named_sfx("level_failed")

func handle_rank_text(record_value : float) -> void:
	rank_text.visible = true
	rank_text.text = " NO RANK "
	if record_value < level_data.rank_s:
		rank_text.text = "-S-"
	elif record_value < level_data.rank_a:
		rank_text.text = "-A-"
	elif record_value < level_data.rank_b:
		rank_text.text = "-B-"
	elif record_value < level_data.rank_c:
		rank_text.text = "-C-"
