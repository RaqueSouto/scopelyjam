class_name EndGameState extends State

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	player = owner


func state_enter():
	player.velocity = Vector2.ZERO
	player.can_move = false
	player.can_take_items = false
	player.can_crash = false


func state_process(delta):
	if player == null:
		return
