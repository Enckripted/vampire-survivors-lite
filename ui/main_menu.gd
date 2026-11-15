extends Control

@export var game_scene: PackedScene

@onready var play_button = $PlayButton as Button

func go_to_game() -> void:
	get_tree().change_scene_to_packed(game_scene)

func _ready() -> void:
	play_button.pressed.connect(go_to_game)
