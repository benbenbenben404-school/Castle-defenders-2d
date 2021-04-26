extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var used_cells = []
var dragging = false  
var selected = [] 
var drag_start = Vector2.ZERO
var select_rect = RectangleShape2D.new()  # Collision shape for drag box.
export(NodePath) var pathFindingNode 
var pathFinder
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pathFinder = get_node(pathFindingNode)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			# We only want to start a drag if there's no selection.

			if selected.size() == 0:
				dragging = true
				drag_start = get_global_mouse_position()
			else:
				for unit in selected:
					unit.collider.get_astar_path(get_global_mouse_position())
				selected = []
		elif dragging:
			# Button released while dragging.

			dragging = false
			update()
			var drag_end = get_global_mouse_position()
			select_rect.extents = (drag_end - drag_start) / 2
			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
			query.set_shape(select_rect)
			query.transform = Transform2D(0, (drag_end + drag_start) / 2)
			print(drag_start)
			print(drag_end)
			query.collision_layer = 0b1000
			selected = space.intersect_shape(query)
			print(selected)
	if event is InputEventMouseMotion and dragging:
		update()

func _draw():
	if dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
				Color(.5, .5, .5), false)
