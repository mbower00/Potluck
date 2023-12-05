extends Node3D

var type = 'green'
var host_player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in $Types.get_children():
		i.hide()
	get_node('Types/%s' % type).show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if host_player:
		var pos = host_player.global_position
		global_position = pos
		
func set_host_player(player):
	host_player = player
	match type:
		'green':
			host_player.speed += .5
			# TODO: Consider healing here
		'blue':
			host_player.action_complexity_reduction += 1
		'purple':
			host_player.attack_duration_addition += .5
	$Timer.start()

func change_type(new_type):
	get_node('Types/%s' % type).hide()
	get_node('Types/%s' % new_type).show()
	type = new_type

func _on_timer_timeout():
	print(host_player.speed, host_player.action_complexity_reduction, host_player.attack_duration_addition)
	queue_free()
