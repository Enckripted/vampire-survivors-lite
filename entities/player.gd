class_name Player
extends Entity

@export var speed = 400

var direction := Vector2.ZERO

func get_movement_velocity() -> Vector2:
	return speed * direction

func handle_collision(_collision: KinematicCollision2D) -> void:
	pass

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
