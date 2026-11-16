class_name Player
extends Entity

@export var speed := 400
@export var attack_knockback := 800
@export var attack_damage := 10
@export var sword_attack: PackedScene

@onready var auto_attack_timer = $AutoAttackTimer as Timer
@onready var auto_attack_area = $AutoAttackArea as Area2D
@onready var auto_attack_bar = $AutoAttackCooldown as ProgressBar
var game_state: GameState

var upgradesAt = [100, 200, 400] # surely they wont get this
var nextUpgradeInd = 0

var direction := Vector2.ZERO

func get_movement_velocity() -> Vector2:
	return speed * direction

func handle_collision(_collision: KinematicCollision2D) -> void:
	pass

func enemy_dist_away(enemy: Enemy):
	return (enemy.position - position).length()

func auto_attack():
	var target: Enemy = null
	var bodies = auto_attack_area.get_overlapping_bodies()

	for body in bodies:
		var enemy = body as Enemy
		if enemy == null:
			continue
		
		if target == null or enemy_dist_away(target) > enemy_dist_away(enemy):
			target = enemy
	if target == null:
		return

	var n_attack = sword_attack.instantiate() as SwordAttack
	n_attack.position = target.position
	n_attack.setup(position, attack_damage, attack_knockback)
	get_tree().current_scene.add_child(n_attack)

func _ready() -> void:
	game_state = get_node("/root/GameScene/GameState") as GameState
	super._ready()

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
	
	var time_elapsed = auto_attack_timer.wait_time - auto_attack_timer.time_left
	auto_attack_bar.value = time_elapsed / auto_attack_timer.wait_time * 100

	if nextUpgradeInd < upgradesAt.size() and game_state.score >= upgradesAt[nextUpgradeInd]:
		attack_damage += 5
		nextUpgradeInd += 1

func _on_auto_attack_timer_timeout() -> void:
	auto_attack()
