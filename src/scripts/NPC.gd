extends Area2D

# flag para indicar se o jogador está na área de interação com o NPC
var canInteract = false

# representa o diálogo atual (índice na lista)
var currentDialog = 0

# flag para indicar se a frase atual foi finalizada
var phraseFinished = false


func showE():
	# mostra o E na tela, em cima do químico
	$E.visible = true
	$Tween.interpolate_property(
		$E,
		'position:y',
		-55,
		-80,
		0.2
	)
	$Tween.interpolate_property(
		$E,
		'modulate:a',
		0,
		1,
		0.3
	)
	$Tween.start()


func hideE():
	# esconde o E na tela, de cima do químico
	$Tween.interpolate_property(
		$E,
		'position:y',
		-80,
		-55,
		0.2
	)
	$Tween.interpolate_property(
		$E,
		'modulate:a',
		1,
		0,
		0.3
	)
	$Tween.start()


func loadDialog():
	# inicia o diálogo
	$'../HUD/Clipboard'.visible = false
	$'../HUD/Dialog'.visible = true
	get_parent().get_node('HUD/Gamepad').hide()
	nextDialog()
	Global.playerPaused = true


func closeDialog():
	# finaliza o diálogo
	$'../HUD/Clipboard'.visible = true
	$'../HUD/Dialog'.visible = false
	get_parent().get_node('HUD/Gamepad').show()
	$dialog_sound.stop()
	currentDialog = 0
	canInteract = false
	Global.playerPaused = false
	Global.score += 1

	set_deferred('monitoring', false)
	set_deferred('monitorable', true)


func nextDialog():
	$dialog_sound.play()
	# passa para a próxima frase do diálogo
	if currentDialog >= len(Locales.dialogs.get(Global.currentLevel)):
		# se acabaram as frases, finaliza o diálogo
		closeDialog()
		return

	# altera o nome do personagem para o da fala atual
	var characterName = Locales.characters.get(Locales.dialogs.get(Global.currentLevel)[currentDialog].character)
	$'../HUD/Dialog/Name'.bbcode_text = '[center]' + characterName + '[/center]'
	# altera o texto para a fala atual
	$'../HUD/Dialog/DialogText'.text = Locales.dialogs.get(Global.currentLevel)[currentDialog].text

	# reseta a flag
	phraseFinished = false
	# deixa o texto invisível
	$'../HUD/Dialog/DialogText'.visible_characters = 0

	while $'../HUD/Dialog/DialogText'.visible_characters < len($'../HUD/Dialog/DialogText'.text):
		# incrementa os caracteres visíveis: efeito de escrever
		$'../HUD/Dialog/DialogText'.visible_characters += 1
		# emite o som da máquina de escrever enquanto aparece o diálogo
		# espera um tempo para o próximo caracter
		$Timer.start()
		yield($Timer, 'timeout')

	# ao finalizar, liga a flag de finalizado
	phraseFinished = true
	$dialog_sound.stop()

	# atualiza o índice do diálogo atual
	currentDialog += 1


func _on_npc_quimico_body_entered(_body):
	# quando o player se aproximar, destaca o NPC e liga a interação
	$Stroke.visible = true
	canInteract = true
	get_parent().get_node('HUD/Gamepad/interact').modulate = Color(1, 1, 0.4)
	showE()


func _on_npc_quimico_body_exited(_body):
	# quando o player se aproximar, destaca o NPC e liga a interação
	$Stroke.visible = false
	canInteract = false
	get_parent().get_node('HUD/Gamepad/interact').modulate = Color(1, 1, 1)
	hideE()


func _on_Button_pressed():
	# ao pressionar o botão invisível, avança o diálogo
	if phraseFinished:
		# se a frase já está finalizada, avança o diálogo
		nextDialog()
	else:
		# senão, finaliza a frase
		$'../HUD/Dialog/DialogText'.visible_characters = len($'../HUD/Dialog/DialogText'.text)


func _input(event):
	if event.is_action_released('interact'):
		if $'../HUD/Dialog'.visible:
			# se o diálogo já está ativo, avança o diálogo
			if phraseFinished:
				# se a frase já está finalizada, avança o diálogo
				nextDialog()
			else:
				# senão, finaliza a frase
				$'../HUD/Dialog/DialogText'.visible_characters = len($'../HUD/Dialog/DialogText'.text)
		elif canInteract:
			# se o diálogo não está ativo e o personagem está na área de interação, carrega o diálogo
			loadDialog()


func _process(_delta):
	$dialog_sound.volume_db = Music.volume_db

