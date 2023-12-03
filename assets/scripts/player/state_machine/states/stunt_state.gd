class_name StuntState extends State

var player : Player

@onready var stunt_timer = $StuntTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	player = owner

func state_enter():
	player.animation.play("stun")
	player.can_move = false
	stunt_timer.start(player.config.stunt_duration)
	#TODO: play particles
	await stunt_timer.timeout
	player.recover()
	
func state_physics_process(delta):
	player.velocity = player.velocity.slerp(Vector2.ZERO, player.config.impact_deceleration * delta)
	player.move_and_slide()
