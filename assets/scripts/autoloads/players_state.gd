class_name PlayersState extends Node

signal all_players_ready_change()
signal player_list_change()

const MIN_PLAYERS := 2
const MAX_PLAYERS := 4

var list : Array[PlayerSettings]

var all_players_ready := false:
	set(value):
		if value == all_players_ready:
			return
			
		all_players_ready = value
		all_players_ready_change.emit()
	

func _ready():
	for i in MAX_PLAYERS:
		var player_settings = PlayerSettings.new()
		player_settings.player_index = i
		list.append(player_settings)


func add_player(device : int) -> PlayerSettings:
	if list.size() >= MAX_PLAYERS:
		return
	
	var player_settings = PlayerSettings.new()
	player_settings.player_index = list.size()
	player_settings.device = device
	list.append(player_settings)
	player_list_change.emit()
	return player_settings
	
	

func remove_player(player : int):
	list.remove_at(player)
	player_list_change.emit()


func select_character(player : int, character : int):
	players[player].character_index = character
	

func player_ready(player : int, is_ready : bool):
	players[player].is_ready = is_ready
	if ready:
		_check_players_ready()
	
	
func _check_players_ready():
	var players_ready = 0
	for player in players:
		if not player.is_active:
			continue
			
		if not player.is_ready:
			all_players_ready = false
			return
			
		players_ready += 1
		
	all_players_ready = players_ready >= MIN_PLAYERS
