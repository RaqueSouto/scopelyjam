class_name Exit extends Node

var is_quitting := false
var quit_device

var enabled := true:
	set(value):
		enabled = value
		quit_canvas_layer.visible = enabled
		if not enabled and is_quitting:
			is_quitting = false
			quit_panel.visible = false
			quit_timer.stop()
		
		
@onready var quit_canvas_layer = %QuitCanvasLayer
@onready var quit_panel = %QuitPanel
@onready var quit_progress_bar = %QuitProgressBar
@onready var quit_timer = %QuitTimer


func _ready():
	quit_panel.visible = false
	quit_progress_bar.max_value = quit_timer.wait_time
	quit_progress_bar.value = 0
	quit_timer.timeout.connect(_on_quit_timeout)
	

func _process(delta):
	if not enabled:
		return
		
	if is_quitting:
		_check_quitting()
	else:
		_check_start_quit()
	

func _check_start_quit():
	if _check_device_start_quit(-1):
		return
		
	var joypads = Input.get_connected_joypads()
	for device in joypads:
		if _check_device_start_quit(device):
			return


func _check_device_start_quit(device : int) -> bool:
	if not MultiplayerInput.is_action_just_pressed(device, "quit"):
		return false	
		
	quit_device = device
	is_quitting = true
	quit_panel.visible = true
	quit_timer.start()
	return true
		
	
func _check_quitting():
	_check_device_quitting(quit_device)


func _check_device_quitting(device : int) -> bool:
	if not MultiplayerInput.is_action_just_released(device, "quit"):
		quit_progress_bar.value = quit_timer.wait_time - quit_timer.time_left
		return false	
		
	is_quitting = false
	quit_panel.visible = false
	quit_timer.stop()
	return true


func _on_quit_timeout():
	get_tree().quit()
