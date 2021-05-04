extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

const TILE_SIZE=24
const TILE_SIZEV=Vector2(TILE_SIZE,TILE_SIZE)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func map_to_world(position):
	return position *TILE_SIZE
	
func world_to_map(position):
	return Vector2(floor(position.x/TILE_SIZE),floor(position.y/TILE_SIZE))
