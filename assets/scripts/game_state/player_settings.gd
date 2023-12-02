class_name PlayerSettings

var player_index : int
var is_ready := false
var device : int
var device_input : DeviceInput
var character_index : int:
	set(value):
		character_index = value

func get_print():
	return "P%s" % str(player_index + 1)
