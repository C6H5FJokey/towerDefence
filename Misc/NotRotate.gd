extends Node2D
class_name NotRotate

enum ProcessMode { PROCESS_PHYSICS,PROCESS_IDLE }

export(ProcessMode) var process_mode = ProcessMode.PROCESS_PHYSICS

onready var offset = position

func _ready():
	set_as_toplevel(true)


func _process(delta):
	if process_mode == ProcessMode.PROCESS_IDLE:
		if get_parent() is Node2D:
			position = get_parent().global_position + offset


func _physics_process(delta):
	if process_mode == ProcessMode.PROCESS_PHYSICS:
		if get_parent() is Node2D:
			position = get_parent().global_position + offset
