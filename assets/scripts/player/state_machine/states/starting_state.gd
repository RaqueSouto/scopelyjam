class_name StartingState extends State

var player : Player

@onready var look_at = %LookAt
@onready var target = %Target

var base_start_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	player = owner


func setup(base_start_position : Vector2):
	base_start_position = base_start_position


func state_enter():
	look_at.look_at(base_start_position)
	player.up_direction = look_at.get_angle_to(target)
	player.velocity = player.up_direction * player.speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func state_process(delta):
	if player == null:
		return
		
	var rotation = player.input.get_axis("move_left", "move_right")
	look_at.rotate(rotation * player.angular_speed)
	player.up_direction = look_at.get_angle_to(target)
	
	
	player
	pass
