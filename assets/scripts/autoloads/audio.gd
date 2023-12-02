extends Node

class Events:
	const INIT = "{0aed6e1e-461c-4731-b7f9-719ca10d3e33}"

func _ready():
	
	pass


func play_input_connect():
	pass
	
	
func play_input_disconnect():
	pass
	

func play_player_join():
	pass
	

func play_select_character():
	pass


func play_warning():
	
	pass
	
	
func play_player_ready():
	pass


func play_player_not_ready():
	pass
	

func play_open_match():
	pass


func play_init_match():
	FMODRuntime.play_one_shot_id(Events.INIT)


func play_start_match():
	pass
