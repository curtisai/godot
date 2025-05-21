extends Node

# In the $ notation, the node name is relative to the node running
# to the script. For example, $Node1/Node2 would refer to
# a node (Node2) that is the child of Node1
export (PackedScene) var Coin
export (PackedScene) var Powerup
export (int) var playtime

var level
var score
var time_left
var screensize
var playing = false

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	# Ensure the Player moves to the proper starting location.
	$Player.start($PlayerStart.position)
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	# You must use randomize() if you want your sequence of "random" numbers 
	# to be different every time you run the scene. Technically speaking, 
	# this selects a random seed for the random number.
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()


func spawn_coins():
	$PowerupTimer.wait_time = rand_range(5, 10)
	$PowerupTimer.start()
	$LevelSound.play()
	for i in range(4 + level):
		var c = Coin.instance()
		$CoinContainer.add_child(c)
		c.screensize = screensize
		c.position = Vector2(
			rand_range(0, screensize.x),
			rand_range(0, screensize.y)
			)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playing and $CoinContainer.get_child_count() == 0:
		level += 1
		time_left += 5
		spawn_coins()

func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()

func game_over():
	$EndSound.play()
	playing = false
	$GameTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	$HUD.show_game_over()
	$Player.die()


func _on_Player_hurt():
	game_over()


func _on_Player_pickup(type):
	match type:
		"coin":
			score += 1
			$CoinSound.play()
			$HUD.update_score(score)
		"powerup":
			time_left += 5
			$PowerupSound.play()
			$HUD.update_timer(time_left)


func _on_PowerupTimer_timeout():
	var p = Powerup.instance()
	add_child(p)
	p.screensize=screensize
	p.position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))
