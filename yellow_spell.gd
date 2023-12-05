extends Node3D
var host_player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if host_player:
		var pos = host_player.global_position
		global_position = pos

func set_host_player(player):
	host_player = player
	$Timer.wait_time += host_player.attack_duration_addition # / 2 # consider halving addition
	$Timer.start()

func _on_timer_timeout():
	queue_free()
