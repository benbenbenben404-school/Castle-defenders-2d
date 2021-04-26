extends Node2D


export(NodePath) var pathFindingNode 
var pathFinder
var endPos = Vector2.ZERO
onready var zombie_spawns = get_node("Zombie spawns")
var spawns = []
var zombie = preload("Zombie.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pathFinder = get_node(pathFindingNode)
	endPos = get_node("EndPos").global_position
	for node in zombie_spawns.get_children():
		spawns.append(node.global_position)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func select_spawn():
	return spawns[randi() % spawns.size()]

func _on_Spawn_Timer_timeout() -> void:
	var Zombie = zombie.instance()
	Zombie.global_position = select_spawn()
	add_child(Zombie)
