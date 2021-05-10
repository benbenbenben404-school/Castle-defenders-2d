tool
extends ColorRect


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var zoom = 1 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material.set_shader_param("tex_size", rect_size)
	material.set_shader_param("zoom", zoom)
	Global.connect("change_zoom",self,"set_zoom")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func set_zoom(new_zoom):
	zoom = new_zoom
	material.set_shader_param("zoom", zoom.x)




