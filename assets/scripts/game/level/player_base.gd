class_name PlayerBase extends Area2D

var player : Player
var config : MatchConfig

@onready var background_sprite = $BackgroundSprite
@onready var player_spawn = $PlayerSpawn
@onready var player_start = $PlayerStart

func _ready():
	config = Config.match
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

# Called when the node enters the scene tree for the first time.
func setup(environment : Node2D, player_settings : PlayerSettings):
	var character_config : CharacterConfig = Config.character_repository.get_character(player_settings.character_index)
	background_sprite.modulate = character_config.color
	
	var character_scene := load(character_config.avatar_scene)
	player = character_scene.instantiate()
	
	environment.add_child(player)	
	player.setup(player_settings, character_config, self)
 

func _on_body_entered(body):
	if body == player:
		body.enter_house()
		
	elif body is Player:
		body.crash(-body.velocity.normalized() * config.player.impact_force)


func _on_body_exited(body):
	if body == player:
		player.exit_house()
