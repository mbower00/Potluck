extends 'interactable_static.gd'

# [EMPTY] cauldron_liquid pos y: -1.1
# [FULL] cauldron_liquid pos y: 0

var STIR_LIQUIDS = -0.187
var FULL_LIQUIDS = 0.373
var HALF_lIQUIDS = -0.199
var EMPTY_lIQUIDS = -0.766

# Called when the node enters the scene tree for the first time.
func _ready():
	item_type = "empty_cauldron"
	
	# Hide all types
	for i in $CauldronMesh/Liquids.get_children():
		i.hide()
	
	change_type("blue")
	
	set_level('empty')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_player_detected():
	return 'b'
	
func before_occupy():
	set_level('stir')

func set_level(level):
	match level:
		'stir':
			item_type = "stir_cauldron"
			$CauldronMesh/Liquids.position = Vector3(0, STIR_LIQUIDS, 0)
		'full':
			item_type = "full_cauldron"
			$CauldronMesh/Liquids.position = Vector3(0, FULL_LIQUIDS, 0)
		'half':
			item_type = "half_cauldron"
			$CauldronMesh/Liquids.position = Vector3(0, HALF_lIQUIDS, 0)
		'empty':
			item_type = "empty_cauldron"
			$CauldronMesh/Liquids.position = Vector3(0, EMPTY_lIQUIDS, 0)
		_:
			item_type = "empty_cauldron"
			$CauldronMesh/Liquids.position = Vector3(0, EMPTY_lIQUIDS, 0)
			
func interact():
	print('hello from cauldron!!')

var liquid_type = "blue"

func change_type(new_liquid_type):
	get_node("CauldronMesh/Liquids/%s" % liquid_type).hide()
	get_node("CauldronMesh/Liquids/%s" % new_liquid_type).show()
	liquid_type = new_liquid_type	
