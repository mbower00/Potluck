extends 'interactable_static.gd'


# Called when the node enters the scene tree for the first time.
func _ready():
	item_type = "table"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_player_detected():
	return 'x'
