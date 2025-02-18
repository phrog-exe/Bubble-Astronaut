extends Area2D

const SPEED = 100.0
var always_move_left := true
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	position.x -= SPEED * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		queue_free()
