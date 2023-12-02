class_name PlayerSelection extends Node

signal player_joined(PlayerSettings)

@onready var character_selection = %CharacterSelection
const GAME_PATH = "res://assets/scenes/game.tscn"

var players : PlayersState
var pendant_devices : Dictionary
@onready var start_label = %StartLabel

func _ready():
	players = GameState.players
	for device in Input.get_connected_joypads():
		add_device(device)
	
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	players.all_players_ready_changed.connect(_on_all_players_ready_changed)
	
	
func _on_joy_connection_changed(device : int, connected : bool):
	if connected:
		add_device(device)
	else:
		remove_device(device)
			

func _on_all_players_ready_changed():
	start_label.visible = players.all_players_ready
	
	
func add_device(device : int):
	if pendant_devices.has(device):
		return
	
	Audio.play_input_connect()
			
	var device_input = DeviceInput.new(device)
	pendant_devices[device] = device_input
	
	print("device added " + str(device))


func remove_device(device : int):
	Audio.play_input_disconnect()
	
	if pendant_devices.has(device):
		pendant_devices.erase(device)
	else:
		players.remove_player_by_device(device)
	
	print("device removed " + str(device))
	
	
func _process(_delta):
	_check_input_devices()
	_check_start()
			
			
func _check_input_devices():
	for device in pendant_devices:
		if pendant_devices[device].is_action_just_pressed("ui_join"):
			players.add_player(device, pendant_devices[device])
			Audio.play_player_join()
			call_deferred("remove_device", device)


func _check_start():
	if players.all_players_ready and players.list[0].device_input.is_action_just_pressed("ui_start"):
		Audio.play_open_match()
		get_tree().change_scene_to_file(GAME_PATH)


