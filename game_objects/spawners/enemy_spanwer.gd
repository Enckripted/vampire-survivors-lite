# we want to spawn enemies just outside of player view
extends Timer

@export var spawn_entries: Array[EnemySpawnEntry] = []
var spawned_count: Array[int] = []
var spawn_weight_sum := 0

func on_enemy_despawn(index: int):
	spawned_count[index] -= 1

func choose_rand_enemy_index() -> int:
	assert(spawn_weight_sum > 0)

	var chosen = randi_range(1, spawn_weight_sum)
	var sum = 0
	for i in range(spawn_entries.size()):
		sum += spawn_entries[i].spawn_weight
		if sum >= chosen:
			return i
	return 0

func find_enemy_spawn_location() -> Vector2:
	var camera = get_viewport().get_camera_2d()
	var vrect = get_viewport().get_visible_rect().size
	var center = camera.get_screen_center_position()

	var width_ratio = vrect.x / (vrect.x + vrect.y)
	var side = -1 + 2*floor(randf() / 0.5)
	if randf() <= width_ratio: #do it on the horizontal side
		return center + Vector2((randf()*vrect.x), (side * vrect.y/2))
	else: #do it on the vertical side
		return center + Vector2((side * vrect.x/2), (randf()*vrect.y))

func spawn_enemy_at(index: int, spawn_pos: Vector2) -> void:
	var n_enemy = spawn_entries[index].enemy_scene.instantiate() as Enemy
	n_enemy.position = spawn_pos
	n_enemy.despawned.connect(func ():
		on_enemy_despawn(index)
	)

	add_child(n_enemy)
	spawned_count[index] += 1

func attempt_enemy_spawn() -> void:
	var index = choose_rand_enemy_index()
	if spawned_count[index] >= spawn_entries[index].spawn_limit or get_viewport().get_camera_2d() == null:
		return

	var spawn_location = find_enemy_spawn_location()
	spawn_enemy_at(index, spawn_location)

func _on_timeout() -> void:
	attempt_enemy_spawn()

func _ready() -> void:
	for entry in spawn_entries:
		spawn_weight_sum += entry.spawn_weight
		spawned_count.append(0)
