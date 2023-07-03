@tool
@icon("playing_piece.svg")
extends Sprite2D
class_name PlayingPiece

signal moved(node, position)
signal move_tween_finished(new_mapos)

enum Triggers {
	ACTION_BY_SIDE,
	NONE,
	STEPPED_ON,
	ACTION_ON_SPOT,
	ABOUT_TO_WALK_IN,
}

const PLAYBACK_ACTION := "parameters/Actions/playback"

var walking_in_progress: bool

## The timeline to be played when interracted
@export_file("*.dtl") var timeline: String

## How the piece is to be interracted
@export var trigger: Triggers

@export_category("Expansion")

## Checks whether this piece can block path
@export var blocks_path: bool = true

## Measures how much more space does this piece cover.
@export var expands: Vector2

## Checks whether property Expands applies to the opposite side, too.
@export var symmetrically: bool = true

@export_category("Visual")

## Makes this piece invivisble when played.
@export var hide_on_play: bool

func _ready():
	if hide_on_play and not Engine.is_editor_hint():
		hide()


func _notification(what):
	match what:
		NOTIFICATION_NODE_RECACHE_REQUESTED:
			moved.emit(self, get_position())


func move_piece(v2i: Vector2i, custom_track := "act_walking"):
	var map_pos = get_parent().local_to_map(get_position())
	var target_mapos = map_pos + v2i
	
	if not is_blocked(target_mapos):
		var final_pos = get_parent().map_to_local(target_mapos)
		
		get_parent().update_map_pos(self, map_pos, target_mapos)
	
		var tween = create_tween()
		var anim = $AnimationPlayer.get_animation(custom_track)
		var move_duration = anim.get_length()
		
		tween.tween_property(self, "position", final_pos, move_duration)
		walking_in_progress = true
		
		tween.tween_callback(func():
			$AnimationTree[PLAYBACK_ACTION].travel("act_idle")
			walking_in_progress = false
			move_tween_finished.emit(target_mapos)
		)


func is_blocked(map_pos)-> bool:
	return is_blocked_by_playing_piece(map_pos) or is_blocked_by_terrain(map_pos)


func is_blocked_by_playing_piece(map_pos):
	var dict_playpieces = get_parent().children_by_mapos
	
	if map_pos in dict_playpieces:
		for playing_piece in dict_playpieces[map_pos]:
			if playing_piece.blocks_path:
				return true
	
	return false


func is_blocked_by_terrain(map_pos)-> bool:
	var tiledata = get_parent().get_cell_tile_data(1, map_pos)
	if tiledata:
		return tiledata.get_terrain_set() != 0
	else:
		return false


func spawn_new_piece(playing_piece):
	playing_piece.set_position(get_position())
	add_sibling(playing_piece)
