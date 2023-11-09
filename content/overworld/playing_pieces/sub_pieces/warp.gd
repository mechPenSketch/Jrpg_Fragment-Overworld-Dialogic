@tool
extends PlayingPiece

## For the player to walk into to change
## the game map scene.

## The game map to be warpped to.
@export_file("*.tscn") var target_map: String

## The index of the child of the game map.
## Upon entering the game map, the position of
## the player is set to the child's.
@export var target_child_index: int
