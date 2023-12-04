class_name MovingState extends State

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	player = owner


func state_enter():
	player.animation.play("walk")
	player.can_feel = true
	player.can_move = true
	player.can_take_items = true
	player.can_crash = true
	player.can_score = true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func state_process(delta):
	if player == null:
		return
		
	var rotation = player.input.get_axis("move_left", "move_right")
	player.look_at.rotate(rotation * player.current_angular_speed * delta)
	player.velocity = (player.target.global_position - player.look_at.global_position).normalized() * player.current_speed


func state_physics_process(delta):
	player.move_and_slide()
