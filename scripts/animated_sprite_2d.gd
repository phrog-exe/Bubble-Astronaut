extends AnimatedSprite2D


var rotation_speed = 1.3

func _ready() -> void:
	play("default")  

func _process(delta: float) -> void:
	rotation += rotation_speed * delta
