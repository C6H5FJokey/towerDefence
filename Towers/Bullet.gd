extends Node
class_name Bullet

var distance:float
var speed:float
var damage:int
var target:BaseEnemy


func _ready():
	if target:
		target.connect("dead", self, "queue_free")


func _physics_process(delta):
	distance -= speed * delta
	if distance <= 0:
		if target:
			target.emit_signal("hurt", damage)
		queue_free()
