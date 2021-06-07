extends Node2D

export var move_speed=10
export var rotate_speed=10
var end_rotation = Vector2.DOWN
onready var PathGetter = get_node("Character/PathGetter")

var selected = false
onready var selectedSprite=$Character/SelectedSprite
onready var character=$Character
onready var sprite =$Character/Sprite
func _ready():
	selectedSprite.hide()
	sprite.frame = rand_range(0,3)
func _physics_process(delta: float) -> void:
	if PathGetter.is_path():
		var dir_to_point = (PathGetter.get_next_point()-global_position).normalized()
		rotate_towards(dir_to_point,rotate_speed*delta)
		var movement = dir_to_point *move_speed
		if (PathGetter.get_next_point() - global_position).length() <1:
			PathGetter.pass_point()
		global_position+=movement *delta
	else:
		rotate_towards(end_rotation,rotate_speed*delta)
func check_pathable(position_in_world):
	var space = get_world_2d().direct_space_state
	var query = Physics2DShapeQueryParameters.new()
	var shape = CircleShape2D.new()
	shape.radius=1
	query.set_shape(shape)
	query.transform = Transform2D(0,position_in_world)
	query.collision_layer = 0b10
	var grass_collide = space.intersect_shape(query)
	query.collision_layer = 0b100
	var wall_collide = space.intersect_shape(query)

	if not grass_collide.empty() and wall_collide.empty():
		return true
	else:
		return false
		
func rotate_towards(end_vector, turn_rate):
	character.rotation = Vector2.RIGHT.rotated(character.rotation).slerp(end_vector,turn_rate).angle()
		
func get_astar_path(position_in_world):
	#check if position is in grass, and not in  builiding

	if not check_pathable(position_in_world):
		return

	PathGetter.get_node_path(position_in_world)


func select():
	selectedSprite.show()

func un_select():
	selectedSprite.hide()
