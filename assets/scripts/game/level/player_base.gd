class_name PlayerBase extends Node

var player : Player

@onready var player_spawn = $PlayerSpawn
@onready var player_start = $PlayerStart

# Called when the node enters the scene tree for the first time.
func setup(level : Node2D, player_settings : PlayerSettings):
	var character_config : CharacterConfig = Config.character_repository.get_character(player_settings.character_index)
	var character_scene := load(character_config.avatar_scene)
	
	player = character_scene.instantiate()

	setup_player(level, player_settings)
	
	
func setup_player(level : Node2D, player_settings : PlayerSettings):
	await player.ready
	player.setup(player_settings, self)
	
	level.add_child(player)
	player.global_position = player_spawn.global_position
 
