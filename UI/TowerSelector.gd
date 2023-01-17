extends Control

onready var animation_player = $AnimationPlayer

var tower_slots := []


func _ready():
	for child in get_children():
		if child.name.begins_with("TowerSlot"):
			tower_slots.append(child)


func set_slot_display(ind: int, tower: String, level: int):
	#将ind位置的Slot，设置tower的显示和价格
	if ind < 0 or ind >= tower_slots.size():
		return #越界无效
	var tower_display = load("res://UI/Towers/%s.tscn"%tower).instance()
	var slot = tower_slots[ind]
	slot.get_node("Tower").add_child(tower_display)
	slot.get_node("Label").text = str(GameData.Tower[tower][level].cost)


func slot_connect(ind: int, _signal: String, target: Object, method: String, binds: Array):
	if ind < 0 or ind >= tower_slots.size():
		return #越界无效
	tower_slots[ind].connect(_signal, target, method, binds)
