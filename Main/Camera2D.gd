extends Camera2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export var move_speed = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var move_vector = Vector2.ZERO
	if Input.is_action_pressed("up"):
		move_vector.y+=-1
	if Input.is_action_pressed("down"):
		move_vector.y+=1
	if Input.is_action_pressed("left"):
		move_vector.x+=-1
	if Input.is_action_pressed("right"):
		move_vector.x+=1
	position+=move_vector*move_speed*delta*pow((zoom.x+1),2)


func _input(event: InputEvent) -> void:
	if event.is_action("scroll_down"):
		zoom=zoom*1.1
	if event.is_action("scroll_up"):
		zoom=zoom*0.9
	if zoom.length() >50:
		zoom = Vector2(30,30)
	Global.change_zoom(zoom)
