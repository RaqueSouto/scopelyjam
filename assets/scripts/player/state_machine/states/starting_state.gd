class_name StartingState extends State

var player : Player

@onready var look_at := %LookAt
@onready var target := %Target

var base_start_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	player = owner


func setup(in_base_start_position : Vector2):
	base_start_position = in_base_start_position


func state_enter():
	var direction = (base_start_position - player.global_position).normalized()
	look_at.look_at(look_at.global_position + direction)
	player.velocity = direction * player.speed


func state_physics_process(delta):
	player.move_and_slide()
