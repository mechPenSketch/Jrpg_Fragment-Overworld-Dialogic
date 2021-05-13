tool
extends GridContainer

const BTN_WIDTH = 32
const PARENT_MARGIN = 23

func _ready():
	_on_dock_resized()

func _on_dock_resized():
	var new_width = int(find_parent("Actions").get_size().x)
	new_width -= PARENT_MARGIN * 2
	var hseparation = get("custom_constants/hseparation")
	new_width += hseparation
	var btn_width_w_hsep = BTN_WIDTH + hseparation
	var final_column = new_width / btn_width_w_hsep
	
	# IF THERE'S ENOUGH LEFTOVER SPACE TO FIT A BUTTON
	if new_width % btn_width_w_hsep >= BTN_WIDTH:
		# ADD ONE MORE COLUMN
		final_column += 1
	
	# THERE SHOULD BE AT LEAST ONE COLUMN
	if final_column <= 1:
		final_column = 1
	
	set_columns(final_column)
