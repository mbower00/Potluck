extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var joypads = Input.get_connected_joypads()
	for i in [0,1,2,3]:
		if joypads.find(i) == -1:
			get_node('Player_%s' % i).free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
