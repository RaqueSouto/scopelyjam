class_name Player extends CharacterBody2D

var input : DeviceInput
var config : PlayerConfig

@onready var state_machine = %StateMachine
@onready var moving_state = %MovingState
@onready var stunt_state = %StuntState
@onready var picking_state = %PickingState

var speed : float
var angular_speed : float

func setup(player_settings : PlayerSettings):
	input = player_settings.device_input
	config = Config.match.player
	
	speed = config.base_speed
	angular_speed = deg_to_rad(config.base_angular_speed)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
