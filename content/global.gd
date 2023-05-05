extends Node

const fp_player = "res://content/overworld/playing_pieces/list/alice.tscn"

var player
var cur_map
var spawn_target

func _ready():
	var pksc_player = load(fp_player)
	player = pksc_player.instantiate()
	add_child(player)
