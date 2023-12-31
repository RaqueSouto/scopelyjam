class_name PlayerSelection extends Node

signal player_joined(PlayerSettings)

@onready var character_selection = %CharacterSelection
const GAME_PATH = "res://assets/scenes/game.tscn"

var players : PlayersState
var characters_repo : CharacterRepository
var pendant_devices : Dictionary

@onready var start_label = %StartLabel

var is_title := true

func _ready():
	ScreenEffects.transition_fade_out_immediately()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	players = GameState.players
	characters_repo = Config.character_repository
	
	character_selection.setup(self)
	
	# Keyboard / SteamController
	if not players.exist_player_device(-1):
		add_device(-1) 
	
	# Console controllers	
	for device in Input.get_connected_joypads():
		if not players.exist_player_device(device):
			add_device(device)
	
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	players.all_players_ready_changed.connect(_on_all_players_ready_changed)
	
	character_selection.update_player_list()
	start_label.visible = false
	
	
func _on_joy_connection_changed(device : int, connected : bool):
	if connected:
		add_device(device)
		#Audio.play_input_connect()
	else:
		remove_device(device)
		Audio.play_input_disconnect()
			

func _on_all_players_ready_changed():
	start_label.visible = players.all_players_ready
	
	
func add_device(device : int):
	if pendant_devices.has(device):
		return
			
	var device_input = DeviceInput.new(device)
	pendant_devices[device] = device_input
	character_selection.update_player_list()


func remove_device(device : int):
	if pendant_devices.has(device):
		pendant_devices.erase(device)
		character_selection.update_player_list()
	else:
		players.remove_player_by_device(device)
	
	
func disconnect_player(player : PlayerSettings):
	if pendant_devices.has(player.device):
		return
			
	pendant_devices[player.device] = player.device_input
	players.remove_player(player.player_index)
	
	
func _process(_delta):
	_check_input_devices()
	_check_start()
			
			
func _check_input_devices():
	for device in pendant_devices:
		if pendant_devices[device].is_action_just_pressed("ui_join"):
			var character_index := _get_first_unselected_character()
			players.add_player(device, pendant_devices[device], character_index)
			Audio.play_player_join()
			remove_device.call_deferred(device)


func _get_first_unselected_character() -> int:
	for character_index in characters_repo.get_last_character_index():
		if not players.is_character_id_selected_by_other(character_index):
			return character_index
			
	return 0


func _check_start():
	if players.all_players_ready and players.list[0].device_input.is_action_just_pressed("ui_start"):
		Audio.play_open_match()
		get_tree().paused = true
		Audio.stop_music()
		await ScreenEffects.transtion_fade_in()
		players.reset_players_state()
		get_tree().change_scene_to_file(GAME_PATH)


