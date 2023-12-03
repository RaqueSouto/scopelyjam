class_name PlayerRenderer extends Sprite2D

var player : Player

func _ready():
	await owner.ready
	player = owner


func _process(delta):
	if player == null:
		return
		
	_check_orientation()
	
		
func _check_orientation():
	if player.velocity.x < 0:
		flip_h = player.not_flip
	elif player.velocity.x > 0:
		flip_h = not player.not_flip
