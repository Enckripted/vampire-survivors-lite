@abstract class_name Enemy
extends Entity

const player_group_name := "player"

@export var speed := 300

var player: Node2D

@abstract func update() -> void

func _process(_delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group(player_group_name)

	update()
