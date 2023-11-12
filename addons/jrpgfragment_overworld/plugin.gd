@tool
extends EditorPlugin

var new_tools: Array[Control]

var nearest_game_board: GameBoard

func _enter_tree():
	# Define new buttons
	#	Prop Piece
	var prop_piece_btn = generate_toolbtn()
	new_tools.append(prop_piece_btn)
	
	#	Walking Piece
	var walk_piece_btn = generate_toolbtn()
	new_tools.append(walk_piece_btn)
	
	#	Warping
	var warp_piece_btn = generate_toolbtn()
	new_tools.append(warp_piece_btn)
	
	#	Seperating Line
	new_tools.append(VSeparator.new)
	
	# Add new buttons to toolbar
	for nd in new_tools:
		add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, nd)
	
	# On changing scenes
	scene_changed.connect(func(scene_root):
		nearest_game_board = null
		show_or_hide_new_toolbtns(scene_root)
	)


func _exit_tree():
	for nd in new_tools:
		remove_control_from_container(CONTAINER_CANVAS_EDITOR_MENU, nd)
		nd.queue_free()


func generate_toolbtn()-> Button:
	var btn = Button.new()
	btn.set_flat(true)
	return btn


func node_is_gameboard(node)-> bool:
	if node is GameBoard:
		nearest_game_board = node
		return true
	else:
		for n in node.get_children():
			if node_is_gameboard(n):
				return true
	
	return false


## Sets the visibility of the new tool buttons
## to [param true] or [param false], depending
## on whether the scene contains [GameBoard].
func show_or_hide_new_toolbtns(scene_root):
	var visibility = node_is_gameboard(scene_root)
	
	for nd in new_tools:
		nd.set_visible(visibility)
