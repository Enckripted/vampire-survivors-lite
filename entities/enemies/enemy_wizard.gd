class_name EnemyWizard
extends Enemy

enum State { TARGETING, CHARGING }

@export var orb_damaage := 5
@export var orb_knockback := 200
@export var charge_time_secs := 1
@export var charge_speed_divisor := 5
@export var orb_projectile: PackedScene

@onready var firing_area = $FiringArea as Area2D

var state := State.TARGETING
var anchor_pos := Vector2.ZERO # used while shaking to make sure they stay near the same spot
var time_charge_start := 0
var player_in_fire_range := false

func start_charging_orb() -> void:
	anchor_pos = position
	time_charge_start = Time.get_ticks_msec()
	state = State.CHARGING

func fire_orb() -> void:
	#TODO: instantiate orb
	var n_orb = orb_projectile.instantiate() as WizardOrb
	var dir = (player.position-position).normalized()
	n_orb.setup(position, dir, orb_damaage)
	get_tree().current_scene.add_child(n_orb)

	state = State.TARGETING

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_fire_range = true

func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		player_in_fire_range = false

func get_movement_velocity() -> Vector2:
	if player == null:
		return Vector2.ZERO

	if state == State.CHARGING and Time.get_ticks_msec()-time_charge_start >= charge_time_secs*1000:
		fire_orb()
	if state == State.TARGETING and player_in_fire_range:
		start_charging_orb()
	
	var direction: Vector2
	if state == State.TARGETING:
		direction = (player.position - position).normalized()
	else: # idk bout this one
		direction = (Vector2(randf_range(-1, 1), randf_range(-1, 1)) - (position - anchor_pos)).normalized()
	return speed * direction / (charge_speed_divisor if state == State.CHARGING else 1)

func handle_collision(_collision: KinematicCollision2D) -> void:
	pass

func _ready() -> void:
	super._ready()
	firing_area.body_entered.connect(_on_body_entered)
	firing_area.body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	super._process(_delta)
