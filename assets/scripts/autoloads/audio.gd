extends Node

class Events:
	const START = "{0aed6e1e-461c-4731-b7f9-719ca10d3e33}"

func _ready():
	print("test")
	FMODRuntime.play_one_shot_id(Events.START)
	pass
	
func play_test():
	pass