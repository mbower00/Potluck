extends 'interactable_static.gd'

# [EMPTY] cauldron_liquid pos y: -1.1
# [FULL] cauldron_liquid pos y: 0

# [STIR] lIQUIDS = .031

func interact():
	print('hello from cauldron!!')

var liquid_type = "blue"

func change_type(new_liquid_type):
	get_node("CauldronMesh/Liquids/%s" % liquid_type).hide()
	get_node("CauldronMesh/Liquids/%s" % new_liquid_type).show()
	liquid_type = new_liquid_type	


# Called when the node enters the scene tree for the first time.
func _ready():
	# Hide all types
	for i in $CauldronMesh/Liquids.get_children():
		i.hide()
		
	change_type("blue")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_player_detected():
	return 'b'
