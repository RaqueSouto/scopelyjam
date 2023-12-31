class_name Game extends Node

signal game_ended()

var match_config : MatchConfig
var player_bases : Array
var score_labels : Array

var players : PlayersState 

@onready var environment := %Environment
@onready var level_bases := %LevelBases
@onready var game_ui := %GameUI
@onready var end_game_timer := %EndGameTimer
@onready var item_spawner := $ItemSpawner
@onready var crash_shaker = %CrashShaker
@onready var robbed_shaker = %RobbedShaker
@onready var countdown_shaker = %CountdownShaker
@onready var go_shaker = %GoShaker
@onready var pause = %Pause



const END_GAME = "res://assets/scenes/end_game.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	match_config = Config.match
	players = GameState.players
	
	player_bases = level_bases.get_children()
	
	game_ui.setup(self)
	
	for player in players.list:
		player_bases[player.player_index].setup(environment, player, game_ui.get_score_label(player.player_index), self)
		
	Audio.play_init_match()
	await ScreenEffects.transtion_fade_out()
	await game_ui.play_countdown()
	
	get_tree().paused = false
	end_game_timer.start(match_config.duration)
	end_game_timer.timeout.connect(_on_end_game_timeout)
	item_spawner.init()
	pause.enabled = true
	Audio.play_game_music()
	
	
func _on_end_game_timeout():
	pause.enabled = false
	get_tree().paused = true
	check_winners()
	await game_ui.show_end_game()
	Audio.stop_music()
	await ScreenEffects.transtion_fade_in()
	get_tree().change_scene_to_file(END_GAME)
	
	
func check_winners():
	game_ended.emit()
	
	players.score_players = Dictionary()
	for player in players.list:
		if not players.score_players.has(player.score):
			players.score_players[player.score] = Array()
			
		players.score_players[player.score].append(player)


func countdown():
	countdown_shaker.start()


func go():
	go_shaker.start()
	Audio.play_start_match()
	
	
func vibrate(weak_magnitude : float, strong_magnitude : float, duration : float):
	for base in player_bases:
		if base.player == null:
			continue
		base.player.input.start_vibration(weak_magnitude, strong_magnitude, duration)
