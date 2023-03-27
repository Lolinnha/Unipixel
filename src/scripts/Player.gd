extends KinematicBody2D

export (int) var runSpeed = 500
export (int) var jumpSpeed = -1250
export (int) var gravity = 3000

var PPEs = []
var velocity = Vector2()

var paused = false


func movePlayer():
	if Global.playerPaused:
		$Animation.play("reset" + Global.characterName)
		velocity = Vector2.ZERO
		return

	# interpreta os inputs de movimentação e aplica as velocidades	
	velocity.x = 0
	# recebe os inputs de movimentação
	var right = Input.is_action_pressed('move_right')
	var left = Input.is_action_pressed('move_left')
	var jump = Input.is_action_just_pressed('jump')

	# aplica as velocidades de acordo com o movimento desejado
	if jump and is_on_floor():
		velocity.y = jumpSpeed
		$jump_sound.play()
	elif right: 
		velocity.x += runSpeed
		$Animation.play('run' + Global.characterName)
		$Sprite.flip_h = false 
	elif left:
		velocity.x -= runSpeed
		$Animation.play('run' + Global.characterName)
		$Sprite.flip_h = true
	else:
		$Animation.play("reset" + Global.characterName)


func _physics_process(delta):
	if paused:
		return

	# realiza a movimentação do player
	movePlayer()
	# calcula a velocidade em y de acordo com a gravidade
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	for platforms in get_slide_count():
		var collision = get_slide_collision(platforms)
		if not collision.collider.has_method('fall'):
			return

		if collision.collider.animationPlaying:
			return

		collision.collider.fall()
