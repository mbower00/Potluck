extends StaticBody3D

var is_occupied = false
var is_item = false
var item_type = ""
func before_occupy():
	pass
func before_unoccupy():
	pass

func occupy():
	before_occupy()
	is_occupied = true
	$AnimationPlayer.play("occupied")

func unoccupy():
	before_unoccupy()
	is_occupied = false
	$AnimationPlayer.stop()
