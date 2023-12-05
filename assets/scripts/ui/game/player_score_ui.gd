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
	var tween = create_tween()
	tween.tween_property(score_label, "scale", Vector2(1.5, 1.5), 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(score_label, "scale", Vector2.ONE, 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
