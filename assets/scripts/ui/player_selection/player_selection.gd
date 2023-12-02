class_name PlayerSelection extends Node

signal player_joined(PlayerSettings)

@onready var character_selection = %CharacterSelection

var pendant_devices : Dictionary

func _ready():
	for device in Input.get_connected_joypads():
		add_device(device)
	
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	GameState.players.player_list_change.connect(_on_player_list_change)
	
	
func _on_joy_connection_changed(device : int, connected : bool):
	if connected:
		add_device(device)
	elif pendant_devices.has(device):
		remove_device(device)
			


func add_device(device : int):
	var device_input = DeviceInput.new(device)
	pendant_devices[device] = device_input


func remove_device(device : int):
	pendant_devices.erase(device)
	
	
func _process(delta):
	for device in pendant_devices:
		if pendant_devices[device].is_action_just_pressed("join"):
			GameState.players.add_player(device, pendant_devices[device])
			call_deferred("remove_device")

func _on_player_list_change():
	for player_settings : PlayerSettings in GameState.players.list:
		print(str(player_settings))
