extends Control

# this is UI that should only be instantitated when game_scene is running
@export var player: Player

@onready var game_state = get_node("/root/GameScene/GameState") as GameState
@onready var health_text = $HealthText as Label
@onready var score_text = $ScoreText as Label

func _process(_delta: float) -> void:
	health_text.text = "Health: %s" % (str(player.health) if player != null else "0")
	score_text.text = "Score: %s" % str(game_state.score)
