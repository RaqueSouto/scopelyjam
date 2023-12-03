class_name EndGame extends Node

@onready var players_slots = $PlayersSlots

var players_state : PlayersState
var characters_repo : CharacterRepository

@onready var background = $Background


# Called when the node enters the scene tree for the first time.
func _ready():
	players_state = GameState.players
	characters_repo = Config.characters_repo

	var max_score = players_state.score_players.keys().max()
	var winners = players_state.score_players[max_score]
	
	for player in players_state.list:
		var character_config = characters_repo.get_character(player.character_index)
		var character_scene := load(character_config.avatar_scene)
		var character = character_scene.instantiate()
	
		players_slots.get_child(player.player_index).add_child(character)
		
		if winners.has(player):
			character.animation.play("happy")
		else:
			character.animation.play("sad")
			
	await ScreenEffects.transtion_fade_out()
