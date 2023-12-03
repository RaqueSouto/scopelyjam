class_name ScoringState extends State

var player : Player
var base : PlayerBase

var score_point = false

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	player = owner


func setup(player_base : PlayerBase):
	base = player_base
	

func state_enter():
	player.animation.play("happy")
	player.can_move = false
	player.can_take_items = false
	player.can_crash = false
	
	score_point = base.player_spawn.global_position
	score_point.y += player.spawn_offset 
	
	var direction = (score_point - player.global_position).normalized()
	player.look_at.look_at(player.look_at.global_position + direction)
	player.velocity = direction * player.current_speed
	

func state_process(delta):
	if player.global_position.distance_squared_to(score_point) > 50:
		return
		
	player.add_score()
	
	
	
func state_physics_process(delta):
	player.move_and_slide()
