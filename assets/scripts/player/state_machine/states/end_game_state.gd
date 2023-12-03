class_name EndGameState extends State

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	player = owner


# Called every frame. 'delta' is the elapsed time since the previous frame.
func state_process(delta):
	if player == null:
		return

	pass
