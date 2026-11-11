extends CharacterBody2D

var speed = 400

func _init() -> void:
	print("hello world")

func _process(_delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		direction += Vector2.UP
	if Input.is_action_pressed("ui_down"):
		direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		direction += Vector2.RIGHT
	direction = direction.normalized()
	
	velocity = direction * speed

func _physics_process(_delta: float) -> void:
	move_and_slide()
