extends Node

#game
signal pause_game

#level
signal restart_level

#mechanics
signal waypoint_manager_changed(waypoint_manager : WaypointManager)
signal hazard_entered()

#player
signal player_data_updated(data : PlayerData)

