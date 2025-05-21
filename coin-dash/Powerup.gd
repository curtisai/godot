extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property($AnimatedSprite, 'scale',
	$AnimatedSprite.scale,
	$AnimatedSprite.scale * 3.03,
	Tween.TRANS_QUAD,
	Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, "modulate",
	Color(1,1,1,1),
	Color(1,1,1,0), 0.3,
	Tween.TRANS_QUAD, Tween.EASE_IN_OUT)


var screensize = Vector2()

func pickup():
	# queue_free()
# queue_free() is Godot's node removal method.
# It safely removes the node from the tree and deletes it from
# memory along with all of its children.
# It doesn't delete the object immediately, but rather adds it
# to a queue to be deleted at the end of the current frame.
	monitoring = false
	# Setting monitoring to false ensures that the area_enter() signal won't be emitted
	# if the player touches the coin during the tween animation 
	$Tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Tween_tween_completed(object, key):
	queue_free()


func _on_PoweUp_area_entered(area):
	pass # Replace with function body.



func _on_Lifetime_timeout():
	queue_free()
