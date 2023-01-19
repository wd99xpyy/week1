extends CanvasLayer

signal start_game

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()


func show_game_over():
	$ColorRect.hide()#QW - hide the lives bar when game over
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Dodge the\nCreeps"
	$MessageLabel.show()
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()


func update_score(score):
	$ScoreLabel.text = str(score)


func _on_StartButton_pressed():
	$StartButton.hide()
	$ColorRect.show() #QW - show the lives bar when game begain
	emit_signal("start_game")


func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func changeSize(change):#QW - change the size of the lives bar
	print(change)#QW 
	$ColorRect.rect_size.x = 20 + 160*change#QW 

func resetSize():#QW - reset the lives bar
	$ColorRect.rect_size.x = 480#QW 
