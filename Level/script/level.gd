extends Spatial


func _ready():
	$Player.pause_mode = Node.PAUSE_MODE_PROCESS
	$CanvasLayer.pause_mode = Node.PAUSE_MODE_PROCESS
	$CanvasLayer/GameOverScreen.visible = false
	$CanvasLayer/SuccessScreen.visible = false
	
	GameLogic.connect("ui_changed", self, "_on_ui_changed")
	GameLogic.connect("game_over", self, "_on_game_over")
	GameLogic.connect("success", self, "_on_success")

func _on_ui_changed(score):
	$CanvasLayer/Stolen/Label2.text = "%d/18" % score

func _on_game_over():
	get_tree().paused = true
	$CanvasLayer/GameOverScreen.visible = true

func _on_success():
	get_tree().paused = true
	$CanvasLayer/SuccessScreen.visible = true
