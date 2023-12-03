class_name ItemSpawner extends Node2D

@export var item_paths : Array[String]
@export var spawn_offset : Vector2 

var item_scenes : Array

@onready var environment = %Environment
@onready var spawn_timer = $SpawnTimer


func _ready():
	for item_path in item_paths:
		var item_scene = load(item_path)
		item_scenes.append(item_scene)

	spawn_timer.timeout.connect(_on_spawn_timer)


func init():
	spawn_random_item()


func _on_spawn_timer():
	spawn_random_item()
	
	
func spawn_random_item():
	if item_scenes.size() == 0:
		return
	var item_scene = item_scenes.pick_random()
	var item = item_scene.instantiate()
	environment.add_child(item)
	item.global_position = global_position + Vector2(
			randf_range(-spawn_offset.x, spawn_offset.x),
			randf_range(-spawn_offset.y, spawn_offset.y))
