class_name Transition extends ColorRect

func _ready():
	material.set_shader_parameter("screen_size", get_window().size)


func fade_in():
	var tween = get_tree().create_tween();
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_method(_set_progress, 1.05, 0.0, 1.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD); 
	await tween.finished


func fade_out():
	var tween = get_tree().create_tween();
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_method(_set_progress, 0.0, 1.05, 1.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD); 
	await tween.finished


func fade_out_immediately():
	material.set_shader_parameter("circle_radius", 1.05)
	

func _set_progress(progress : float):
	material.set_shader_parameter("circle_radius", progress)

