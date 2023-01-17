extends Node2D

#资源相关信号
signal hp_changed(value)
signal mhp_changed(value)
signal fund_changed(value)
#塔防进程相关
signal wave_finished
signal waves_cleared

export(PoolStringArray) var tower_type: PoolStringArray
export(int) var fund := 0 setget set_fund
export(int) var max_health := 20 setget set_max_hp
export(int) var health := 20 setget set_hp
#地图数据相关
var map:Map
var paths := []
var _current_wave:int = 0
#塔建造相关
var _build_mode := false
var _build_position := Vector2()
var _current_tile := Vector2()
var _build_tower: String = ""
var _tower_pool := {}

onready var turrents = $Turrents
onready var enemy_nodes = $Enemies
onready var HUD = $UI/HUD
onready var tower_selector = $TowerSelector
onready var wait_timer = $WaitTimer


func _ready():
	#地图初始化
	var map_proxy = $MapProxy
	assert(map_proxy.get_child_count() == 1,"Only one Map in the Scene")
	assert(map_proxy.get_child(0) is Map, "This is not Map")
	map = map_proxy.get_child(0)
	paths = map.paths
	#初始化塔列表，初始化塔选ui
	for i in tower_type:
		var tower_node = load("res://Towers/%s.tscn"%i)
		_tower_pool[i] = tower_node
	for i in tower_type.size():
		tower_selector.set_slot_display(i, tower_type[i], 1)
		tower_selector.slot_connect(
			i, "mouse_entered", self, "set_preview_tower", [tower_type[i]])
		tower_selector.slot_connect(
			i, "mouse_exited", self, "set_preview_tower", [""])
		tower_selector.slot_connect(
			i, "pressed", self, "verify_and_build", [])
	#初始化显示ui
	HUD.set_fund(fund)
	HUD.set_hp(health)
	connect("hp_changed", HUD, "set_hp")
	connect("fund_changed", HUD, "set_fund")
	next_wave()
	


func _physics_process(delta):
	pass


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		initlate_build_mode()
	if event.is_action_pressed("ui_cancel") and _build_mode:
		cancel_build_mode()

func enemy_enter_map(enemy_name:String, path_ind):
	var enemy = load("res://Enemies/%s.tscn"%enemy_name).instance()
	enemy_nodes.add_child(enemy)
	if not paths.empty():
		paths[path_ind].add_child(enemy.pathFollow)


func initlate_build_mode():
	var mouse_position = get_global_mouse_position()
	var tower_exclusion = map.tower_exclusion as TileMap
	var current_tile = tower_exclusion.world_to_map(tower_exclusion.to_local(mouse_position))
	var tile_position = tower_exclusion.to_global(tower_exclusion.map_to_world(current_tile))
	if _build_mode and _current_tile == current_tile:
		return
	if tower_exclusion.get_cellv(current_tile) == -1:
		tower_selector.set_position(tile_position)
		tower_selector.show()
		tower_selector.animation_player.stop()
		tower_selector.animation_player.play("Show")
		_build_mode = true
		_build_position = tile_position + tower_exclusion.cell_size/2
		_current_tile = current_tile
	else:
		cancel_build_mode()

func cancel_build_mode():
	if not _build_mode:
		return
	_build_mode = false
	tower_selector.animation_player.play_backwards("Show")
	yield(tower_selector.animation_player, "animation_finished")
	if not _build_mode:
		tower_selector.hide()


func set_preview_tower(tower):
	if not tower:
		_build_tower = ""
		return
	_build_tower = tower


func verify_and_build():
	if not _build_mode:
		return
	if _build_tower == "":
		return
	if fund < GameData.Tower[_build_tower][1].cost:
		return
	set_fund(fund - GameData.Tower[_build_tower][1].cost)
	var tower = _tower_pool[_build_tower].instance()
	tower.call_deferred("set_tower_data", _build_tower, 1)
	var tower_exclusion = map.tower_exclusion as TileMap
	turrents.add_child(tower)
	tower.global_position = _build_position
	tower_exclusion.set_cellv(_current_tile, 5)
	cancel_build_mode()


func set_hp(value: int):
	health = value
	emit_signal("hp_changed", value)


func set_max_hp(value: int):
	max_health = value
	emit_signal("mhp_changed", value)


func set_fund(value: int):
	fund = value
	emit_signal("fund_changed", value)


func next_wave():
	if _current_wave >= map.wave_data.size():
		emit_signal("waves_cleared")
		return
	set_fund(fund + map.wave_data[_current_wave].fund)
	for enemy in map.wave_data[_current_wave].enemies:
		enemy_enter_map(enemy.name, enemy.path_ind)
		wait_timer.start(enemy.wait_time)
		yield(wait_timer, "timeout")
	_current_wave += 1
	emit_signal("wave_finished")


func _on_GameScene_wave_finished():
	wait_timer.start(5)
	yield(wait_timer, "timeout")
	next_wave()
