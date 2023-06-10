extends Node

const FP_PLAYER = "res://content/overworld/playing_pieces/list/alice.tscn"

var player
var interracting_with: PlayingPiece
var spawn_index

func _ready():
	var pksc_player = load(FP_PLAYER)
	player = pksc_player.instantiate()
	add_child(player)


func goto_map():
	get_node("/root/Game/Grid").remove_child(player)
	add_child(player)
	
	spawn_index = interracting_with.target_child_index
	get_tree().change_scene_to_file(interracting_with.target_map)
