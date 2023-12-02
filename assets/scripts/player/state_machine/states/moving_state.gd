class_name MovingState extends State

var player : Player

@onready var look_at = %LookAt
@onready var target = %Target

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	player = owner


# Called every frame. 'delta' is the elapsed time since the previous frame.
func state_process(delta):
	if player == null:
		return
		
	var rotation = player.input.get_axis("move_left", "move_right")
	look_at.rotate(rotation * player.angular_speed)
	player.up_direction = look_at.get_angle_to(target)
	player.velocity = player.up_direction * player.speed

func state_physics_process(delta):
	player.move_and_slide()
