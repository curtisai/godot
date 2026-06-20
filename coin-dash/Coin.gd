extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = randf_range(5, 8)
	$Timer.start()


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
	var sprite = $AnimatedSprite2D
	var tween = create_tween().set_parallel(true)
	tween.tween_property(sprite, "scale", sprite.scale * 3.03, 0.3)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0), 0.3)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Coin_area_entered(area):
	if area.is_in_group("obstacle"):
		position = Vector2(
			randf_range(0, screensize.x),
			randf_range(0, screensize.y)
		)


func _on_Timer_timeout():
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play()
