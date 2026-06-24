extends Area2D

var textures = {
	'coin': 'res://assets/coin.png',
	'key_red': 'res://assets/keyRed.png',
	'star': 'res://assets/star.png',
}

var type


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func init(_type, pos):
	$Sprite2D.texture = load(textures[_type])
	type = _type
	# position is not defined in this script — it is inherited from Node2D
	# (Area2D → Node2D). pos is the argument passed in; assigning it moves
	# this collectable to that spot in the scene.
	position = pos

func pickup():
	$CollisionShape2D.disabled = true
	# Godot 3 (Tween node):
	# $Tween.interpolate_property($Sprite, 'scale', Vector2(1,1), Vector2(3,3), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	# $Tween.interpolate_property($Sprite, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	# $Tween.start()
	# $Tween.connect('tween_completed', self, 'queue_free')
	# var tween is local — create_tween() makes a one-shot helper, not a Node.
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Sprite2D, "scale", Vector2(3, 3), 0.5)
	tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1, 0), 0.5)
	# Godot 4: finished replaces Godot 3's tween_completed signal.
	tween.finished.connect(queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# --- tween_property() (notes) ---
#
# Godot 3 interpolate_property() required start AND end values:
#   interpolate_property(node, 'scale', Vector2(1,1), Vector2(3,3), 0.5, ...)
#                                    start value ↑    end value ↑
#
# Godot 4 tween_property() only needs the end value:
#   tween_property(node, "scale", Vector2(3, 3), 0.5)
#                                 end value ↑
#
# Godot reads the property's current value as the start automatically.
# Here, scale starts at Vector2(1, 1) and modulate at Color(1, 1, 1, 1)
# because those are the Sprite2D defaults.
#
# To force a different start, set the property first, or use:
#   tween_property_from(node, "scale", Vector2(1, 1), Vector2(3, 3), 0.5)
#
# --- position in init() (notes) ---
#
# position is a built-in Node2D property, not a variable we declare:
#   Collactable → Area2D → Node2D  (position lives on Node2D)
#
# In init(_type, pos):
#   pos      → argument passed when init() is called (e.g. a tile coordinate)
#   position → the node's built-in Vector2; setting it places the collectable
#              at that location in the scene (same as Character.gd movement).
#
# --- tween completed / delete item (notes) ---
#
# Godot 3 (Tween node signal):
#   $Tween.connect('tween_completed', self, 'queue_free')
#
# Godot 4 (create_tween() signal):
#   tween.finished.connect(queue_free)
#
# finished fires once all tween steps are done, then queue_free() removes
# this collectable from the scene tree on the next idle frame.
#
# --- create_tween() lifecycle (notes) ---
#
# A Godot 4 tween is ephemeral — not a Node in the scene tree, not saved in
# the .tscn. Create it, use it, Godot frees it when done.
#
# Reuse?
#   Still running → can pause / kill
#   Finished      → do not reuse; call create_tween() again for a new animation
#
# Godot 3 Tween node could be reused ($Tween.interpolate... then start() again).
# Godot 4 style: one tween per animation. Here, pickup() creates one tween,
# finished fires, queue_free() removes the item — no reuse needed.
