extends Node

@export var potion_scene: PackedScene
@export var orange_spell_scene: PackedScene
@export var yellow_spell_scene: PackedScene
@export var buff_spell_scene: PackedScene

var difficulty_score = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player_0/Arrow.change_color('blue')
	$Player_1/Arrow.change_color('red')
	$Player_2/Arrow.change_color('green')
	$Player_3/Arrow.change_color('yellow')
	var joypads = Input.get_connected_joypads()
	for i in [0,1,2,3]:
		if joypads.find(i) == -1:
			get_node('Player_%s' % i).free()
			difficulty_score -= 1

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
			pass
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
