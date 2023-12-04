class_name TitleScreen extends Node

const PLAYER_SELECTION = "res://assets/scenes/player_selection.tscn"

func _ready():
	ScreenEffects.transition_fade_out_immediately()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Audio.play_title_music()


func _process(delta):
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file(PLAYER_SELECTION)
