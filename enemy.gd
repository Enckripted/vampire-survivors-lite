extends Entity

@export var speed = 300

func get_movement_velocity() -> Vector2:
	if player == null:
		return Vector2.ZERO
	
	var direction = (player.position - position).normalized()
	return speed * direction
	
