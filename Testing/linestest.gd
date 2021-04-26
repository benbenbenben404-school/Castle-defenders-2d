tool
extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var LineScene = preload("res://Testing/line.tscn")
export(Resource) var lines
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(lines.points)
	for point in lines.points:
		#print(point)
		var linescene = LineScene.instance()
		linescene.points =[lines.points[point]["position"],lines.points[point]["position"]+Vector2(10,0)];
		linescene.default_color = Color.from_hsv(1.0*lines.points[point]["depth"]/lines.tree_depth,1.0,1.0)
		add_child(linescene)
	for line in lines.lines:
		#print(line)
		#print(lines.lines[line])
		var linescene = LineScene.instance()
		linescene.points = [lines.lines[line]["start_pos"],lines.lines[line]["end_pos"],]
		linescene.default_color = Color.from_hsv(1.0*lines.lines[line]["depth"]/lines.tree_depth,1.0,1.0)
		add_child(linescene)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
