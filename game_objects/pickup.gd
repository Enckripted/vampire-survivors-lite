extends Area2D

@export var value := 1
@export var velocity := 700
@export var pickup_area_name := "PickupArea"

@onready var game_state = get_node("/root/GameScene/GameState") as GameState
@onready var player: Player

var following_player = false

func follow_player(delta: float):
	var direction = (player.position-position).normalized()
	var mag = velocity * delta
	if mag >= position.distance_to(player.position):
		pickup()
		return
	position += direction * mag

func pickup() -> void:
	game_state.score += value
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.name == pickup_area_name and not following_player:
		following_player = true

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if following_player:
		follow_player(delta)