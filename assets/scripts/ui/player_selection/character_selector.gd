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
	
	input_allowed = false
	
	
func set_character(character : CharacterConfig):
	player_label.modulate = character.color
	character_name_label.text = character.print_name
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
			players.set_player_ready(player.player_index, true)
			ready_label.visible = true
			Audio.play_player_ready()
		
	elif player.is_ready and player.device_input.is_action_just_pressed("ui_cancel"):
		players.set_player_ready(player.player_index, false)
		ready_label.visible = false
		Audio.play_player_not_ready()


func select_previous():
	var index = 0
	if player.character_index > index:
		index = player.character_index - 1
	else:
		index = character_repo.get_last_character_index()
		
	set_character(
		character_repo.get_character(index))
	players.select_character(player.player_index, index)
		
	select_cooldown = true
	select_cooldown_timer.start()
	
	tween_control(up_arrow)
	Audio.play_select_character()


func select_next():
	var index = character_repo.get_last_character_index()
	if player.character_index < index:
		index = player.character_index + 1
	else:
		index = 0

	set_character(
			character_repo.get_character(index))
	players.select_character(player.player_index, index)
		
	select_cooldown = true
	select_cooldown_timer.start()
	
	tween_control(down_arrow)
	Audio.play_select_character()


func tween_control(control : Control):
	var tween = create_tween()
	tween.tween_property(control, "scale", Vector2(1.4, 1.4), 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(control, "scale", Vector2.ONE, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
