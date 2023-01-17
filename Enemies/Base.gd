extends KinematicBody2D
class_name BaseEnemy

signal hurt(damage)
signal dead
signal reach_end

export var speed: int = 100
export var max_health: int = 100
export var health: int = 100
export var damage: int = 1

onready var collision_shape_2d = $CollisionShape2D
onready var not_rotate = $NotRotate
onready var progress_bar = $NotRotate/ProgressBar
onready var state_player = $StatePlayer

const explosion = preload("res://Misc/Explosion.tscn")

var pathFollow := PathFollow2D.new() #挂在至path上的路径节点

var _is_dead := false

func _ready():
	var _temp = RemoteTransform2D.new()
	_temp.remote_path = get_path()
	pathFollow.add_child(_temp)
	pathFollow.loop = false
	
	progress_bar.max_value = max_health
	progress_bar.value = health
	progress_bar.hide()


func _physics_process(delta):
	if _is_dead:
		return
	if pathFollow.get_parent() is Path2D:
		pathFollow.set_offset(pathFollow.get_offset() + speed*delta)
	if pathFollow.unit_offset == 1.0:
		emit_signal("reach_end")


func _on_Base_hurt(damage):
	health -= damage
	progress_bar.value = health
	progress_bar.show()
	if health > 0:
		state_player.stop()
		state_player.play("Hurt")
	else:
		emit_signal("dead")
		_is_dead = true
		state_player.play("Dead")
		yield(state_player, "animation_finished")
		var expl = explosion.instance() as AnimatedSprite
		get_parent().add_child(expl)
		expl.global_position = global_position
		expl.play()
		expl.connect("animation_finished", expl, "queue_free")
		queue_free()


func _on_Base_tree_exiting():
	pathFollow.queue_free()


