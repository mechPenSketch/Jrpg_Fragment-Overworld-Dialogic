tool
extends Button

export(String, FILE, "*.tscn") var choice_filepath
var choice_file

func _ready():
	choice_file = load(choice_filepath)

func _on_connecting_editor_plugin(ep, d):
	# INPUT: EDITOR PLUGIN, DICTIONARY OF AN ACTION
	connect("pressed", ep, "_on_acbtn_pressed", [self, choice_file])
	
	if d.has("choices"):
		for i in d["choices"].size():
			var choice = choice_file.instance()
			get_parent().add_child(choice)
			choice.mass_connect(ep, d["choices"][i])
			choice.set_index(i)
			get_parent().move_child(choice, get_index())
