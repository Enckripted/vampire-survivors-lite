class_name BasicEnemy
extends Enemy

@export var damage_amount := 5
@export var knockback_magnitude := 200

func get_movement_velocity() -> Vector2:
	if player == null:
		return Vector2.ZERO
	
	var direction = (player.position - position).normalized()
	return speed * direction

func update() -> void:
	pass

func handle_collision(collision: KinematicCollision2D) -> void:
	var body = collision.get_collider() as CharacterBody2D
	if body == null || !body.is_in_group(player_group_name):
		return
	print(body.name)
	# deal damage to the player
	var knockback_dir = (player.position-position).normalized()
	player.deal_damage(damage_amount, knockback_dir * knockback_magnitude)