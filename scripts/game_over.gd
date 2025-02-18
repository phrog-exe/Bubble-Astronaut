extends Node2D


@onready var game_over_label: Label = $gameOver
@onready var main_script = get_node("/root/Main")
var high_scores_file := FileAccess.open("scores.txt", FileAccess.READ)
var high_scores : String = ""

func _ready() -> void:	
	while not high_scores_file.eof_reached():
		var line = high_scores_file.get_line().strip_edges()
		high_scores += (line + "\n")
		game_over_label.text = "GAME OVER\n SCORE: %s" % high_scores

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
