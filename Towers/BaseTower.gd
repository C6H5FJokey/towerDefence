extends Node2D


onready var fire_cd = $FireCD
onready var collision_shape_2d = $Range/CollisionShape2D

#以下属性为调试属性,仅调试模式使用，非调试模式时以全局量为基准
export var level := 1 #塔的等级
export var damage := 5 #塔的伤害，不同塔的效果不太一样
export var cost := 100 #建造或升级消耗

var value: int = cost/2 #回收的价值，大概是总耗费的一半，之后会自动计算

var _targets: Array = [] #打击的目标们
var _target: Node2D #打击的目标


func _physics_process(delta):
	if not _targets.empty():
		_aim()
		if fire_cd.time_left == 0:
			_fire()
			fire_cd.start()


func _aim(): #瞄准函数 用于更新_target
	pass


func _fire(): #开火函数
	pass


func _upgrade(): #升级函数
	pass


func _destory(): #销毁函数
	pass


func set_tower_data(type: String, level: int):
	if GameData.Tower[type][level]:
		self.level = level
		damage = GameData.Tower[type][level].damage
		cost = GameData.Tower[type][level].cost
		fire_cd.wait_time = GameData.Tower[type][level].rof
		collision_shape_2d.shape.radius = GameData.Tower[type][level].range
	


func _on_Range_body_entered(body):
	if body.is_in_group("Enemies"):
		_targets.append(body)
		body.connect("dead", self, "_on_Range_body_exited", [body])

func _on_Range_body_exited(body):
	if _targets.has(body):
		body.disconnect("dead", self, "_on_Range_body_exited")
		_targets.erase(body)
