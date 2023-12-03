class_name StartingState extends State

var player : Player

var base_start_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	player = owner


func setup(in_base_start_position : Vector2):
	base_start_position = in_base_start_position


func state_enter():
	player.animation.play("walk")
	player.can_move = false
	
	var direction = (base_start_position - player.global_position).normalized()
	player.look_at.look_at(player.look_at.global_position + direction)
	player.velocity = direction * player.speed


func state_physics_process(delta):
	player.move_and_slide()
