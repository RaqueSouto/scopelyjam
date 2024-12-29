class_name Player extends CharacterBody2D

signal scored(amount : int)

const spawn_offset := 72.0
const item_types := 4

var base : PlayerBase
var current_speed : float
var current_angular_speed : float
var color : Color

var input
var config : PlayerConfig
var settings : PlayerSettings

var not_flip := true

var can_feel := false
var can_score := false
var can_take_items := false
var can_crash := false
var can_move := false:
	set(value):
		can_move = value
		target.modulate = Color.WHITE if can_move else Color(Color.GRAY, 0.5)

var tail : Array[Item]
var score := 0

var game : Game

@onready var look_at := %LookAt
@onready var target := %ArrowTarget

@onready var animation := %AnimationPlayer

@onready var state_machine = %StateMachine
@onready var starting_state = %StartingState
@onready var moving_state = %MovingState
@onready var stunt_state = %StuntState
@onready var scoring_state = %ScoringState
@onready var end_game_state = %EndGameState

@onready var angry_sfx_emitter = %AngrySfxEmitter
@onready var crash_sfx_emitter = %CrashSfxEmitter
@onready var score_sfx_emitter = %ScoreSfxEmitter
@onready var emotion_timer = $EmotionTimer
@onready var crash_particles = $CrashParticles


func _ready():
	config = Config.match.player
	target.modulate = Color(Color.GRAY, 0.5)


func setup(player_settings : PlayerSettings, character_config : CharacterConfig, player_base : PlayerBase, in_game : Game):
	
	game = in_game
	input = player_settings.device_input
	
	settings = player_settings
	base = player_base
	current_speed = config.base_speed
	current_angular_speed = deg_to_rad(config.base_angular_speed)
	
	color = character_config.color
	target.self_modulate = color

	global_position = player_base.player_spawn.global_position
	global_position.y += spawn_offset

	starting_state.setup(base.player_start.global_position)
	scoring_state.setup(base)
	state_machine.init()
	
	game.game_ended.connect(_on_game_ended)
	

func enter_house():
	if not can_score:
		return
	state_machine.change_state(scoring_state)
	
	
func exit_house():
	state_machine.change_state(moving_state)


func crash(impact_force : Vector2):
	if not can_crash:
		velocity = impact_force
		look_at.look_at(global_position + impact_force)
		return
		
	crash_sfx_emitter.play()
	game.crash_shaker.start()
	input.start_vibration(1, 1, 0.6)
	crash_particles.emitting = true
		
	state_machine.change_state(stunt_state)
	not_flip = false
	velocity = impact_force
	look_at.look_at(global_position + impact_force)
	lose_half_items()
	
	
func lose_half_items():
	if tail.size() < 2:
		return
	
	var new_size = ceil(tail.size() / 2)
	while tail.size() > new_size:
		var item : Item = tail.pop_back()
		item.impact_and_unfollow()
	
	update_speed()
	


func add_items(item : Item):
	if not can_take_items:
		return
		
	if (item.player_owner == self):
		return
		
	var vibration := 0.2
	
	var item_child = item.item_child
	while (item_child != null):
		item_child = item_child.item_child
		vibration += 0.05
		
	if tail.size() > 0:
		item.change_owner(self, tail[tail.size() - 1])
	else:
		item.change_owner(self, self)
	
	
	vibration = min(vibration, 0.8)
	input.start_vibration(vibration, vibration, vibration / 2)
	
	update_speed()


func attach_child(item : Item):
	tail.append(item)


#func detach_child(item : Item):
#	tail.erase(item)


func remove_item(item : Item, omite_taunt : bool):
	tail.erase(item)
	if omite_taunt or not can_feel:
		return
	angry_sfx_emitter.play()
	game.robbed_shaker.start()
	play_feeling("angry")
	
	
func play_feeling(emotion : String):
	animation.play(emotion)
	emotion_timer.start()
	await emotion_timer.timeout
	if can_feel:
		animation.play("walk")


func update_speed():
	current_speed = max(config.min_speed, config.base_speed - config.speed_penalization * tail.size())
	current_angular_speed = deg_to_rad(max(config.angular_min_speed, config.base_angular_speed - config.angular_speed_penalization * tail.size()))
	
	
func recover():
	not_flip = true
	state_machine.change_state(moving_state)


func add_score():
	var score_items = Dictionary()
	
	for item in tail:
		if score_items.has(item.type):
			score_items[item.type] += 1
		else:
			score_items[item.type] = 1
		
		item.destroy()
		
	tail.clear()
		
	if score_items.size() == item_types: 
		var score_added = score_items.values().min()
		score += score_added
	
		if score > 0:
			score_sfx_emitter.play()
			scored.emit(score_added)

	update_speed()
	state_machine.change_state(starting_state)
	
	
func destroy_items(items):
	for item in items:
		item.queue_free()
	
	
func _process(delta):
	for item in tail:
		item.follow(delta)


func _on_game_ended():
	settings.score = score
