extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var joypads = Input.get_connected_joypads()
	for i in joypads:
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
