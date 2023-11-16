extends CharacterBody3D

@export var speed = 5

@export var joypad_num = 0

func _physics_process(_delta):
	var direction = Vector3.ZERO
	var new_velocity = Vector3.ZERO
	
	if Input.is_action_pressed("a_%s" % joypad_num):
		$ButtonIndicator.show_button('a')
	if Input.is_action_pressed("b_%s" % joypad_num):
		$ButtonIndicator.show_button('b')
	if Input.is_action_pressed("x_%s" % joypad_num):
		$ButtonIndicator.show_button('x')
	if Input.is_action_pressed("y_%s" % joypad_num):
		$ButtonIndicator.show_button('y')
	
	if Input.is_action_pressed("move_north_%s" % joypad_num):
		direction.z -= Input.get_action_strength("move_north_%s" % joypad_num)
	if Input.is_action_pressed("move_south_%s" % joypad_num):
		direction.z += Input.get_action_strength("move_south_%s" % joypad_num)
	if Input.is_action_pressed("move_east_%s" % joypad_num):
		direction.x += Input.get_action_strength("move_east_%s" % joypad_num)
	if Input.is_action_pressed("move_west_%s" % joypad_num):
		direction.x -= Input.get_action_strength("move_west_%s" % joypad_num)
		"""
	if Input.is_action_pressed("move_north_%s" % joypad_num) or Input.is_action_pressed("move_south_%s" % joypad_num) or Input.is_action_pressed("move_east_%s" % joypad_num) or Input.is_action_pressed("move_west_%s" % joypad_num):
		print("ACTION STRENGTH %s" % Input.get_action_strength("move_north_%s" % joypad_num))
		var z_axis = Input.get_axis("move_south_%s" % joypad_num, "move_north_%s" % joypad_num)
		var z_true_axis = Input.get_action_strength("move_north_%s" % joypad_num)
		var x_axis = Input.get_axis("move_west_%s" % joypad_num, "move_east_%s" % joypad_num)
		var zx_axis = Input.get_axis("move_north_%s" % joypad_num, "move_east_%s" % joypad_num)
		
		print("AXIS Z %s" % z_axis)
		print("AXIS Z TRUE %s" % z_true_axis)
		print("AXIS X %s" % x_axis)
		print("AXIS ZX %s" % zx_axis)
		print(get_rotation().y)
		rotate_y(.01)
		"""
	if direction != Vector3.ZERO:
		look_at(position + direction, Vector3.UP)
	new_velocity.x = direction.x * speed
	new_velocity.z = direction.z * speed
	velocity = new_velocity
	move_and_slide()
