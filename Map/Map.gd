extends Node2D
class_name Map

export(Resource) var map_config

onready var paths = $Paths.get_children()
onready var tower_exclusion = $TowerExclusion
onready var wave_data = (map_config as MapConfig).wave_set
