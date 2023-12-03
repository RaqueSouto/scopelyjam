class_name PlayerInteractor extends Area2D

var player : Player

func _ready():
	await owner.ready
	player = owner
	
	area_entered.connect(_on_area_entered)


func _on_area_entered(body):
	if body == player:
		return
			
	elif body.owner is Player:
		var direction = (body.owner.global_position - player.global_position).normalized()
		body.owner.crash(direction * player.config.impact_force)
		
	if body is Item:
		player.add_items(body)
		
