extends Node

@export var potion_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	var joypads = Input.get_connected_joypads()
	for i in [0,1,2,3]:
		if joypads.find(i) == -1:
			get_node('Player_%s' % i).free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_0_bottle_crafted():
	var bottle = potion_scene.instantiate()
	bottle.position = $Player_0/Hand.position
	add_child(bottle)
	$Player_0.give(bottle)

func _on_player_1_bottle_crafted():
	var bottle = potion_scene.instantiate()
	bottle.position = $Player_0/Hand.position
	add_child(bottle)
	$Player_1.give(bottle)

func _on_player_2_bottle_crafted():
	var bottle = potion_scene.instantiate()
	bottle.position = $Player_0/Hand.position
	add_child(bottle)
	$Player_2.give(bottle)

func _on_player_3_bottle_crafted():
	var bottle = potion_scene.instantiate()
	bottle.position = $Player_0/Hand.position
	add_child(bottle)
	$Player_3.give(bottle)
