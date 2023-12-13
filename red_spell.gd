extends Node3D

var host_player = null

var damage_timer = 0
var damage_freq = .15
var damage_amount = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if host_player:
		damage_timer += delta
		if damage_timer > damage_freq:
			damage_timer = 0
			if $Detector.has_overlapping_bodies():
				handle_hit()
			
func handle_hit():
	var foes = $Detector.get_overlapping_bodies()
	for foe in foes:
		if foe != null:
			foe.damage(damage_amount)

func set_host_player(player):
	host_player = player
	$Timer.wait_time += host_player.attack_duration_addition # / 2 # consider halving addition
	$Timer.start()

func _on_timer_timeout():
	queue_free()
