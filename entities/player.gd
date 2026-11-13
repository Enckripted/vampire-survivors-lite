class_name Player
extends Entity

@export var speed := 400
@export var attack_knockback := 800

@onready var auto_attack_timer = $AutoAttackTimer as Timer
@onready var auto_attack_area = $AutoAttackArea as Area2D

var direction := Vector2.ZERO

func get_movement_velocity() -> Vector2:
	return speed * direction

func handle_collision(_collision: KinematicCollision2D) -> void:
	pass

func enemy_dist_away(enemy: Enemy):
	return (enemy.position - position).length()

func auto_attack():
	var bodies = auto_attack_area.get_overlapping_bodies()
	print(bodies.size())
	var target: Enemy = null

	for body in bodies:
		var enemy = body as Enemy
		if enemy == null:
			continue
		
		if target == null or enemy_dist_away(target) < enemy_dist_away(enemy):
			target = enemy
	
	if target == null:
		return
	var knockback_dir = (target.position-position).normalized()
	target.deal_damage(5, knockback_dir * attack_knockback)

func _process(_delta: float) -> void:
	direction = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		direction += Vector2.UP
	if Input.is_action_pressed("ui_down"):
		direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		direction += Vector2.RIGHT
	direction = direction.normalized()

func _on_auto_attack_timer_timeout() -> void:
	auto_attack()

