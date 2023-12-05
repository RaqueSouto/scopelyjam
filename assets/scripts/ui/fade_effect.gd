class_name FadeEffect extends Control

@export var duration := 1
@export var min_fade := 0.65
@export var max_fade := 1.0

var tween : Tween

func _ready():
	visibility_changed.connect(_on_visibility_changed)
	if visible:
		play()
	
	
func _on_visibility_changed():
	if visible:
		play()
	else:
		stop()


func play():
	tween = create_tween()
	tween.tween_method(fade, max_fade, min_fade, duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_method(fade, min_fade, max_fade, duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.set_loops()


func fade(value):
	modulate = Color(modulate, value)
	

func stop():
	if tween == null:
		return
	tween.stop()
	modulate = Color(modulate, max_fade)

