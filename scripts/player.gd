extends CharacterBody2D

const SPEED = 220.0
const BLOWING_SPEED = 1000
const DECELERATION = 130.0
const TURN_DECELERATION = 200.0

var target_velocity := Vector2.ZERO

@onready var magnet: CharacterBody2D = $"../Magnet"
@onready var blower: CharacterBody2D = $"../Blower"
@onready var main_script = get_node("/root/Main")

var blowing_timer : bool = false
var timer : float = 0.0
var interval_true : float = 1.0
var interval_false : float = 2.0

func _physics_process(delta: float) -> void:
	var input_direction := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)

	if input_direction.length() > 0:
		input_direction = input_direction.normalized()
		
		if velocity.length() > 0:
			target_velocity = input_direction * SPEED
			if velocity.dot(input_direction) < 0:
				velocity = velocity.move_toward(Vector2.ZERO, TURN_DECELERATION * delta)
		else:
			target_velocity = input_direction * SPEED
	else:
		if main_script.blower_instance != null:
			var direction_to_blower = position - main_script.blower_instance.position
			direction_to_blower = direction_to_blower.normalized()
			timer += delta

			if blowing_timer == true:
				target_velocity = direction_to_blower * BLOWING_SPEED
				
				if timer >= interval_true:
					blowing_timer = false
					timer = 0.0
			else:
				target_velocity = Vector2.ZERO
				if timer >= interval_false:
					blowing_timer = true
					timer = 0.0
		else:
			if main_script.ufo_instance != null:
				var direction_to_magnet = main_script.ufo_instance.position - position
				direction_to_magnet = direction_to_magnet.normalized()
				target_velocity = direction_to_magnet * 500.0
			else:
				target_velocity = Vector2.ZERO
	
	if blowing_timer:
		velocity = velocity.move_toward(target_velocity, 500 * delta)
	else:
		velocity = velocity.move_toward(target_velocity, DECELERATION * delta)

	move_and_slide()
