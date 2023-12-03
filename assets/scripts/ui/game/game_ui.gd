class_name GameUI extends CanvasLayer

@onready var countdown_label = %CountdownLabel
@onready var end_game_label = %EndGameLabel
@onready var end_game_timer = %EndGameTimer
@onready var score = $Score



func _ready():
	countdown_label.visible = false
	
	set_timer()
	

func set_timer():
	var minutes = floor(end_game_timer.time_left / 60)
	var seconds = int(end_game_timer.time_left) % 60
	end_game_label.text = "%0*d:%0*d" % [2, minutes, 2, seconds]

func play_countdown():
	
	set_countdown_number("3")
	countdown_label.visible = true

	var tween = create_tween()
	tween.tween_property(countdown_label, "scale", Vector2.ONE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_interval(0.5)
	
	tween.tween_callback(func(): set_countdown_number("2"))
	tween.tween_property(countdown_label, "scale", Vector2.ONE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_interval(0.5)
	
	tween.tween_callback(func(): set_countdown_number("1"))
	tween.tween_property(countdown_label, "scale", Vector2.ONE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_interval(0.5)
	tween.tween_callback(func(): set_countdown_number("GO!"))
	tween.tween_callback(Audio.play_start_match)
	tween.tween_property(countdown_label, "scale", Vector2.ONE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_interval(0.5)
	tween.tween_property(countdown_label, "modulate", Color(Color.WHITE, 0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(func(): countdown_label.visible = false)
	
	await tween.finished
	
	
func set_countdown_number(number : String):
	countdown_label.text = str(number)
	countdown_label.scale = Vector2(10, 10)

	
func show_end_game():
	countdown_label.modulate = Color.WHITE
	set_countdown_number("Time Over!")
	countdown_label.visible = true
	
	var tween = create_tween()
	tween.tween_property(countdown_label, "scale", Vector2.ONE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_interval(3)
	await tween.finished
	
func _process(delta):
	set_timer()
	
