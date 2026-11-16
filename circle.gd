@tool
extends Node2D

@export var radius: int

func _draw() -> void:
    draw_arc(Vector2.ZERO, radius, 0.0, TAU, 64, Color.WHITE, 2.0, true)