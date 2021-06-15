extends TileMap

#Grass tilempa useful for spawning walls
export(PackedScene) var wall_entity
export(NodePath) var grass_tile_map
#Vector2 array of wall positions, in world space 
var tiles = []
var grass_tiles=[]
#registry of all wall entities, useful for upadtaing autotiles 
var entity_registry={}
signal create_wall (pos)
signal delete_wall (pos)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_all_tiles()
	get_grass_tiles()


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left_click"):
		#pass
		create_tile(get_global_mouse_position())
func get_grass_tiles():
	var grass_map = get_node(grass_tile_map)
	var grass_tiles_in_map = grass_map.get_used_cells()
	#converts from tile space to world space
	for tile in grass_tiles_in_map:
		grass_tiles.append(map_to_world(tile))



#gets all tiles in tilemap in world space and add to tiles list
func get_all_tiles():
	var tiles_in_map = get_used_cells()
	var tiles_in_world =[]
	#converts from tile space to world space
	for tile in tiles_in_map:
		tiles_in_world.append(map_to_world(tile))
	for tile in tiles_in_world:
		if not tile in tiles:
			tiles.append(tile)


#creates a new tile at a specified world pos, if there isnt one there already 
func create_tile(tile_pos_world):
	#snaps postion to a tilemap coordinate
	var tile_pos_map=world_to_map(tile_pos_world)
	tile_pos_world=map_to_world(tile_pos_map)
	#avoids overlapping walls
	if tile_pos_world in tiles:
		return 
	#makes sure wall is being placed on top of grass
	if not tile_pos_world in grass_tiles:
		return
	
	set_cellv(tile_pos_map,0)
	update_bitmask_area(tile_pos_map)
	var cell_autotile_coord = get_cell_autotile_coord(tile_pos_map.x,tile_pos_map.y)
	create_entity(tile_pos_world,cell_autotile_coord)
	tiles.append(tile_pos_world)
	emit_signal("create_wall",tile_pos_map)
	
	
#creates the wall entity that zombies can destroy
#In the next vesion of godot this will hopefully be much simpler
func create_entity(wall_pos,texture_pos):
	var created_wall = wall_entity.instance()
	created_wall.position = wall_pos +Global.TILE_SIZEV/2
	created_wall.texture_pos = texture_pos
	add_child(created_wall)
	created_wall.change_texture(texture_pos)
	entity_registry[wall_pos]=created_wall
	update_autotile_textures(wall_pos)
	created_wall.connect("die",self,"on_wall_destroy")
	

func update_autotile_textures(tile_pos_world):
	var tile_pos_map=world_to_map(tile_pos_world)
	for x in range(-1,2):

		for y in range(-1,2):
			var tile=tile_pos_map+Vector2(x,y)
			var tile_world = map_to_world(tile)
			if tile_world in tiles:
				var cell_autotile_coord = get_cell_autotile_coord(tile.x,tile.y)
				entity_registry[tile_world].change_texture(cell_autotile_coord)

func on_wall_destroy(position,wall):
	position=position-Global.TILE_SIZEV/2
	tiles.erase(position)
	entity_registry.erase(position)
	var wall_map = world_to_map(position)
	set_cellv(wall_map,-1)
	update_bitmask_area(wall_map)
	update_autotile_textures(position)
	wall.queue_free()
	emit_signal("delete_wall",wall_map)
