extends Area2D

var score = 0
signal increment_score

func _on_Anthill_increment_score():
	score += 1
	$CanvasLayer/Label.text = str(score)
