@abstract class_name Entity
extends CharacterBody2D

@export var max_health := 100
@export var immunity_time := 0.0
@export var knockback_decay := 800
@export var move_while_knocked := false

var health := max_health
var knockback_velocity := Vector2.ZERO

var last_hit := 0

@abstract func get_movement_velocity() -> Vector2
@abstract func handle_collision(collision: KinematicCollision2D) -> void

func deal_damage(amount: int, impulse: Vector2) -> void:
	if Time.get_ticks_msec() - last_hit <= immunity_time*1000:
		return

	health = max(health-amount, 0)
	knockback_velocity = impulse
	last_hit = Time.get_ticks_msec()

	if health == 0:
		kill()
		return

func kill() -> void:
	queue_free()

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if knockback_velocity.length() > 0: #do knockback first
		velocity += knockback_velocity	
	if knockback_velocity.length() == 0 or move_while_knocked:
		velocity += get_movement_velocity()
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)
	
	knockback_velocity -= knockback_velocity.normalized() * min(knockback_velocity.length(), knockback_decay*delta) 
