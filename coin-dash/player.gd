extends Area2D

signal pickup
signal hurt

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@export var speed: int
var velocity = Vector2()
var screensize = Vector2(480, 720)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_h = velocity.x <= 0
	else:
		$AnimatedSprite2D.animation = "idle"

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

func start(pos):
	position = pos
	$AnimatedSprite2D.animation = "idle"
	set_process(true)

func die():
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)


func _on_Player_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
	if area.is_in_group("powerup"):
		area.pickup()
		pickup.emit("powerup")
	if area.is_in_group("obstacle"):
		hurt.emit()
		die()
