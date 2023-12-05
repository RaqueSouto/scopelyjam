class_name CharacterSelection extends HBoxContainer

var character_selectors : Array

var player_selection : PlayerSelection
var players : PlayersState

func _ready():
	character_selectors = get_children()
	players = GameState.players 
	players.player_list_changed.connect(_on_player_list_change)
	for i in character_selectors.size():
		character_selectors[i].setup(self)
		

func setup(in_player_selection : PlayerSelection):
	player_selection = in_player_selection
		

func _on_player_list_change():
	update_player_list()
		
		
func update_player_list():
	var pendant_index = 0
	for index in character_selectors.size():
		if index < players.list.size():
			character_selectors[index].set_player(players.list[index])
		else:
			if pendant_index < player_selection.pendant_devices.size():
				character_selectors[index].remove_player()
				pendant_index += 1
			else:
				character_selectors[index].disconnect_device()
		
