class_name ScoringState extends State

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	player = owner

func state_enter():
	player.animation.play("happy")
	player.can_move = false
	player.can_take_items = false
	player.can_crash = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func state_process(delta):

	pass
