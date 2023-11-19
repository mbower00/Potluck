extends CharacterBody3D

@export var speed = 5

@export var joypad_num = 0

var occupied_object = null
var focused_object = null

func _physics_process(_delta):
	var direction = Vector3.ZERO
	var new_velocity = Vector3.ZERO
	
	if Input.is_action_just_pressed("a_%s" % joypad_num):
		# Occupy the interactable
		if focused_object != null:
			focused_object.occupy()
			occupied_object = focused_object
			focused_object = null

	if Input.is_action_just_pressed("b_%s" % joypad_num):
		print('OCCUPIED ', occupied_object)
		print('FOCUS ', focused_object, '\n')

	if Input.is_action_just_pressed("x_%s" % joypad_num):
		pass

	if Input.is_action_just_pressed("y_%s" % joypad_num):
		pass

	
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
	if !body.is_occupied:
		$ButtonIndicator.show_button('a')
		focused_object = body


func _on_detector_body_exited(body):
	if body == occupied_object:
		occupied_object = null
		body.unoccupy()
		$ButtonIndicator.hide_buttons()
	if body == focused_object:
		focused_object = null
		$ButtonIndicator.hide_buttons()
