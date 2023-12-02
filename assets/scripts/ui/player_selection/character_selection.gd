class_name CharacterSelection extends HBoxContainer

var character_selectors : Array

var players : PlayersState

func _ready():
	character_selectors = get_children()
	players = GameState.players 
	players.player_list_changed.connect(_on_player_list_change)
		

func _on_player_list_change():
	update_player_list()
		
		
func update_player_list():
	for index in character_selectors.size() - 1:
		if index < players.list.size():
			character_selectors[index].set_player(players.list[index])
		else:
			character_selectors[index].remove_player()
		
