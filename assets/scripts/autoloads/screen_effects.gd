extends CanvasLayer

#@onready var crt_shader := $CRTShader
@onready var transition := $Transition

#func set_crt_mode_active(active : bool):
#	crt_shader.visible = active

func transtion_fade_in():
	await transition.fade_in()


func transtion_fade_out():
	await transition.fade_out()


func transition_fade_out_immediately():
	transition.fade_out_immediately()
