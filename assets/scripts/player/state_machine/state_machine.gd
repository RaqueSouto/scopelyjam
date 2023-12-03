class_name StateMachine extends Node

signal state_changed(state : State)

@export var initial_state : State


var current_state : State :
	set(value):
		current_state = value
		state_changed.emit(value)


func _ready():
	await owner.ready
	for child in get_children():
		child.state_machine = self


func init():
	set_state(initial_state)


func set_state(state : State):
	current_state = state
	current_state.state_enter()
	

func _unhandled_input(event):
	if current_state == null:
		return
	current_state.state_input(event)
	

func _process(delta):
	if current_state == null:
		return
	current_state.state_process(delta)


func _physics_process(delta):
	if current_state == null:
		return
	current_state.state_physics_process(delta)


func change_state(state : State, force : bool = false):
	if state == current_state and not force: 
		return
	
	print("set state: %s" % str(state))
	
	current_state.state_exit()
	set_state(state)
