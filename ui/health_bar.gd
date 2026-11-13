extends ProgressBar

@export var targetEntity: Entity
@export var showWhileFull := false

func _process(_delta: float) -> void:
	var percentage = (targetEntity.health as float) / targetEntity.max_health
	visible = percentage < 1
	value = percentage * 100
