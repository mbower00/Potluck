extends CharacterBody3D

@export var joypad_num = 0

# Buffables
@export var speed = 5
@export var action_complexity_reduction = 0
@export var attack_duration_addition = 0

var occupied_object = null
var prev_occupied = null
var focused_object = null
var completed_occupied_station = null
var on_occupy = "empty_func"
var on_action_pipe_complete = "empty_func"
var action_pipe = []
var may_move = true
var may_rotate = true
var is_targeting = false

signal bottle_crafted
signal potion_used(potion_color)

var action_sets = {
	'craft_bottle': ['b','a'],
	'chop_ingredient': ['x','a'],
	# C Tier
	'red': ['b','x'], # Fire Attack
	'orange': ['b','y'], # Beam Attack
	# B Tier
	'yellow': ['a', 'b', 'x', 'y'], # Area Attack
	# A Tier
	'blue': ['a', 'a', 'b', 'x', 'x', 'y'], # Decrease Action Complexity
	'green': ['a', 'b', 'b', 'x', 'y', 'y'], # Increse Movement Speed and Heal(?)
	# S  Tier
	'purple': ['a', 'b', 'x', 'y', 'a', 'b', 'x', 'y'], # Increase Attack Duration
}

########################### CONNECTIONS AND OVERRIDES ##########################

func _ready():
	$Arrow.hide()

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
			prev_occupied = occupied_object
			occupied_object = focused_object
			if focused_object.is_item:
				# TODO: player should drop item before holding a new one
				focused_object.occupy($Hand)
			elif on_occupy == 'burn_action':
				pass
			elif on_occupy == 'fill_bottle_action':
				occupied_object = prev_occupied
			else:
				focused_object.occupy()
			focused_object = null

	if Input.is_action_just_pressed("b_%s" % joypad_num): #B
		if len(action_pipe) > 0 and action_pipe[0] == 'b':
			progress_pipe()
		# Unoccupy the interactable
		elif action_pipe == [] and occupied_object != null:
			occupied_object.unoccupy()
			occupied_object = null

	if Input.is_action_just_pressed("x_%s" % joypad_num): #X
		if len(action_pipe) > 0 and action_pipe[0] == 'x':
			progress_pipe()
		if len(action_pipe) == 0 and occupied_object != null and occupied_object.is_item and occupied_object.item_type == 'potion':
			may_move = false
			is_targeting = true
			$Arrow.show()
		print('OCCUPIED ', occupied_object)
		print('FOCUS ', focused_object, '\n')

	if Input.is_action_just_released('x_%s' % joypad_num): #X RELEASE
		if is_targeting:
			may_move = true
			$Arrow.hide()
			is_targeting = false
			use_potion(occupied_object)

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
	if direction != Vector3.ZERO and may_rotate:
		look_at(position + direction, Vector3.UP)
	if may_move:
		new_velocity.x = direction.x * speed
		new_velocity.z = direction.z * speed
		velocity = new_velocity
	else:
		velocity = Vector3(0,0,0)
	move_and_slide()

func _on_detector_body_entered(body):
	if !body.is_occupied and action_pipe == []:
		handle_focus(body)

func _on_detector_body_exited(body):
	if body == occupied_object:
		unoccupy(body)
		occupied_object = prev_occupied
		if prev_occupied:
			occupied_object.occupy($Hand)
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
		completed_occupied_station = occupied_object
		unoccupy(occupied_object)
		$ButtonIndicator.hide_buttons()
		call(on_action_pipe_complete)
		completed_occupied_station = null
		return true

func get_action_set(key, shuffle = false, difficulty = get_parent().difficulty_score):
	var set = []
	var repeats = 2 + difficulty
	action_sets
	for i in range(repeats):
		set.append_array(action_sets[key])
	if shuffle:
		set.shuffle()
	# remove one action / action_complexity_reduction (cannot fall bellow 1)
	for i in range(action_complexity_reduction):
		if len(set) > 1:
			set.remove_at(0)
	return set
	
func lower_cauldron_level(cauldron):
	if cauldron.item_type == 'full_cauldron':
		cauldron.set_level('half')
	elif cauldron.item_type == 'half_cauldron':
		cauldron.set_level('empty')
		
func use_potion(potion):
	potion_used.emit(potion.type)
	unoccupy(potion)
	potion.free()

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
	set_pipe(get_action_set('craft_bottle'))
	on_action_pipe_complete = 'craft_bottle_complete'

func chop_ingredient_action():
	# FOCUSED: table
	# OCCUPIED: a raw ingredient
	set_pipe(get_action_set('chop_ingredient'))
	on_action_pipe_complete = 'chop_ingredient_complete'

func mix_potion_action():
	# FOCUSED: cauldron
	# OCCUPIED: a chopped ingredient
	set_pipe(get_action_set(occupied_object.color, true))
	focused_object.change_type(occupied_object.color)
	on_action_pipe_complete = 'mix_potion_complete'

func fill_bottle_action():
	# FOCUSED: cauldron w/ brewed potion
	# OCCUPIED: bottle
	lower_cauldron_level(focused_object)
	occupied_object.change_type(focused_object.liquid_type)

################################## COMPLETIONS #################################

func craft_bottle_complete():
	bottle_crafted.emit()
	
func chop_ingredient_complete():
	occupied_object = prev_occupied
	occupied_object.occupy($Hand)
	occupied_object.chop()
	
func mix_potion_complete():
	completed_occupied_station.set_level('full')
	prev_occupied.free()
	prev_occupied = null

################################### HANDLERS ###################################

func handle_focus(body):
		if occupied_object != null:
			# SOMETHING HELD
			match body.item_type:
				# CAULDRON
				'full_cauldron':
					if occupied_object.item_type == 'bottle':
						focus(body, 'fill_bottle_action')
				'half_cauldron':
					if occupied_object.item_type == 'bottle':
						focus(body, 'fill_bottle_action')
				'empty_cauldron':
					if occupied_object.item_type == 'chopped':
						focus(body, 'mix_potion_action')
				'stir_cauldron':
					print("Unintended behavior: Attempt to occupy stir_cauldron")
				# GLASS BLOWING SET
				'glass_blowing_set':
					# BURN Focus
					# TODO: breaking when you hit 'a' after dropping an item when burn was expected
					focus(body, 'burn_action')
				# TABLE
				'table':
					if occupied_object.item_type == 'raw':
						focus(body, 'chop_ingredient_action')
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
