extends CharacterBody3D

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_north") or Input.is_action_pressed("move_south") or Input.is_action_pressed("move_east") or Input.is_action_pressed("move_west"):
		print("ACTION STRENGTH %s" % Input.get_action_strength("move_north"))
		var z_axis = Input.get_axis("move_south", "move_north")
		var x_axis = Input.get_axis("move_west", "move_east")
		var zx_axis = Input.get_axis("move_north", "move_east")
		
		print("AXIS Z %s" % z_axis)
		print("AXIS X %s" % x_axis)
		print("AXIS ZX %s" % zx_axis)
		
		rotate_y(z_axis)
