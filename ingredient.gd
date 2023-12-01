extends 'interactable_item.gd'

@export var color = "red"
@export var is_chopped = false

func change_type(new_color):
	is_chopped = false
	get_node("Types/Raw/%s" % color).hide()
	get_node("Types/Raw/%s" % color).show()
	
	get_node("Types/Chopped/%s" % color).hide()
	get_node("Types/Chopped/%s" % color).show()
	color = new_color

func chop():
	is_chopped = true
	item_type = "chopped"
	$AnimationPlayer.play("chop")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	item_type = "raw"
	
	# Hide all types
	for i in $Types/Raw.get_children():
		i.hide()
		
	# Hide all types
	for i in $Types/Chopped.get_children():
		i.hide()
	
	$Types/Chopped.hide()
	#$Types/Raw.show()
	
	change_type(color)
