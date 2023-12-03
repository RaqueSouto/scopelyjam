class_name EndGame extends Node

@onready var players_slots = $PlayersSlots

var players_state : PlayersState
var characters_repo : CharacterRepository

@onready var background = $Background
@onready var back_menu_label = %BackMenuLabel
@onready var music = $Music


const TITLE = "res://assets/scenes/player_selection.tscn"

var can_exit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	back_menu_label.visible = false
	players_state = GameState.players
	characters_repo = Config.character_repository

	var max_score = players_state.score_players.keys().max()
	var winners = players_state.score_players[max_score]
	
	for player in players_state.list:
		var character_config = characters_repo.get_character(player.character_index)
		var character_scene := load(character_config.avatar_scene)
		var character = character_scene.instantiate()
	
		players_slots.get_child(player.player_index).add_child(character)
		
		character.look_at.visible = false
		character.scale *= 2
		if winners.has(player):
			character.animation.play("happy")
		else:
			character.animation.play("sad")
			
		
	get_tree().paused = false
	music.play()
	await ScreenEffects.transtion_fade_out()
	await get_tree().create_timer(2).timeout
	
	can_exit = true
	back_menu_label.visible = true
	

func _process(delta):
	if can_exit and players_state.list[0].device_input.is_action_just_pressed("ui_start"):
		get_tree().paused = true
		await ScreenEffects.transtion_fade_in()
		music.stop()
		get_tree().change_scene_to_file(TITLE)
