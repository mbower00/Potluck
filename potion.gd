extends 'interactable_item.gd'
@export var type = "empty"

func change_type(new_type):
	get_node("CollisionShape3D/Types/%s" % type).hide()
	get_node("CollisionShape3D/Types/%s" % new_type).show()
	type = new_type
	if type == "empty":
		item_type = "bottle"
	else:
		item_type = "potion"

# Called when the node enters the scene tree for the first time.
func _ready():
	item_type = "bottle"
	# Hide all types
	for i in $CollisionShape3D/Types.get_children():
		i.hide()
		
	change_type(type)


func on_player_detected():
	return 'a'
