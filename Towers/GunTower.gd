extends "res://Towers/BaseTower.gd"

const bullet = preload("res://Towers/Bullet.tscn")

onready var bearing = $Bearing
onready var animation_player = $AnimationPlayer

func _aim():
	_targets.sort_custom(self, "sort_ascending")
	_target = _targets[0]
	bearing.look_at(_target.global_position)


func _fire():
	var _bullet = bullet.instance() as Bullet
	_bullet.target = _target
	_bullet.damage = damage
	_bullet.speed = 2000
	_bullet.distance = global_position.distance_to(_target.global_position)
	get_parent().add_child(_bullet)
	animation_player.play("Fire")


func sort_ascending(a: Node2D, b: Node2D) -> bool:
	if self.global_position.distance_squared_to(a.global_position) < self.global_position.distance_squared_to(b.global_position):
		return true
	return false
