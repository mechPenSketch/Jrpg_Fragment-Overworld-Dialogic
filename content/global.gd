extends Node

const fp_player = "res://content/overworld/playing_pieces/list/alice.tscn"

var player
var interracting_with: PlayingPiece

var cur_map
var spawn_target

func _ready():
	var pksc_player = load(fp_player)
	player = pksc_player.instantiate()
	add_child(player)

func goto_map():
	get_node("/root/Game/Grid").remove_child(player)
	add_child(player)
	
	get_tree().change_scene_to_file(interracting_with.target_map)
