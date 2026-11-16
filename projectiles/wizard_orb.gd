class_name WizardOrb
extends Area2D

const offscreen_margin := 32.0

@export var speed := 300.0
@export var damage := 5
@export var knockback_magnitude := 400.0

@onready var vis_screen_notifier = $VisibleOnScreenNotifier2D as VisibleOnScreenNotifier2D

var direction := Vector2.RIGHT

func setup(start_position: Vector2, travel_direction: Vector2, _damage: int = 5) -> void:
	position = start_position
	direction = travel_direction.normalized()
	damage = _damage

func _on_offscreen():
	queue_free()

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	vis_screen_notifier.screen_exited.connect(_on_offscreen)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	var player := body as Player
	player.deal_damage(damage, direction * knockback_magnitude)
	print("hit player")
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
