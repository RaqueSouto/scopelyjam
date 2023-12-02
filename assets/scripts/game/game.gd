extends Node

var match_config : MatchConfig
var player_bases : Array

var players : PlayersState 

@onready var level = %Level
@onready var level_bases = %LevelBases

# Called when the node enters the scene tree for the first time.
func _ready():
	match_config = Config.match
	players = GameState.players
	
	player_bases = level_bases.get_children()
	
	for player in players.list:
		player_bases[player.player_index].setup(level, player)
		
	await ScreenEffects.transtion_fade_out()
	get_tree().paused = false	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
