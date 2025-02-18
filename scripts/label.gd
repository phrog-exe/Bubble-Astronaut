extends Label

func _ready() -> void:
	update_score()

# Function to update the score label
func update_score() -> void:
	text = "Score: " + str(Global.score)
