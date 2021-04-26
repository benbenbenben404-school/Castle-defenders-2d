extends KinematicBody2D

export var move_speed=10

onready var PathGetter = get_node("PathGetter")




func _process(delta: float) -> void:
	if PathGetter.is_path():
		var dir_to_point = (PathGetter.get_next_point()-global_position).normalized()
		var movement = dir_to_point *move_speed
		if (PathGetter.get_next_point() - global_position).length() <10:
			PathGetter.pass_point()
		global_position+=movement
		
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
func get_astar_path(position_in_world):
	#check if position is in grass, and not in  builiding
	if not check_pathable(position_in_world):
		return
	PathGetter.get_node_path(get_global_mouse_position())
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		get_astar_path(get_global_mouse_position())

			 
