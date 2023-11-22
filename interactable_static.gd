extends StaticBody3D

var is_occupied = false
var is_item = false
var item_type = ""

func occupy():
	is_occupied = true
	$AnimationPlayer.play("occupied")

func unoccupy():
	is_occupied = false
	$AnimationPlayer.stop()
