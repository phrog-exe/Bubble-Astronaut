extends Sprite2D



@onready var animated_sprite = $AnimatedSprite2D

# Speed of rotation (radians per second)
var rotation_speed = 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Rotate the AnimatedSprite2D
	animated_sprite.rotation += rotation_speed * delta
