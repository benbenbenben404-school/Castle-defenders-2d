extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

const TILE_SIZE=24
const TILE_SIZEV=Vector2(TILE_SIZE,TILE_SIZE)
var zoom = 1
signal change_zoom (zoom)
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


func change_zoom(new_zoom):
	zoom = new_zoom
	emit_signal("change_zoom",zoom)
func get_zoom():
	return zoom
