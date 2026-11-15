extends Node
class_name GameState

# becuase main_menu already points to this scene we cant use an export reference
# see https://forum.godotengine.org/t/parse-error-referenced-non-existent-resource/95356/9
# for now we will do it the dirty way
var main_menu_address := "res://ui/main_menu.tscn"

# TODO: change all references to player to this one?
# or does that make everything too tightly coupled
var player: Player

var score := 0

func game_over():
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file(main_menu_address)

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.died.connect(game_over)	
