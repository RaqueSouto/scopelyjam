class_name Player extends CharacterBody2D

var base : PlayerBase
var speed : float
var angular_speed : float

var input : DeviceInput
var config : PlayerConfig

@onready var state_machine := %StateMachine
@onready var starting_state = %StartingState
@onready var moving_state := %MovingState
@onready var stunt_state := %StuntState
@onready var picking_state := %PickingState
@onready var end_game_state = %EndGameState

func _ready():
	print("READY")


func setup(player_settings : PlayerSettings, player_base : PlayerBase):
	input = player_settings.device_input
	config = Config.match.player
	base = player_base
	speed = config.base_speed
	angular_speed = deg_to_rad(config.base_angular_speed)
	
	print("SETUP")
	starting_state.setup(base.global_position)
	

func enter_house():
	pass
	
	
func exit_house():
	state_machine.change_state(moving_state)
