class_name Game extends Node

var match_config : MatchConfig
var player_bases : Array

var players : PlayersState 

@onready var environment := %Environment
@onready var level_bases := %LevelBases
@onready var game_ui := %GameUI
@onready var end_game_timer = %EndGameTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	match_config = Config.match
	players = GameState.players
	
	player_bases = level_bases.get_children()
	
	for player in players.list:
		player_bases[player.player_index].setup(environment, player)
		
	Audio.play_init_match()
	await ScreenEffects.transtion_fade_out()
	await game_ui.play_countdown()
	
	get_tree().paused = false
	end_game_timer.start(match_config.duration)
	end_game_timer.timeout.connect(_on_end_game_timeout)
	
	
func _on_end_game_timeout():
	check_winners()
	
	
func check_winners():
	pass
	
