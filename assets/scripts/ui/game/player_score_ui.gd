class_name PlayerScoreUI extends Label

var player : Player

func setup(in_player : Player):
	player = in_player
	self_modulate = player.color
	text = "0"
	
	player.scored.connect(_on_player_scored)
	visible = true
	
func _on_player_scored(score_added):
	text = str(player.score)	
	
