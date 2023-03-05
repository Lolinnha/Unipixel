extends Node2D

# indica se tem algum pallet selecionado na cena
var woodSelected


func closeMinigame():
	# fecha o minigame, desligando a indicação e limpando a instância da cena
	Global.minigameRunning = false
	queue_free()


func _on_ContinueButton_pressed():
	closeMinigame()
	
func _input(event):
	if event.is_action_pressed('ui_cancel'):
		# tecla ESC fecha o minigame
		closeMinigame()


func _ready():
	# desabilita a visibilidade da tela de vencedor
	$WinScreen.visible = false
	# carrega os textos da tela de vitória do minigame
	$WinScreen/Background2/Lose.text = Locales.others.win
	$WinScreen/Background2/ContinueButton.text = Locales.others.continue


func _process(_delta):
	if ($FixedWood2/TopPosition.ocuppied and 
		$FixedWood2/MiddlePosition.ocuppied and
		$FixedWood2/BottomPosition.ocuppied
	):
		# se os pallets estão ocupando a posição que deveriam, o jogador ganha
		$WinScreen.visible = true
