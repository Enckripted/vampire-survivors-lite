class_name SwordAttack
extends Area2D

var caster_position: Vector2
var damage: int
var knockback_magnitude: int

var ticks = 0

func slash():
	var bodies = get_overlapping_bodies()
	for body in bodies:
		var enemy = body as Enemy
		if enemy == null:
			continue
		
		enemy.deal_damage(10, (enemy.position-caster_position).normalized() * knockback_magnitude)

func setup(_player_position: Vector2, _damage: int, _knockback_magnitude: int) -> void:
	caster_position = _player_position
	damage = _damage
	knockback_magnitude = _knockback_magnitude

func _physics_process(_delta: float) -> void:
	if ticks == 1:
		slash()
	ticks += 1
