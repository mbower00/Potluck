extends Node3D

var button_shown = false

"""
Shows the mesh for the corresponding [btn].
Params:
	btn <str>: The button to show 'a' 'b' 'x' or 'y'
"""
func show_button(btn):
	hide_buttons()
	button_shown = true
	match btn:
		'a':
			$Buttons/A.show()
		'b':
			$Buttons/B.show()
		'x':
			$Buttons/X.show()
		'y':
			$Buttons/Y.show()
		_:
			print("Please pass in 'a' 'b' 'x' or 'y'")
			button_shown = false
	$AnimationPlayer.play("wiggle")

"""
Hides all the button meshs.
"""
func hide_buttons():
	button_shown = false
	$Buttons/A.hide()
	$Buttons/B.hide()
	$Buttons/X.hide()
	$Buttons/Y.hide()

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_buttons()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if button_shown:
		look_at(Vector3(0,100,100))
