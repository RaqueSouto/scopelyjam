class_name InteractingState extends State

@onready var motor := %Motor
@onready var controller := %Controller


func state_enter():
	owner.set_indicator_visible(false)
	motor.enabled = false
	controller.enabled = false


func state_exit():
	owner.set_indicator_visible(true)
	motor.enabled = true
	controller.enabled = true
