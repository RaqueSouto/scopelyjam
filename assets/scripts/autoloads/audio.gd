extends Node

class Events:
	#const INPUT_CONNECT = "{5cde2717-7391-4901-a100-844208377102}"
	const INPUT_DISCONNECT = "{bae01454-5e9b-4952-836c-25401e83789c}"
	const PLAYER_JOIN = "{19e83a06-b5b1-463a-a2b0-9ac31d360b70}"
	const SELECT_CHARACTER = "{1beb7c3b-438f-40d1-8103-d5867651b740}"
	const WARNING = "{e545456c-ce0d-42c9-b2b9-689a1e315623}"
	const PLAYER_READY = "{5cde2717-7391-4901-a100-844208377102}"
	const PLAYER_NOT_READY = "{9a6a719b-abc1-4304-bd03-71e9e87cc583}"
	const OPEN_MATCH = "{ea63fc33-16b8-4e2d-a95b-b7719fee9750}"
	const INIT_MATCH = "{0aed6e1e-461c-4731-b7f9-719ca10d3e33}" 
	const START_MATCH = "{bae01454-5e9b-4952-836c-25401e83789c}"
	
	const ANGRY = "{c6c0728c-b150-4e83-8aa6-b7414491544f}"
	const CRASH = "{e545456c-ce0d-42c9-b2b9-689a1e315623}"
	const SCORE = "{a0345161-9fd0-4385-a240-8f79d2b08b15}"

	const TITLE_MUSIC = "{c570944e-2b38-4174-a1d8-a7c5072050b8}"
	const GAME_MUSIC = "{c570944e-2b38-4174-a1d8-a7c5072050b8}"
	const END_MUSIC = "{fddaa165-9c96-44f1-a8c9-3bca0486f6dd}"


@onready var title_music_emitter := %TitleMusicEmitter
@onready var game_music_emitter := %GameMusicEmitter
@onready var end_music_emitter := %EndMusicEmitter

var current_music_emitter : StudioEventEmitter2D


func _ready():
	FMODRuntime.process_mode = Node.PROCESS_MODE_ALWAYS


func play_one_shot(event_id : String):
	if event_id.is_empty():
		return
		
	FMODRuntime.play_one_shot_id(event_id)


#func play_input_connect():
#	play_one_shot(Events.INPUT_CONNECT)
	
	
func play_input_disconnect():
	play_one_shot(Events.INPUT_DISCONNECT)
	

func play_player_join():
	play_one_shot(Events.PLAYER_JOIN)
	

func play_select_character():
	play_one_shot(Events.SELECT_CHARACTER)


func play_warning():
	play_one_shot(Events.WARNING)
	
	
func play_player_ready():
	play_one_shot(Events.PLAYER_READY)


func play_player_not_ready():
	play_one_shot(Events.PLAYER_NOT_READY)
	

func play_open_match():
	play_one_shot(Events.OPEN_MATCH)


func play_init_match():
	play_one_shot(Events.INIT_MATCH)


func play_start_match():
	play_one_shot(Events.START_MATCH)
	

func play_title_music():
	title_music_emitter.play()
	current_music_emitter = title_music_emitter


func play_game_music():
	game_music_emitter.play()
	current_music_emitter = game_music_emitter
	
	
func play_end_music():
	end_music_emitter.play()
	current_music_emitter = end_music_emitter


func stop_music():
	if current_music_emitter == null:
		return
		
	current_music_emitter.stop()
	current_music_emitter = null
