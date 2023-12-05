extends Node3D

var color = 'blue'

func change_color(new_color):
	for i in get_children():
		i.hide()
	get_node('%s_arrow' % new_color).show()

# Called when the node enters the scene tree for the first time.
func _ready():
	change_color('blue')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
