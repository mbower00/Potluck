extends CharacterBody3D

@export var speed = 5
@export var joypad_num = 0

var occupied_object = null
var focused_object = null
var on_occupy = "empty_func"
var on_action_pipe_complete = "empty_func"
var action_pipe = []

signal bottle_crafted

########################### CONNECTIONS AND OVERRIDES ##########################

func _physics_process(_delta):
	var direction = Vector3.ZERO
	var new_velocity = Vector3.ZERO
	
	if Input.is_action_just_pressed("a_%s" % joypad_num): #A
		if len(action_pipe) > 0 and action_pipe[0] == 'a':
			progress_pipe()
		# Occupy the interactable
		elif focused_object != null and action_pipe == []:
			$ButtonIndicator.hide_buttons()
			call(on_occupy)
			occupied_object = focused_object
			if focused_object.is_item:
				# TODO: player should drop item before holding a new one
				focused_object.occupy($Hand)
			elif on_occupy == 'burn_action':
				focused_object = null
				pass
			else:
				focused_object.occupy()
			focused_object = null

	if Input.is_action_just_pressed("b_%s" % joypad_num): #B
		if len(action_pipe) > 0 and action_pipe[0] == 'b':
			progress_pipe()
		# Unoccupy the interactable
		elif action_pipe == [] and occupied_object != null and occupied_object.is_item:
			occupied_object.unoccupy()
			occupied_object = null

	if Input.is_action_just_pressed("x_%s" % joypad_num): #X
		if len(action_pipe) > 0 and action_pipe[0] == 'x':
			progress_pipe()
		print('OCCUPIED ', occupied_object)
		print('FOCUS ', focused_object, '\n')

	if Input.is_action_just_pressed("y_%s" % joypad_num): #Y
		if len(action_pipe) > 0 and action_pipe[0] == 'y':
			progress_pipe()

	
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
	if !body.is_occupied and action_pipe == []:
		handle_focus(body)

func _on_detector_body_exited(body):
	if body == occupied_object:
		unoccupy(body)
	if body == focused_object:
		focused_object = null
	$ButtonIndicator.hide_buttons()
	action_pipe = []

#################################### HELPERS ###################################

func occupy(body):
	occupied_object = body
	body.occupy()

func unoccupy(body):
	occupied_object = null
	body.unoccupy()

func focus(body, occupy_action = 'empty_func'):
	$ButtonIndicator.show_button('a')
	on_occupy = occupy_action
	focused_object = body

func empty_func():
	pass
	
func set_pipe(new_pipe):
	# sets action_pipe to new_pipe
	# updates the ButtonIndicator
	if len(action_pipe) > 0:
		print('Warning: replacing a non-empty action_pipe')
	action_pipe = new_pipe
	$ButtonIndicator.show_button(action_pipe[0])

func give(item):
	# gives this player the item
	item.occupy($Hand)
	occupied_object = item
	item.look_at(Vector3(0,1,0))

func progress_pipe():
	# Progress the action_pipe by getting rid of the first item
	# ButtonIndicator will be updated as appropriate
	# WHEN THE PIPE IS COMPLETE
	# 	on_action_pipe_complete will be called
	# 	occupied_object is unoccupied
	# RETURNS
	# 	true - action pipe now complete
	# 	false - action pipe still not complete
	action_pipe.remove_at(0)
	if action_pipe != []:
		$ButtonIndicator.show_button(action_pipe[0])
		return false
	else:
		unoccupy(occupied_object)
		$ButtonIndicator.hide_buttons()
		call(on_action_pipe_complete)
		return true

################################## ACTIONS #####################################

func burn_action():
	# FOCUSED: GlassBlowingSet
	# OCCUPIED: an item
	focused_object.burn_item()
	var item = occupied_object
	unoccupy(item)
	item.free()
	
func craft_bottle_action():
	# FOCUSED: GlassBlowingSet
	# OCCUPIED: null
	set_pipe(['b','a','b','a','b','a','b','a','b','a','b'])
	on_action_pipe_complete = 'craft_bottle_complete'

################################## COMPLETIONS #################################

func craft_bottle_complete():
	bottle_crafted.emit()

################################### HANDLERS ###################################

func handle_focus(body):
		if occupied_object != null:
			# SOMETHING HELD
			match body.item_type:
				# CAULDRON
				'full_cauldron':
					if occupied_object.item_type == 'bottle':
						focus(body)
				'half_cauldron':
					if occupied_object.item_type == 'bottle':
						focus(body)
				'empty_cauldron':
					if occupied_object.item_type == 'chopped_ingredient':
						focus(body)
				'stir_cauldron':
					print("Unintended behavior: Attempt to occupy stir_cauldron")
				# GLASS BLOWING SET
				'glass_blowing_set':
					# BURN Focus
					# TODO: breaking when you hit 'a' after dropping an item when burn was expected
					focus(body, 'burn_action')
				# TABLE
				'table':
					if occupied_object.item_type == 'raw_ingredient':
						focus(body)
				_:
					if body.is_item:
						focus(body)
		else:
			# NOTHING HELD
			match body.item_type:
				# GLASS BLOWING SET
				'glass_blowing_set':
					# CRAFT BOTTLE Focus
					focus(body, 'craft_bottle_action')
				_:
					if body.is_item:
						focus(body)
