@abstract class_name Entity
extends CharacterBody2D

@export var max_health: int = 100
@export var knockback_decay: int = 800

var health = max_health
var knockback_velocity = Vector2.ZERO

@abstract func get_movement_velocity() -> Vector2

func take_damage(amount: int, impulse: Vector2) -> void:
	health = max(health-amount, 0)
	knockback_velocity = impulse

	if health == 0:
		kill()
		return

func kill() -> void:
	queue_free()

func _physics_process(delta: float) -> void:
	if knockback_velocity.length() > 0: #do knockback first
		velocity = knockback_velocity	
	else:
		velocity = get_movement_velocity()
	move_and_collide(velocity * delta)
	
	knockback_velocity -= knockback_velocity.normalized() * min(knockback_velocity.length(), knockback_decay*delta) 
	if knockback_velocity.length() > 0:
		print(knockback_velocity)
