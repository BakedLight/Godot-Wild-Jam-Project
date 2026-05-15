extends Spatial


func _ready():
	$Player.pause_mode = Node.PAUSE_MODE_PROCESS
	$CanvasLayer.pause_mode = Node.PAUSE_MODE_PROCESS
	
	GameLogic.connect("ui_changed", self, "_on_ui_changed")
	GameLogic.connect("game_over", self, "_on_game_over")

func _on_ui_changed(score):
	$CanvasLayer/Stolen/Label2.text = "%d/18" % score

func _on_game_over():
	get_tree().paused = true
	$CanvasLayer/GameOver.visible = true
