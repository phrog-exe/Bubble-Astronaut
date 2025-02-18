extends Node2D


@onready var background1: Sprite2D = $Background1
@onready var background2: Sprite2D = $Background2
@onready var player: CharacterBody2D = $Player

var asteroid_timer : float = 0.0
var ufo_timer : float = 0.0
var cloud_timer : float = 0.0
var bubble_timer : float = 0.0

var interval_asteroids_spawning = 0.1
var interval_ufo_spawning = 2.5
var interval_cloud_spawning = 3.2
var interval_bubble_spawning = null

var high_scores := []

const ASTEROID_SCENE = preload("res:///scenes/asteroid.tscn")
const UFO_SCENE = preload("res://scenes/magnet_ufo.tscn")
const BLOWER_SCENE = preload("res://scenes/blower.tscn")
const BUBBLE_SCENE = preload("res://scenes/bubbles.tscn")
const GAME_OVER_SCENE = preload("res://scenes/game_over.tscn")

var SPAWN_AREA_SIZE = Vector2(1920, 1080)
var high_scores_file : FileAccess

@export var ufo_instance: Area2D
@export var blower_instance: Area2D
@export var health = 100
@export var score = 0

var background_speed = 200.0

@onready var label: Label = $Player/Camera2D/Label
	
func _process(delta: float) -> void:
	label.text = "HEALTH: %d \n SCORE: %d" % [health, score]
	asteroid_timer += delta
	ufo_timer += delta
	cloud_timer += delta
	bubble_timer += delta
	interval_bubble_spawning = randf_range(2.0, 5.0)
	score += delta
	
	var player_position: Vector2 = player.position
	
	if background1 and background2:
		move_backgrounds(delta)
	
	if asteroid_timer >= interval_asteroids_spawning:
		spawn_object(ASTEROID_SCENE, SPAWN_AREA_SIZE)
		SPAWN_AREA_SIZE += player_position / 10
		asteroid_timer = 0.0
	if ufo_timer >= interval_ufo_spawning:
		spawn_object(UFO_SCENE, SPAWN_AREA_SIZE)
		SPAWN_AREA_SIZE += player_position / 10
		ufo_timer = 0.0
	if cloud_timer >= interval_cloud_spawning:
		spawn_object(BLOWER_SCENE, SPAWN_AREA_SIZE)
		SPAWN_AREA_SIZE += player_position / 10
		cloud_timer = 0.0
	if bubble_timer >= interval_bubble_spawning:
		spawn_object(BUBBLE_SCENE, SPAWN_AREA_SIZE)
		SPAWN_AREA_SIZE += player_position / 10
		bubble_timer = 0.0
		
	if health < 0:
		health = 0
		
	if health == 0:
		var high_scores_file := FileAccess.open("scores.txt", FileAccess.READ)
		var lines = []
		while not high_scores_file.eof_reached():
			var line = high_scores_file.get_line()
			lines.append(line)
			
		lines.append(str(score))
		high_scores_file.close()

		high_scores_file = FileAccess.open("scores.txt", FileAccess.WRITE)
		
		if lines.size() >= 2:
			lines.sort_custom(func(a, b): return a > b)
		if lines.size() > 10:
			lines = lines.slice(0, 10)
		
		for line in lines:
			if line != "":
				high_scores_file.store_line(line)
		high_scores_file.close()
		get_tree().change_scene_to_packed(GAME_OVER_SCENE)
	
func move_backgrounds(delta: float) -> void:
	background1.position.x -= background_speed * delta
	background2.position.x -= background_speed * delta
	
	if background1.position.x <= -background1.texture.get_size().x:
		background1.position.x = background2.position.x + background2.texture.get_size().x
	
	if background2.position.x <= -background2.texture.get_size().x:
		background2.position.x = background1.position.x + background1.texture.get_size().x

func move_random_direction(object: CharacterBody2D, speed: float, direction: Vector2) -> void:
	object.velocity = direction * speed
	object.move_and_slide()

var asteroid_scene: PackedScene
var spawn_area_size: Vector2

func spawn_object(scene: PackedScene, area_size: Vector2) -> void:
	var object_instance = scene.instantiate() as Area2D
	
	var random_position = Vector2(
		area_size.x,
		randf() * area_size.y
	)

	object_instance.position = random_position
	add_child(object_instance)
	
	if scene == UFO_SCENE:
		ufo_instance = object_instance
	if scene == BLOWER_SCENE:
		blower_instance = object_instance
