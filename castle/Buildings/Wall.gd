extends Node2D


signal die(pos,wall)
var texture_pos =Vector2.ZERO
var health = 4 setget health_change
var max_health = 4

func _ready() -> void:	
	$Sprite.material.set_shader_param("maxHealth",max_health)
	$Sprite.material.set_shader_param("health",health)
func change_texture(texture_pos):
	$Sprite.region_rect=Rect2(texture_pos.x*64,texture_pos.y*64+640,64,64)

func die():
	emit_signal("die",position,self)
	
	
func health_change(new_health):
	health=new_health
	$Sprite.material.set_shader_param("health",health)
	if health <=0:
		die()
		


func _on_Wall_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed	("right_click"):
		self.health-=1
