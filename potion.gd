extends RigidBody3D

var type = "empty"

func change_type(new_type):
	get_node("CollisionShape3D/Types/%s" % type).hide()
	get_node("CollisionShape3D/Types/%s" % new_type).show()
	type = new_type	

# Called when the node enters the scene tree for the first time.
func _ready():
	# Hide all types
	for i in $CollisionShape3D/Types.get_children():
		i.hide()
		
	change_type("empty")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_player_detected():
	return 'a'
