extends "res://characters/Character.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	can_move = false
	facing = moves.keys()[randi()%4]
	# Enemies are placed below the TileMap in the scene tree. Movement uses
	# RayCast2D to detect walls, but those collisions may not be ready on the
	# same frame _ready() runs. This delay keeps the enemy still until the
	# TileMap (walls) has been processed. Godot 4: await replaces yield(...).
	await get_tree().create_timer(0.5).timeout
	# Tighter alternative (one physics tick instead of 0.5s):
	# await get_tree().physics_frame
	can_move = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_move:
		if not move(facing) or randi() % 10 > 5:
			facing = moves.keys()[randi()%4]


# --- get_tree() (notes) ---
#
# get_tree() returns the SceneTree — the manager that runs the whole game.
# It is NOT a node in the hierarchy (not your parent, not the root).
#
# Three different things:
#   get_parent()       → this node's direct parent (one level up)
#   get_tree().root    → the root Viewport at the top of the window
#   get_tree()         → the SceneTree itself (timers, scene changes, pause)
#
# create_timer() lives on SceneTree, not on individual nodes, so we call it
# through get_tree(). Here it pauses _ready() for 0.5 seconds before the
# enemy is allowed to move.
#
# Why the delay?
#   Enemies sit below the TileMap in the scene tree. _ready() runs top-to-
#   bottom, so the TileMap runs first — but wall collisions may still need
#   an extra frame before RayCast2D can detect them. Without a wait, the
#   enemy might move into a wall on its first step. 0.5s is the tutorial
#   buffer (kept for now). See the commented alternative in _ready():
#     await get_tree().physics_frame
#
# Timer lifecycle (create_timer):
#   1. create_timer(0.5) makes a one-shot timer — not a Node in the tree.
#   2. await pauses _ready() until the timer emits timeout after 0.5s.
#   3. After timeout, _ready() continues (can_move = true).
#   4. The timer is finished; Godot frees it automatically. No queue_free()
#      needed, it does not keep running, and timers do not pile up.
#   Unlike a Timer node in the editor, create_timer() is for temporary delays.
