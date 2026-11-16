@abstract class_name Enemy
extends Entity

const player_group_name := "player"

@export var speed := 300
@export var pickup_amount := 5
@export var pickup_radius := 30
@export var max_distance_from_player := 1200

@export var pickup_scene: PackedScene

var player: Player

func spawn_pickup() -> void:
	var dx = randi_range(-pickup_radius, pickup_radius)
	var dy = randi_range(-pickup_radius, pickup_radius)

	var n_pickup = pickup_scene.instantiate()
	n_pickup.position = position + Vector2(dx, dy)
	get_tree().current_scene.add_child(n_pickup)

func spawn_pickups() -> void:
	for i in range(pickup_amount):
		spawn_pickup()

func _on_died() -> void:
	spawn_pickups()

func _ready() -> void:
	super._ready()
	died.connect(_on_died)

	player = get_tree().get_first_node_in_group("player") as Player

func _process(_delta: float) -> void:
	if player != null and position.distance_to(player.position) >= max_distance_from_player:
		despawn()
