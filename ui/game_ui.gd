extends Control

# this is UI that should only be instantitated when game_scene is running
@export var player: Player

@onready var health_text: Label = $HealthText

func _process(_delta: float) -> void:
	health_text.text = str(player.health) if player != null else "0"
