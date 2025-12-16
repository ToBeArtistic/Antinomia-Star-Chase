extends Control

class_name GoalHandler

var waypoint_manager : WaypointManager 
@onready var timer : SimpleTimerElement = $Time
@onready var completed_text : Control = $CompletedText
@onready var completed_time_label : RichTextLabel = $CompletedTime
@onready var completed_best_label : RichTextLabel = $CompletedBest
@onready var failed_text : Control = $FailedText
@onready var failed_subtitle : Control = $FailedSubtitle

var completed : bool = false
var record_name : String = ""
var best_time : float = 0.0

func _enter_tree() -> void:
	Signals.waypoint_manager_changed.connect(_handle_waypointmanager)
	Signals.hazard_entered.connect(_fail_level)

func _ready() -> void:
	completed_text.visible = false
	completed_time_label.visible = false
	completed_best_label.visible = false
	failed_subtitle.visible = false
	failed_text.visible = false

func _complete(success:bool = true) -> void:
	completed = true
	timer.stopped = true
	timer.visible = false
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
		best_time = timer.time
	
	completed_best_label.text = "BEST " + timer.get_timer_text(best_time)
	AudioGlobal.play_named_sfx("level_completed")

func _handle_waypointmanager(_waypoint_manager : WaypointManager) -> void:
	waypoint_manager = _waypoint_manager
	waypoint_manager.waypoints_completed.connect(_complete)
	print_debug(name + " changed waypoint manager to " + waypoint_manager.name)

func _fail_level() -> void:
	if not completed:
		_complete(false)
		AudioGlobal.play_named_sfx("level_failed")