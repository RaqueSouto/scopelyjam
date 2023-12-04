class_name PlayerScoreUI extends TextureRect

var player : Player

@onready var score_label = %ScoreLabel

func setup(in_player : Player):
	player = in_player
	score_label.self_modulate = player.color
	score_label.text = "0"
	
	player.scored.connect(_on_player_scored)
	visible = true
	
func _on_player_scored(score_added):
	score_label.text = str(player.score)	
	
