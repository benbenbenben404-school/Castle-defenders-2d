extends Node2D
onready var pathTimer= get_node("PathTimer")

export var move_speed=10

onready var PathGetter = get_node("PathGetter")
onready var ZombieManager = get_node("..")


func _ready() -> void:
	pathTimer.wait_time= randf()*5+5


	
func calculate_path_to_dest():
	PathGetter.get_node_path(ZombieManager.endPos)

func _process(delta: float) -> void:
	if PathGetter.is_path():
		var dir_to_point = (PathGetter.get_next_point()-global_position).normalized()
		var movement = dir_to_point *move_speed
		if (PathGetter.get_next_point() - global_position).length() <10:
			PathGetter.pass_point()
		global_position+=movement
		



func _on_Timer_timeout() -> void:
	calculate_path_to_dest()
