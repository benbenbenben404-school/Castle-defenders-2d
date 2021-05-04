extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var pointPath=[]
onready var UnitManager = get_node("../../..")
# Called when the node enters the scene tree for the first time.

func get_node_path(end_pos,start_pos=global_position):
	if Vector2(ceil(start_pos.x/Global.TILE_SIZE)*Global.TILE_SIZE,ceil(start_pos.y/Global.TILE_SIZE)*Global.TILE_SIZE) ==Vector2(ceil(end_pos.x/Global.TILE_SIZE)*Global.TILE_SIZE,ceil(end_pos.y/Global.TILE_SIZE)*Global.TILE_SIZE):
		return []
	pointPath=UnitManager.pathFinder.calculate_path(start_pos,end_pos)
	for i in range(len(pointPath)):
		pointPath[i].x+=12
		pointPath[i].y+=12
	return pointPath
	
func get_next_point():
	return pointPath[0]
	
func pass_point():
	pointPath.pop_front()

func is_path():
	return true if len(pointPath)>0 else false
