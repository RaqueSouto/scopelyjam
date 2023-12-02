class_name PlayersState extends Node

signal all_players_ready_changed()
signal player_list_changed()

const MIN_PLAYERS := 2
const MAX_PLAYERS := 4

var list : Array[PlayerSettings]

var all_players_ready := false:
	set(value):
		if value == all_players_ready:
			return
			
		all_players_ready = value
		all_players_ready_changed.emit()
		

func add_player(device : int, device_input : DeviceInput) -> PlayerSettings:
	if list.size() >= MAX_PLAYERS:
		return
	var player_settings = PlayerSettings.new()
	player_settings.player_index = list.size()
	player_settings.device = device
	player_settings.device_input = device_input
	list.append(player_settings)
	player_list_changed.emit()
	return player_settings
	

func remove_player(player : int):
	list.remove_at(player)
	player_list_changed.emit()


func select_character(player : int, character : int):
	list[player].character_index = character
	

func set_player_ready(player : int, is_ready : bool):
	list[player].is_ready = is_ready
	_check_players_ready()
	
	
func _check_players_ready():
	var players_ready = 0
	for player in list:			
		if not player.is_ready:
			all_players_ready = false
			return
			
		players_ready += 1
		
	all_players_ready = players_ready >= MIN_PLAYERS
