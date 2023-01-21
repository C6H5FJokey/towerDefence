extends Node

var paused: bool = false setget set_pause, is_pause
var hasted: bool = false setget set_haste, is_haste


func reset():
	paused = false
	hasted = false
	get_tree().paused = false
	Engine.time_scale = 1.0


func set_pause(value: bool):
	paused = value
	get_tree().paused = value


func is_pause() -> bool:
	return paused


func set_haste(value: bool):
	hasted = value
	Engine.time_scale = 2.0 if value else 1.0


func is_haste() -> bool:
	return hasted


func update_pause():
	get_tree().paused = paused
