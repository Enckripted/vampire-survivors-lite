extends Area2D

@export var value := 1

@onready var game_state = get_node("/root/GameScene/GameState") as GameState

func pickup():
	game_state.score += value
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	var player = body as Player
	if player == null:
		return
	
	# player picked it up
	pickup()

func _ready() -> void:
	body_entered.connect(_on_body_entered)