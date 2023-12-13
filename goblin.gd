# Some of below code from Squash the Creeps 3D tutorial...
extends CharacterBody3D

var health = 100
var speed = 5
var rotation_freq = .05 #in seconds
var rotation_timer = 0
var target_player = null

func _ready():
	#print(get_players_and_distances())
	on_ready() # hook
	configure_velocity() 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	on_process() # hook
	rotation_timer += delta
	if rotation_timer > rotation_freq:
		rotation_timer = 0
		look_at(
			get_target_player_position()
		)
		configure_velocity()
	move_and_slide()

func level_up(health_up, speed_up):
	health += health_up
	speed += speed_up

func on_ready(): # hook
	pass

func on_process(): # hook
	pass

func damage(amount):
	health -= amount
	$AnimationPlayerHIT.play('hit')
	if health <= 0:
		queue_free()

func configure_velocity():
	velocity = (Vector3.FORWARD * speed).rotated(Vector3.UP, rotation.y)

func get_target_player_position():
	var closest_player = null
	var closest_player_distance = null
	var should_update
	for i in get_tree().get_nodes_in_group('players'):
		var distance_to_i = global_position.distance_to(i.global_position)
		if closest_player_distance == null or distance_to_i < closest_player_distance:
			closest_player_distance = distance_to_i
			closest_player = i
	#if closest_player == null:
	#	return 
	if closest_player == null:
		return Vector3(0,0,500)
	return closest_player.global_position

func get_players_and_distances():
	## returns sorted by DISTANCE: 
	##   [[PLAYER, DISTANCE], [PLAYER, DISTANCE] ...]
	var player_distances = []
	for i in get_tree().get_nodes_in_group('players'):
		player_distances.append(
				[i, global_position.distance_to(i.global_position)]
			)
	player_distances.sort_custom(sort_by_distance)
	return player_distances
	
# Callback function
func sort_by_distance(one, two):
	if one[1] < two[1]:
		return true
	else:
		return false
