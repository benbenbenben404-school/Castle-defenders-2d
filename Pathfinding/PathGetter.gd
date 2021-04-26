extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var pointPath=[]
onready var UnitManager = get_node("../..")
# Called when the node enters the scene tree for the first time.

func get_node_path(end_pos,start_pos=global_position):
	if Vector2(ceil(start_pos.x/64)*64,ceil(start_pos.y/64)*64) ==Vector2(ceil(end_pos.x/64)*64,ceil(end_pos.y/64)*64):
		return []
	pointPath=UnitManager.pathFinder.calculate_path(start_pos,end_pos)
	pointPath.append(end_pos)
	return pointPath
	
func get_next_point():
	return pointPath[0]
	
func pass_point():
	pointPath.pop_front()

func is_path():
	return true if len(pointPath)>0 else false
