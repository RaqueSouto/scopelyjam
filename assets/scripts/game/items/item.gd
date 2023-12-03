class_name Item extends Area2D

const speed := 800
const angular_speed := 10
const follow_offset := 75
const far_offset := 240
const impact_force := 800
const deceleration := 6

enum EItemType {
	NONE,
	TAMAGOCHI,
	GAMEBOY,
	MSN,
	VHS
}

@export var type : EItemType

var velocity : Vector2
var direction : Vector2
var current_speed : float

var player_owner : Player
var item_parent : Node2D 
var item_child : Item

var follow_offset_squared : float
var far_offset_squared : float


@onready var animation = $AnimationPlayer
@onready var renderer = $Renderer


func _ready():
	follow_offset_squared = follow_offset * follow_offset


func follow(delta : float):
	var desired_direction = (item_parent.global_position - global_position).normalized()
	direction = direction.lerp(desired_direction, angular_speed * delta).normalized()
	
	var distance_squared = global_position.distance_squared_to(item_parent.global_position)
	
	if distance_squared < follow_offset_squared:
		return
	
	if distance_squared < far_offset_squared:
		current_speed = item_parent.current_speed
		
	else:
		current_speed = speed
	
	
	global_position += direction * current_speed * delta



func impact_and_unfollow():
	if item_parent is Item:
		item_parent.detach_child()
	
	player_owner = null
	item_parent = null
	
	renderer.material.set("shader_parameter/line_color", Color.WHITE)
	
	animation.play("idle")
	velocity = Vector2.from_angle(randf_range(0, PI * 2)) * impact_force
	
	
func destroy():
	if item_parent != null and not item_parent.is_queued_for_deletion() and item_parent is Item:
		item_parent.detach_child()
	
	player_owner = null
	item_parent = null
	queue_free()
	
	
func _physics_process(delta):
	if item_parent != null:
		return
		
	if velocity == Vector2.ZERO:
		return
		
	velocity = velocity.slerp(Vector2.ZERO, deceleration * delta)
	global_position += velocity * delta


func _process(delta):
	if velocity.x < 0:
		renderer.flip_h = true
	elif velocity.x > 0:
		renderer.flip_h = false
		
	elif direction.x < 0:
		renderer.flip_h = true
	elif direction.x > 0:
		renderer.flip_h = false
	

func change_owner(new_player_owner : Player, new_item_parent : Node2D):
	if player_owner == new_player_owner:
		return
		
	animation.play("walk")
	
	
	if item_parent != null and not item_parent.is_queued_for_deletion() and item_parent is Item:
		item_parent.detach_child()
	
	if player_owner != null:
		player_owner.remove_item(self)
	
	item_parent = new_item_parent
	player_owner = new_player_owner
	renderer.material.set("shader_parameter/line_color", player_owner.color)
	
	if item_parent is Item:
		item_parent.attach_child(self)
		
	direction = (item_parent.global_position - global_position).normalized()


func attach_child(item : Item):
	item_child = item
	

func detach_child():
	item_child = null
