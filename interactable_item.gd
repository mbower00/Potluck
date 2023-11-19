extends RigidBody3D

var is_occupied = false
var is_item = false

func occupy():
	is_occupied = true
	
func unoccupy():
	is_occupied = false
