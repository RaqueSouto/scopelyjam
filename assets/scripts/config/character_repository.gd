class_name CharacterRepository extends Node

func count_characters() -> int:
	return get_child_count()


func get_character(index : int) -> CharacterConfig:
	return get_child(index)
	
	
func get_last_character_index() -> int:
	return get_child_count() - 1
