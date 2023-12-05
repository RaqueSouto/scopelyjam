class_name TitleScreen extends Node

const PLAYER_SELECTION = "res://assets/scenes/player_selection.tscn"

var can_start := false

@onready var title = %Title
@onready var start_label = %StartLabel

func _ready():
	ScreenEffects.transition_fade_out_immediately()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Audio.play_title_music()
	
	can_start = false
	start_label.visible = false
	title.scale = Vector2(20, 20)
	
	var tween = create_tween()
	await tween.tween_property(title, "scale", Vector2.ONE, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	can_start = true
	start_label.visible = true
	


func _process(delta):
	if can_start and Input.is_anything_pressed():
		get_tree().change_scene_to_file(PLAYER_SELECTION)
