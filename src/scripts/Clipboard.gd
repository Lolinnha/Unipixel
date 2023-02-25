extends Button

var animationPlaying = false
var isOpened = false

func slideToScreen():
	animationPlaying = true
	# configura a animação de aparecer na tela, apenas em Y
	$Tween.interpolate_property(
		self,
		'rect_position:y',
		570,
		130,
		0.3,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	# inicia a animação
	$Tween.start()


func slideOffScreen():
	animationPlaying = true
	# configura a animação de aparecer na tela, apenas em Y
	$Tween.interpolate_property(
		self,
		'rect_position:y',
		130,
		570,
		0.3,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	# inicia a animação
	$Tween.start()


func _on_mouse_entered():
	# ao passar o mouse na prancheta, ela aparece na tela
	if animationPlaying or isOpened:
		# impede que as animações entrem em conflito
		return

	# inicia a animação
	slideToScreen()
	isOpened = true


func _on_mouse_exited():
	# ao tirar o mouse da prancheta, ela recua
	if animationPlaying:
		# impede que as animações entrem em conflito
		return

	# inicia a animação ao contrário
	slideOffScreen()
	isOpened = false


func _ready():
	# coleta o nome do nível de acordo com o node root
	# atualiza o nome na prancheta
	$LevelName.bbcode_text = '[center]' + Locales.levels.get(Global.currentLevel) + '[/center]'

	# atualiza todos os textos da prancheta de acordo com o nível
	var nodeCounter = 0
	for node in get_children():
		if not node.is_in_group('LevelText'):
			continue

		node.bbcode_text = '[center]' + Locales.clipboard.get(Global.currentLevel)[nodeCounter] + '[/center]'
		nodeCounter += 1


func _on_tween_completed(_object, _key):
	animationPlaying = false
