extends Node


signal score_changed
signal ui_changed(score)
signal game_over
signal success

var score := 0

func _ready():
	connect("score_changed", self, "_on_score_changed")

func _on_score_changed():
	score += 1
	emit_signal("ui_changed", score)
	if score == 18:
		emit_signal("game_over")
