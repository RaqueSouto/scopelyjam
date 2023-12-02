class_name CharacterRepository extends Node

func get_character(index : int) -> CharacterConfig:
	return get_child(index)
