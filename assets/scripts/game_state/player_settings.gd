class_name PlayerSettings

var player_index : int
var is_ready := false
var device : int
var character_index : int

func get_print():
	return "P%s" % str(player_index + 1)
