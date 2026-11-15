# we want to spawn enemies just outside of player view
extends Timer

@export var enemy_scene: PackedScene
@export var spawn_limit: int

var spawned_enemies: int

func on_enemy_death():
	spawned_enemies -= 1

func find_enemy_spawn_location() -> Vector2:
	var vrect = get_viewport().get_visible_rect().size
	var center = get_viewport().get_camera_2d().get_screen_center_position()

	var width_ratio = vrect.x / (vrect.x + vrect.y)
	var side = -1 + 2*floor(randf() / 0.5)
	if randf() <= width_ratio: #do it on the horizontal side
		return center + Vector2((randf()*vrect.x), (side * vrect.y/2))
	else: #do it on the vertical side
		return center + Vector2((side * vrect.x/2), (randf()*vrect.y))

func spawn_enemy_at(spawn_pos: Vector2) -> void:
	var n_enemy = enemy_scene.instantiate() as Enemy
	n_enemy.position = spawn_pos
	n_enemy.died.connect(on_enemy_death)

	add_child(n_enemy)
	spawned_enemies += 1

func attempt_enemy_spawn() -> void:
	if spawned_enemies >= spawn_limit:
		return
	
	var spawn_location = find_enemy_spawn_location()
	spawn_enemy_at(spawn_location)

func _on_timeout() -> void:
	attempt_enemy_spawn()
