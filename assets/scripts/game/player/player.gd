class_name Player extends CharacterBody2D

signal scored(amount : int)

const spawn_offset := 72.0

var base : PlayerBase
var current_speed : float
var current_angular_speed : float
var color : Color

var input : DeviceInput
var config : PlayerConfig

var not_flip := true
var can_score := false
var can_take_items := false
var can_crash := false
var can_move = false:
	
	set(value):
		can_move = value
		target.modulate = Color.WHITE if can_move else Color(Color.GRAY, 0.5)

var tail : Array[Item]
var score := 0

@onready var look_at := %LookAt
@onready var target := %ArrowTarget

@onready var animation := %AnimationPlayer


@onready var state_machine = %StateMachine
@onready var starting_state = %StartingState
@onready var moving_state = %MovingState
@onready var stunt_state = %StuntState
@onready var scoring_state = %ScoringState
@onready var end_game_state = %EndGameState


func _ready():
	config = Config.match.player
	target.modulate = Color(Color.GRAY, 0.5)


func setup(player_settings : PlayerSettings, character_config : CharacterConfig, player_base : PlayerBase):
	input = player_settings.device_input
	
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
	

func enter_house():
	if not can_score:
		return
	state_machine.change_state(scoring_state)
	
	
func exit_house():
	state_machine.change_state(moving_state)


func crash(impact_force : Vector2):
	if not can_take_items:
		return
		
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
		
	if tail.size() > 0:
		item.change_owner(self, tail[tail.size() - 1])
	else:
		item.change_owner(self, self)
		
	#tail.insert(0, item)
	tail.append(item)
	
	while (item.item_child != null):
		item = item.item_child
		item.change_owner(self, tail[tail.size() - 1])
		
	update_speed()


func remove_item(item):
	tail.erase(item)
	

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
		
	if score_items.size() > 0:
		var score_added = score_items.values().min()
		score += score_added
	
		if score > 0:
			scored.emit(score_added)

	update_speed()
	state_machine.change_state(starting_state)
	
	
func destroy_items(items):
	for item in items:
		item.queue_free()
	
	
func _process(delta):
	for item in tail:
		item.follow(delta)
