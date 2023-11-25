extends RigidBody3D

var is_occupied = false
var is_item = true
var item_type = ""
var hand = null

func occupy(to_hand):
	look_at(Vector3.FORWARD)
	is_occupied = true
	hand = to_hand
	
func unoccupy():
	is_occupied = false
	hand = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hand != null:
		global_position = hand.global_position
