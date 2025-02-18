extends Area2D


const SPEED = 300.0
var always_move_left := true

@onready var sound_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var player: CharacterBody2D = $Player
@onready var main_script = get_node("/root/Main")

func _ready() -> void:	
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	position.x -= SPEED * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		sound_player.play()
		queue_free()
		main_script.health -= 5;
