extends 'interactable_static.gd'

# [EMPTY] cauldron_liquid pos y: -1.1
# [FULL] cauldron_liquid pos y: 0

func interact():
	print('hello from cauldron!!')

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_player_detected():
	return 'b'
