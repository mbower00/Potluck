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
	if direction != Vector3.ZERO:
		look_at(position + direction, Vector3.UP)
	new_velocity.x = direction.x * speed
	new_velocity.z = direction.z * speed
	velocity = new_velocity
	move_and_slide()


func _on_detector_body_entered(body):
	var response = body.on_player_detected()
	$ButtonIndicator.show_button(response)
