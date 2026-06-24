extends "res://characters/Character.gd"

signal moved

signal dead
signal grabbed_key
signal win

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	# _setup_camera_limits(5)


# func _setup_camera_limits(tile_radius: int) -> void:
# 	# Limits must be larger than the viewport, or the camera can't center
# 	# on the player. Add half the viewport beyond the walkable tile radius.
# 	var camera := $Camera as Camera2D
# 	var half_view := get_viewport().get_visible_rect().size * 0.5
# 	var margin: int = tile_radius * int(tile_size)
# 	camera.limit_left = int(-margin - half_view.x)
# 	camera.limit_top = int(-margin - half_view.y)
# 	camera.limit_right = int(margin + half_view.x)
# 	camera.limit_bottom = int(margin + half_view.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_move:
		for dir in moves.keys():
			if Input.is_action_pressed(dir):
				if move(dir):
					emit_signal("moved")


# --- Camera2D limits (notes) ---
#
# What limits are:
#   Camera limits define the world-space rectangle that the camera is allowed
#   to show. They mark the edges of your level/map so the view does not scroll
#   past the playable area.
#
# Viewport vs limits:
#   - Viewport = what you see on screen right now (e.g. 1152 x 648).
#   - Limits   = the full map bounds in pixels (usually much larger than the
#                viewport in a finished level).
#
# Godot's rule:
#   If the limit box is smaller than the viewport, the camera cannot keep the
#   player centered. Godot prioritizes staying inside the limits over centering,
#   so the player appears off-center immediately.
#
# Minimum size:
#   Limits must be at least as large as the viewport. In practice, set them to
#   your TileMap / maze size when you build the level scene.
#
# Two ways to set limits (for testing):
#   1. Manual — type large values on the Camera2D node in the Inspector.
#   2. Script — uncomment _setup_camera_limits() above; it computes:
#        limit = tile_radius * tile_size + half the viewport
#      so the player can walk a few tiles while staying centered.
#
# No limits (limit_enabled = false):
#   The camera follows the player forever with no clamping. If you walk past
#   the edge of your TileMap, you will see empty space (the default clear/
#   background color) because nothing is drawn there — limits do not create
#   tiles, they only stop the camera from scrolling. Use limits on the final
#   maze scene to hide that void at map edges.


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('enemies'):
		emit_signal('dead')
	if area.has_method('pickup'):
		area.pickup()
	if area.type=='key_red':
		emit_signal('grabbed_key')
	if area.type=='star':
		emit_signal('win')
