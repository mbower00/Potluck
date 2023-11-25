extends 'interactable_static.gd'


func burn_item():
	$AnimationPlayerBurn.play('burn')

# Called when the node enters the scene tree for the first time.
func _ready():
	item_type = "glass_blowing_set"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

