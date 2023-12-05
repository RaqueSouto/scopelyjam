class_name PlayersState extends Node

signal player_ready_changed(player : PlayerSettings)
signal all_players_ready_changed()
signal player_list_changed()

const MIN_PLAYERS := 2
const MAX_PLAYERS := 4

var list : Array[PlayerSettings]

var score_players : Dictionary

var all_players_ready := false:
	set(value):
		if value == all_players_ready:
			return
			
		all_players_ready = value
		all_players_ready_changed.emit()
		

func add_player(device : int, device_input : DeviceInput, character_index : int) -> PlayerSettings:
	if list.size() >= MAX_PLAYERS:
		return
		
	var player_settings = PlayerSettings.new()
	player_settings.player_index = list.size()
	player_settings.device = device
	player_settings.device_input = device_input
	player_settings.character_index = character_index
	list.append(player_settings)
	player_list_changed.emit()
	return player_settings
	
	

func remove_player(player : int):
	list.remove_at(player)
	for player_index in list.size():
		list[player_index].player_index = player_index
		
	player_list_changed.emit()
	_check_players_ready()


func remove_player_by_device(device : int):
	for player in list:
		if player.device == device:
			call_deferred("remove_player", device)
			return
			
			
func exist_player_device(device : int) -> bool:
	for player in list:
		if player.device == device:
			return true
			
	return false
	

func is_character_id_selected_by_other(character_index : int, player_index : int = -1) -> bool:
	for player in list:
		if player.player_index == player_index:
			continue
			 
		if player.character_index == character_index:
			return true
			
	return false
	

func is_character_id_being_used_by_other(character_index : int, player_index : int = -1) -> bool:
	for player in list:
		if player.player_index == player_index:
			continue
			
		if player.is_ready and player.character_index == character_index:
			return true
			
	return false
	

func select_character(player : int, character : int):
	list[player].character_index = character
	

func set_player_ready(player : int, is_ready : bool):
	list[player].is_ready = is_ready
	_check_players_ready()
	player_ready_changed.emit(list[player])
	
	
func _check_players_ready():
	var players_ready = 0
	for player in list:			
		if not player.is_ready:
			all_players_ready = false
			return
			
		players_ready += 1
		
	all_players_ready = players_ready >= MIN_PLAYERS
