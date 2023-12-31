extends Node2D

var tween = Tween.new()

var animationPlaying = false
var currentBecker = -1
var minigameScore = 15

func showTape():
	# anima a fita saindo do becker
	if animationPlaying:
		return

	animationPlaying = true

	$'Becker/Tape'.visible = false
	$Tape.position = Vector2(640, 399)
	$Tape.rotation_degrees = -153.2
	$Tape.modulate = Color(1, 1, 1, 1)
	$Tape.scale = Vector2(1, 1)

	# usamos o tween para mover a fita de denro do becker para a posição correta 
	tween.interpolate_property(
		$Tape,
		'position',
		Vector2(640, 399),
		Vector2(730, 240),
		1.5,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)

	tween.interpolate_property(
		$Tape,
		'rotation_degrees',
		-153.2,
		-90,
		1.5,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)

	tween.interpolate_property(
		$Tape,
		'scale',
		Vector2(1, 1),
		Vector2(2, 2),
		1.5,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)

	tween.start()


func discardTape():
	# anima a fita sendo descartada
	tween.interpolate_property(
		$Tape,
		'modulate:a',
		1,
		0,
		1,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)

	tween.start()


func loadBecker(tapeType):
	# anima um novo becker sendo carregado
	if animationPlaying:
		return

	animationPlaying = true

	$Becker/Tape.texture = load('res://assets/Minigames/PhTest/phTape' + tapeType + '.png')
	$Becker/Tape.visible = true
	$Becker.rotation_degrees = 0
	$Becker.scale = Vector2(2, 2)
	$Becker.position = Vector2(1020, 413)
	$Tape.texture = load('res://assets/Minigames/PhTest/phTape' + tapeType + '.png')

	tween.interpolate_property(
		$Becker,
		'position:x',
		1020,
		640,
		1,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)

	tween.interpolate_property(
		$Becker,
		'modulate:a',
		0,
		1,
		0.3,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT,
		0.5
	)

	tween.start()


func discardWrongBecker():
	# anima o becker errado sendo descartado
	if animationPlaying:
		return

	animationPlaying = true

	tween.interpolate_property(
		$Becker,
		'position:y',
		$Becker.position.y,
		850,
		1,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)

	tween.interpolate_property(
		$Becker,
		'scale',
		$Becker.scale,
		Vector2(0, 0),
		1,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)

	tween.interpolate_property(
		$Becker,
		'rotation_degrees',
		$Becker.rotation_degrees,
		-90,
		1,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)

	tween.interpolate_property(
		$Becker,
		'modulate:a',
		1,
		0,
		0.3,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT,
		0.25
	)

	tween.start()
	discardTape()


func saveRightBecker():
	# anima o becker certo sendo salvo
	if animationPlaying:
		return

	animationPlaying = true

	tween.interpolate_property(
		$Becker,
		'position:x',
		640,
		265,
		1,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)

	tween.interpolate_property(
		$Becker,
		'modulate:a',
		1,
		0,
		0.3,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT,
		0.3
	)

	tween.start()
	discardTape()


func wrongChoice():
	# anima uma escolha errada (shake e cor vermelha)
	if animationPlaying:
		return

	animationPlaying = true
	$Tape.modulate = Color(1, 0.5, 0.5, 1)
	$Becker.modulate = Color(1, 0, 0, 1)

	tween.interpolate_property(
		$Becker,
		'rotation_degrees',
		0,
		10,
		0.2,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)

	tween.interpolate_property(
		$Becker,
		'rotation_degrees',
		10,
		-10,
		0.2,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT,
		0.2
	)

	tween.interpolate_property(
		$Becker,
		'rotation_degrees',
		-10,
		0,
		0.2,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT,
		0.4
	)

	tween.start()

	yield(get_tree().create_timer(0.6), 'timeout')
	$Tape.modulate = Color(1, 1, 1, 1)
	$Becker.modulate = Color(1, 1, 1, 1)

	minigameScore -= 1


func nextBecker():
	# troca para o próximo becker
	currentBecker += 1

	if currentBecker >= 6:
		# se acabaram os becker, termina o minigame
		Global.playerPaused = false
		Global.score += minigameScore
		get_parent().closeMinigame()
		return

	loadBecker(get_parent().tapesTypes[currentBecker])
	yield(get_tree().create_timer(1.5), 'timeout')
	showTape()


func _on_tween_completed(_node, _key):
	animationPlaying = false


func _on_WrongButton_pressed():
	if animationPlaying:
		return

	# ao clicar no botão errado, verifica se a escolha foi correta

	if not get_parent().tapesTypes[currentBecker] != 'Right':
		wrongChoice()
		return

	discardWrongBecker()
	yield(get_tree().create_timer(1.5), 'timeout')
	nextBecker()


func _on_RightButton_pressed():
	if animationPlaying:
		return

	# ao clicar no botão certo, verifica se a escolha foi correta

	if not get_parent().tapesTypes[currentBecker] == 'Right':
		wrongChoice()
		return

	saveRightBecker()
	yield(get_tree().create_timer(1), 'timeout')
	nextBecker()


func _ready():
	add_child(tween)
	tween.connect('tween_completed', self, '_on_tween_completed')
	nextBecker()
