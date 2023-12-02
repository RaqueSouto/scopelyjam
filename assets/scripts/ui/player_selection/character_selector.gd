class_name CharacterSelector extends Node

var character_repo : CharacterRepository
var players : PlayersState

var index : int
var player : PlayerSettings
var select_cooldown := false

@onready var player_active = $PlayerActive
@onready var player_inactive = $PlayerInactive
@onready var player_label := %PlayerLabel
@onready var character_avatar := %CharacterAvatar
@onready var character_name_label = %CharacterNameLabel
@onready var character_role_label = %CharacterRoleLabel
@onready var select_cooldown_timer := %SelectCooldownTimer
@onready var ready_label = %ReadyLabel

@onready var up_arrow = %UpArrow
@onready var down_arrow = %DownArrow


var input_allowed = false

func _ready():
	players = GameState.players
	character_repo = Config.character_repository
	select_cooldown_timer.timeout.connect(_on_select_cooldown_timer_timeout)
	

func _on_select_cooldown_timer_timeout():
	print("now you can select!")
	select_cooldown = false


func set_player(player_settings : PlayerSettings):
	player = player_settings
	player.is_ready = false
	player_label.text = player.get_print()
	var character = character_repo.get_character(player.character_index)
	set_character(character)
	player_active.visible = true
	player_inactive.visible = false
	
	if player.is_ready:
		set_as_ready()
	else:
		set_as_not_ready()
		
	input_allowed = false
	
	
func set_character(character : CharacterConfig):
	player_label.modulate = character.color
	character_name_label.text = character.print_name
	character_role_label.text = character.print_role
	character_name_label.modulate = character.color
	character_avatar.texture = character.avatar_icon


func remove_player():
	player = null
	player_active.visible = false
	player_inactive.visible = true


func _process(_delta):
	if player == null:
		return
		
	# wait one frame
	if not input_allowed:
		input_allowed = true
		return
	
	if not player.is_ready:
		if player.device_input.is_action_just_pressed("ui_down"):
			select_next()
		elif player.device_input.is_action_just_pressed("ui_up"):
			select_previous()
		
		elif not select_cooldown:
			var select = player.device_input.get_axis("ui_down", "ui_up")
			if select > 0.1:
				select_previous()
			elif select < -0.1:
				select_next()

		if player.device_input.is_action_just_pressed("ui_accept"):
			set_player_as_ready()
		
	elif player.is_ready and player.device_input.is_action_just_pressed("ui_cancel"):
		set_player_as_not_ready()

func select_previous():
	var character_index = 0
	if player.character_index > character_index:
		character_index = player.character_index - 1
	else:
		character_index = character_repo.get_last_character_index()
		
	set_character(
		character_repo.get_character(character_index))
	players.select_character(player.player_index, character_index)
		
	select_cooldown = true
	select_cooldown_timer.start()
	
	tween_control(up_arrow)
	Audio.play_select_character()


func select_next():
	var character_index = character_repo.get_last_character_index()
	if player.character_index < character_index:
		character_index = player.character_index + 1
	else:
		character_index = 0

	set_character(
			character_repo.get_character(character_index))
	players.select_character(player.player_index, character_index)
		
	select_cooldown = true
	select_cooldown_timer.start()
	
	tween_control(down_arrow)
	Audio.play_select_character()


func set_player_as_ready():
	players.set_player_ready(player.player_index, true)
	Audio.play_player_ready()
	set_as_ready()


func set_as_ready():
	ready_label.visible = true


func set_player_as_not_ready():
	players.set_player_ready(player.player_index, false)
	Audio.play_player_not_ready()
	set_as_not_ready()
	
	
func set_as_not_ready():
	ready_label.visible = false
	
	
func tween_control(control : Control):
	var tween = create_tween()
	tween.tween_property(control, "scale", Vector2(1.4, 1.4), 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(control, "scale", Vector2.ONE, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
