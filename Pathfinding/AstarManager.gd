extends Node

export(NodePath) var terrain_tile_map
export(NodePath) var wall_tile_map 
export var wall_cost = 10
export(Vector2) var map_size= Vector2(100,100)
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var astar_node = AStar.new()
var start_pos
var end_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var walkable_cells= get_node(terrain_tile_map).get_used_cells_by_id(1)
	astar_add_walkable_cells(walkable_cells)
	astar_connect_walkable_cells(walkable_cells)
	var walls = get_node(wall_tile_map).get_used_cells_by_id(0)
	for wall in walls:
		edit_astar_connection_weight(wall,wall_cost)
	get_node(wall_tile_map).connect("create_wall",self,"wall_create")
	get_node(wall_tile_map).connect("delete_wall",self,"wall_destroy")

func astar_add_walkable_cells(cells):
	for cell in cells:
		astar_node.add_point(calculate_point_index(cell),Vector3(cell.x,cell.y,0),1)


func edit_astar_connection_weight(cell,weight):
	astar_node.add_point(calculate_point_index(cell),Vector3(cell.x,cell.y,0),weight)
	
	
func calculate_point_index(point):
	print(point)
	point +=map_size/2
	print(point)
	return (point.x+10000) + map_size.x * (point.y+10000)


func astar_connect_walkable_cells(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		# For every cell in the map, we check the one to the top, right.
		# left and bottom of it. If it's in the map and not an obstalce.
		# We connect the current point with it.
		var points_relative = PoolVector2Array([
			point + Vector2.RIGHT,
			point + Vector2.LEFT,
			point + Vector2.DOWN,
			point + Vector2.UP,
			point + Vector2(1,1),
			point + Vector2(-1,1),
			point + Vector2(1,-1),
			point + Vector2(-1,-1),
		])
		for point_relative in points_relative:
			var point_relative_index = calculate_point_index(point_relative)

			if not astar_node.has_point(point_relative_index):
				continue
			# Note the 3rd argument. It tells the astar_node that we want the
			# connection to be bilateral: from point A to B and B to A.
			# If you set this value to false, it becomes a one-way path.
			# As we loop through all points we can set it to false.
			astar_node.connect_points(point_index, point_relative_index, false)


func calculate_path(start_pos, end_pos):

	start_pos = get_node(terrain_tile_map).world_to_map(start_pos)
	end_pos = get_node(terrain_tile_map).world_to_map(end_pos)


	var start_point_index = astar_node.get_closest_point(Vector3(start_pos.x,start_pos.y,0))
	var end_point_index =astar_node.get_closest_point(Vector3(end_pos.x,end_pos.y,0))
	print(start_point_index)
	print(end_point_index)


	var point_path_ids = astar_node.get_point_path(start_point_index, end_point_index)

	var point_path =[]
	for point in point_path_ids:
		point_path.append(get_node(terrain_tile_map).map_to_world(Vector2(point.x,point.y)))

	return point_path



func wall_create(position):
	edit_astar_connection_weight(position,wall_cost)

func wall_destroy(position):
	edit_astar_connection_weight(position,1)

#func _draw():
#	if not _point_path:
#		return
#	var point_start = _point_path[0]
#	var point_end = _point_path[len(_point_path) - 1]
#
#	set_cell(point_start.x, point_start.y, 1)
#	set_cell(point_end.x, point_end.y, 2)
#
#	var last_point = map_to_world(Vector2(point_start.x, point_start.y)) + _half_cell_size
#	for index in range(1, len(_point_path)):
#		var current_point = map_to_world(Vector2(_point_path[index].x, _point_path[index].y)) + _half_cell_size
#		draw_line(last_point, current_point, DRAW_COLOR, BASE_LINE_WIDTH, true)
#		draw_circle(current_point, BASE_LINE_WIDTH * 2.0, DRAW_COLOR)
#		last_point = current_point
#
