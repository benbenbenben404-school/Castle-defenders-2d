extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export(Resource) var worldGenLines
export(Vector2) var mapSize

onready var grassTileMap = get_node("Grass")# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	var tile = Vector2.ZERO
	for x in mapSize.x:
		for y in mapSize.y:
			tile = Vector2(x,y)
			print(worldGenLines.get_closest_line(tile))
			if worldGenLines.distance_to_lines(tile)>worldGenLines.get_closest_line(tile).width:
				grassTileMap.set_cellv(tile,0)
			print(worldGenLines.get_closest_line(tile))
			
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
