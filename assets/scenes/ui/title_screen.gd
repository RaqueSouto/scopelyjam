extends Node

const PLAYER_SELECTION = "res://assets/scenes/player_selection.tscn"
@onready var music = $CanvasLayer/Music

func _ready():
	ScreenEffects.transition_fade_out_immediately()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#music.play()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file(PLAYER_SELECTION)
