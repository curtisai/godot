extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var screensize = Vector2()

func pickup():
	queue_free()
# queue_free() is Godot's node removal method.
# It safely removes the node from the tree and deletes it from
# memory along with all of its children.
# It doesn't delete the object immediately, but rather adds it
# to a queue to be deleted at the end of the current frame.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
