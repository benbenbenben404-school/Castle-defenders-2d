extends Node2D

var used_cells = []
var drag_select = false  
var drag_command = false  
var selected = [] 
var drag_start = Vector2.ZERO
var drag_end = Vector2.ZERO
var drag_command_start = Vector2.ZERO
var drag_command_end = Vector2.ZERO
var select_rect = RectangleShape2D.new()  # Collision shape for drag box.
var cells_with_units=[]
export(NodePath) var pathFindingNode 
export(NodePath) var world_node 
var pathFinder
var unit_pos_display = []
class UnitSelection:
	var unit
	var unit_position_world
	var unit_dest_world
	var facing
	 
func _ready() -> void:
	pathFinder = get_node(pathFindingNode)

func _process(delta):
	selection()
	update()

	if Input.is_action_pressed("unit_command") and selected:
		unit_pos_display=[]	
		draw_command(drag_command_start,get_global_mouse_position())
		#clear_selected()

	if drag_command and not Input.is_action_pressed("unit_command"):

		#no longer dragging but was on last frame
		for unit in unit_pos_display:
			used_cells.append(unit.unit_dest_world)
			used_cells.erase(Global.map_to_world(Global.world_to_map(unit.unit_position_world)))

			unit.unit.get_astar_path(unit.unit_dest_world)
			unit.unit.end_rotation=unit.facing
		drag_command_end = get_global_mouse_position()
		get_units_in_rect(drag_command_start,drag_command_end)
		clear_selected()
		drag_command=false
	
	if not drag_command and Input.is_action_pressed("unit_command"):
		#If was not dragginbg on last frame but are on this one
		#clear_selected()
		drag_command=true
		drag_command_start=get_global_mouse_position()
	update()
	
	



func draw_command(drag_command_start,drag_command_end):
	var drag_command_start_map=Global.world_to_map(drag_command_start)
	var drag_command_end_map=Global.world_to_map(drag_command_end)


	var drag_relative_map =drag_command_end_map-drag_command_start_map
	if drag_relative_map.length() <2:
		drag_relative_map = Vector2(-sqrt(len(selected)),0)
	var drag_dir=Vector2.LEFT
	if drag_relative_map.y>abs(drag_relative_map.x):
		drag_dir=Vector2.DOWN
	if -drag_relative_map.y>abs(drag_relative_map.x):
		drag_dir=Vector2.UP
	if drag_relative_map.x>abs(drag_relative_map.y):
		drag_dir=Vector2.RIGHT
	if -drag_relative_map.x>abs(drag_relative_map.y):
		drag_dir=Vector2.LEFT
	var drag_dir_perp = drag_dir.rotated(deg2rad(90))

	var drag_length_map =floor(drag_relative_map.length()) * (drag_dir.x+drag_dir.y)

	var units_that_need_pos = len(selected)-1


	var	drag_unit_index_map = Vector2.ZERO
	while units_that_need_pos>=0:
		if drag_dir.y:
			if (drag_unit_index_map.y)==(drag_length_map):
				drag_unit_index_map.y=0
				drag_unit_index_map.x+=drag_dir_perp.x
		else:
			if (drag_unit_index_map.x)==(drag_length_map):
				drag_unit_index_map.x=0
				drag_unit_index_map.y+=drag_dir_perp.y

		var unit_dest_world = Global.map_to_world(drag_unit_index_map+drag_command_start_map)
		if check_is_valid(drag_unit_index_map+drag_command_start_map):
			var unit = selected[units_that_need_pos]
			var unit_selection  = UnitSelection.new()
			unit_selection.unit = unit
			unit_selection.unit_position_world = unit.global_position
			unit_selection.unit_dest_world = unit_dest_world
			unit_selection.facing = drag_dir_perp.rotated(deg2rad(180))
			unit_pos_display.append(unit_selection)

			units_that_need_pos-=1
			
		drag_unit_index_map+=drag_dir
		if (abs(drag_unit_index_map.x)+abs(drag_unit_index_map.y))>200:
			units_that_need_pos=-1
			

func check_is_valid(pos_in_map):
	var position_in_world = Global.map_to_world(pos_in_map)
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
	if not grass_collide.empty() and wall_collide.empty() :
		return true
	else:
		return false


func selection():
	if not drag_select and not Input.is_action_pressed("select"):
		#if was not dragging on lat frame and drag button is not pressed, return
		return
	if drag_select and not Input.is_action_pressed("select"):
		#no longer dragging but was on last frame
		drag_end = get_global_mouse_position()
		get_units_in_rect(drag_start,drag_end)
		select_units()
		drag_select=false
		return
	if not drag_select and Input.is_action_pressed("select"):
		#If was not dragginbg on last frame but are on this one
		clear_selected()
		drag_select=true
		drag_start=get_global_mouse_position()
		

func clear_selected(): 
	for unit in selected:
		unit.un_select()
	selected = []
		
	
func select_units():
	for unit in selected:
		unit.select() 
		

func get_units_in_rect(start, end):
	select_rect.extents = (drag_end - drag_start) / 2
	var space = get_world_2d().direct_space_state
	var query = Physics2DShapeQueryParameters.new()
	query.set_shape(select_rect)
	query.transform = Transform2D(0, (drag_end + drag_start) / 2)
	query.collision_layer = 0b1000
	var selected_space = space.intersect_shape(query, 999)
	selected=[]
	if selected_space:
		for unit in selected_space:
			selected.append((unit.collider).get_owner())

			
func _draw():
	if drag_select:
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
				Color(.5, .5, .5), false)
	if unit_pos_display and drag_command:
		for unit in unit_pos_display:
			draw_circle(unit.unit_dest_world+Global.TILE_SIZEV*0.5 ,10,Color(1,1,1,1))


