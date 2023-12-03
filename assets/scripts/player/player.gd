class_name Player extends CharacterBody2D

const spawn_offset := 72.0

var base : PlayerBase
var speed : float
var angular_speed : float

var input : DeviceInput
var config : PlayerConfig

var not_flip := true
var can_score := false
var can_move = false:
	set(value):
		can_move = value
		target.modulate = Color.WHITE if can_move else Color(Color.GRAY, 0.5)

@onready var look_at := %LookAt
@onready var target := %ArrowTarget

@onready var animation := %AnimationPlayer

@onready var state_machine = %StateMachine
@onready var starting_state = %StartingState
@onready var moving_state = %MovingState
@onready var stunt_state = %StuntState
@onready var scoring_state = %ScoringState
@onready var end_game_state = %EndGameState


func _ready():
	config = Config.match.player
	target.modulate = Color(Color.GRAY, 0.5)


func setup(player_settings : PlayerSettings, character_config : CharacterConfig, player_base : PlayerBase):
	input = player_settings.device_input
	
	base = player_base
	speed = config.base_speed
	angular_speed = deg_to_rad(config.base_angular_speed)
	target.self_modulate = character_config.color

	global_position = player_base.player_spawn.global_position
	global_position.y += spawn_offset

	starting_state.setup(base.player_start.global_position)
	state_machine.init()
	

func enter_house():
	if not can_score:
		return
	state_machine.change_state(scoring_state)
	
	
func exit_house():
	state_machine.change_state(moving_state)


func crash(impact_force : Vector2):
	state_machine.change_state(stunt_state)
	not_flip = false
	velocity = impact_force
	look_at.look_at(global_position + impact_force)
	lose_half_items()
	
	
func lose_half_items():
	pass


func recover():
	not_flip = true
	state_machine.change_state(moving_state)
