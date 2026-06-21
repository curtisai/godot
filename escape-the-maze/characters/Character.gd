extends Area2D


# speed will control the movement and animation speed of the
# caharacter, allowing you to customize the movement speed.
@export var speed: int


var tile_size = 64

# can_move is a flag that will track whether the caharcter is
# allowed to move during the current frame.
# It will be set to false while the movement is underway,
# preventing a second movement from being started before the
# previous one has finished.
var can_move = true
# facing is a string denoting the current direction of movement
# the spelling & capitalized exactly like the input
# actions you created at the beginning of the project.
var facing = 'right'
var moves = {
	'right': Vector2(1,0),
	'left': Vector2(-1, 0),
	'up': Vector2(0, -1),
	'down': Vector2(0, 1)
}

# when referencing another node during variable declaration,
# you must use onready to ensure that the variable isn't set
# before the referenced node is ready. You can think of it as
# a shortcut to writing the code in the _ready() function.
#
#    onready var sprite = $Sprite
# equals
#    var sprite
#    func _ready():
#        sprite = $Sprite

@onready var raycasts = {
	'right': $RayCastRight,
	'left': $RayCastLeft,
	'up': $RayCastUp,
	'down': $RayCastDown
}

func move(dir):
	$AnimationPlayer.playback_speed = speed
	facing = dir
	if raycasts[facing].is_colliding():
		# the return value will be null
		return
	can_move = false
	$AnimationPlayer.play(facing)
	$MoveTween.interpolate_property(self,
	position,position + moves[facing]*tile_size,
	1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$MoveTween.start()
	return true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
