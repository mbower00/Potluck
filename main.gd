extends Node

@export var potion_scene: PackedScene
@export var orange_spell_scene: PackedScene
@export var yellow_spell_scene: PackedScene
@export var red_spell_scene: PackedScene
@export var buff_spell_scene: PackedScene
@export var goblin_fighter_scene: PackedScene
@export var goblin_rouge_scene: PackedScene
@export var goblin_heavy_scene: PackedScene
@export var goblin_wizard_scene: PackedScene
@export var ingredient_scene: PackedScene

var foe_speed_up = 0
var foe_health_up = 0
var foe_speed_up_mod = .1
var foe_health_up_mod = 10

var dead = 0
var difficulty_score = 4

var sec = 0
# goal in minutes
var goal = 10
var current_min = goal - 1
var spawn_time

var spawn_pool = [
	'fighter',
	'fighter',
	'fighter',
	'rouge',
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$UI/WinLabel.hide()
	$UI/WinLabel2.hide()
	$UI/LoseLabel.hide()
	$UI/LoseLabel2.hide()
	spawn_time = $GoblinTimer.wait_time 
	$Player_0/Arrow.change_color('blue')
	$Player_1/Arrow.change_color('red')
	$Player_2/Arrow.change_color('green')
	$Player_3/Arrow.change_color('yellow')
	var joypads = Input.get_connected_joypads()
	if joypads.find(0) == -1:
		joypads.append(0)
	#print(joypads)
	for i in [0,1,2,3]:
		var player_node = get_node('Player_%s' % i)
		var lives_node = get_node('UI/lives_%s' % i)
		if joypads.find(i) == -1:
			player_node.free()
			lives_node.free()
			difficulty_score -= 1
		else:
			player_node.add_to_group("players")
	for i in range(difficulty_score):
		spawn_ingredient()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_0_bottle_crafted():
	craft_bottle($Player_0, $Player_0/Hand)
func _on_player_1_bottle_crafted():
	craft_bottle($Player_1, $Player_1/Hand)
func _on_player_2_bottle_crafted():
	craft_bottle($Player_2, $Player_2/Hand)
func _on_player_3_bottle_crafted():
	craft_bottle($Player_3, $Player_3/Hand)

func _on_player_0_potion_used(potion_color):
	use_potion(potion_color, $Player_0)
func _on_player_1_potion_used(potion_color):
	use_potion(potion_color, $Player_1)
func _on_player_2_potion_used(potion_color):
	use_potion(potion_color, $Player_2)
func _on_player_3_potion_used(potion_color):
	use_potion(potion_color, $Player_3)
	
func craft_bottle(player, hand):
	var bottle = potion_scene.instantiate()
	bottle.position = hand.position
	add_child(bottle)
	player.give(bottle)

func use_potion(potion_color, player):
	var spell = null
	var spell_pos = player.global_position
	
	match potion_color:
		'red':
			spell = red_spell_scene.instantiate()
			spell_pos = player.get_child(0).global_position
		'orange':
			#print(potion_color, player)
			spell = orange_spell_scene.instantiate()
			spell_pos.y += 1.5
		'yellow':
			spell = yellow_spell_scene.instantiate()
		'green':
			spell = buff_spell_scene.instantiate()
			spell.change_type('green')
		'blue':
			spell = buff_spell_scene.instantiate()
			spell.change_type('blue')
		'purple':
			spell = buff_spell_scene.instantiate()
			spell.change_type('purple')

	spell.global_position = spell_pos
	add_child(spell)
	spell.set_host_player(player)


func _on_player_0_lose_life():
	lose_life($UI/lives_0)
func _on_player_1_lose_life():
	lose_life($UI/lives_1)
func _on_player_2_lose_life():
	lose_life($UI/lives_2)
func _on_player_3_lose_life():
	lose_life($UI/lives_3)

func lose_life(tag):
	tag.text = tag.text.erase(0)

func _on_timer_timeout():
	sec += 1
	var display_sec = 60 - (sec % 60)
	if display_sec == 60:
		display_sec = 0
	var display_min = goal - (floor(sec / 60) + 1)
	if display_min < current_min:
		current_min = display_min
		spawn_time = spawn_time - ((1 + difficulty_score) / 2)
		$GoblinTimer.wait_time = spawn_time
		spawn_pool.append('rouge')
		spawn_pool.append('heavy')
		spawn_pool.append('wizard')
		foe_speed_up += foe_speed_up_mod
		foe_health_up += foe_health_up_mod
	var str_sec = '%s' % display_sec
	var str_min = '%s' % display_min
	if len(str_sec) == 1:
		str_sec = "0" + str_sec
	$UI/TimerLabel.text = str_min + ":" + str_sec
	if $UI/TimerLabel.text == "0:00":
		$UI/WinLabel.show()
		$UI/WinLabel2.show()
	

func _on_goblin_timer_timeout():
	for i in range(1 + difficulty_score):
		spawn_goblin()

func spawn_goblin():
	var goblin_spawn_str = spawn_pool[randi() % len(spawn_pool)]
	var goblin_spawn_scene
	match goblin_spawn_str:
		'fighter':
			goblin_spawn_scene = goblin_fighter_scene
		'rouge':
			goblin_spawn_scene = goblin_rouge_scene
		'heavy':
			goblin_spawn_scene = goblin_heavy_scene
		'wizard':
			goblin_spawn_scene = goblin_wizard_scene
	$Path3D/PathFollow3D.progress_ratio = randf()
	var goblin_spawn = goblin_spawn_scene.instantiate()
	goblin_spawn.level_up(foe_health_up, foe_speed_up)
	goblin_spawn.global_position = $Path3D/PathFollow3D.global_position
	add_child(goblin_spawn)


"""
match display_min:
			9:
				spawn_pool.append('rouge')
				spawn_pool.append('heavy')
				spawn_pool.append('wizard')
			8:
				spawn_pool.append('rouge')
				spawn_pool.append('heavy')
				spawn_pool.append('wizard')
			7:
				spawn_pool.append('rouge')
				spawn_pool.append('heavy')
				spawn_pool.append('wizard')
			6:
				spawn_pool.append('rouge')
				spawn_pool.append('heavy')
				spawn_pool.append('wizard')
			5:
				spawn_pool.append('rouge')
				spawn_pool.append('heavy')
				spawn_pool.append('wizard')
			4:
				spawn_pool.append('rouge')
				spawn_pool.append('heavy')
				spawn_pool.append('wizard')
			3:
				spawn_pool.append('rouge')
				spawn_pool.append('heavy')
				spawn_pool.append('wizard')
			2:
				spawn_pool.append('rouge')
				spawn_pool.append('heavy')
				spawn_pool.append('wizard')
			1:
				spawn_pool.append('rouge')
				spawn_pool.append('heavy')
				spawn_pool.append('wizard')
"""


func _on_ingredient_timer_timeout():
	#var amount = ( randi() % difficulty_score ) + 1
	#for i in range(amount):
	spawn_ingredient()

func spawn_ingredient():
	var rand = ( randi() % 100 ) + 1
	var ingredient_spawn_pool
	if rand >= 95:
		ingredient_spawn_pool = ['purple']
	elif rand >= 85:
		ingredient_spawn_pool = ['blue', 'green']
	elif rand >= 55:
		ingredient_spawn_pool = ['yellow']
	else:
		ingredient_spawn_pool = ['red', 'orange']
	
	var ingredient_spawn_str = ingredient_spawn_pool[randi() % len(ingredient_spawn_pool)]
	var new_ingredient = ingredient_scene.instantiate()
	
	$DropPath3D/PathFollow3D.progress_ratio = randf()
	new_ingredient.global_position = $DropPath3D/PathFollow3D.global_position
	
	new_ingredient.change_type(ingredient_spawn_str)
	
	add_child(new_ingredient)


func _on_player_0_died():
	tick_dead()
func _on_player_1_died():
	tick_dead()
func _on_player_2_died():
	tick_dead()
func _on_player_3_died():
	tick_dead()
	
func tick_dead():
	dead += 1
	if dead == difficulty_score:
		#Game over: lose
		$UI/LoseLabel.show()
		$UI/LoseLabel2.show()
		$Timer.stop()
