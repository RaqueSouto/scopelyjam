class_name Pause extends Node

var players : PlayersState

var enabled : bool
var is_paused : bool
var pause_player : PlayerSettings

@onready var canvas_layer := %CanvasLayer
@onready var quit := %Quit


func _ready():
	players = GameState.players
	canvas_layer.visible = false
	quit.enabled = false
	

func _process(delta):
	if not enabled:
		return
		
	if is_paused:
		_check_unpause()
	else:
		_check_pause()


func _check_pause():
	for player : PlayerSettings in players.list:
		if player.device_input.is_action_just_pressed("pause_game"):
			_pause(player)
			return
			
			
func _pause(player : PlayerSettings):
	pause_player = player
	is_paused = true
	canvas_layer.visible = true
	quit.enabled = true
	get_tree().paused = true


func _check_unpause():
	if pause_player.device_input.is_action_just_pressed("pause_game"):
		_unpause()
		return
			
			
func _unpause():
	pause_player = null
	is_paused = false
	canvas_layer.visible = false
	quit.enabled = false
	get_tree().paused = false
