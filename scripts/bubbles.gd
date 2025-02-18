extends Area2D


@onready var sound_player: AudioStreamPlayer = $SoundPlayer
@onready var player: CharacterBody2D = $Player
@onready var main_script = get_node("/root/Main")

const SPEED = 200.0

func _ready() -> void:	
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	position.x -= SPEED * delta

# When the player collides with the bubble
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):  # Check if it's the player
		#sound_player.play()  # Play sound effect (optional) TODO is null, fix it
		queue_free()  # Remove the bubble from the scene
		
		if main_script.health < 91: #Max health is 100
			main_script.health += 10
		else:
			main_script.health = 100
