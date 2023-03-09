extends Node2D


func _input(event):
	# input com o teclado para mudar de tela
	if (event.is_action_pressed('interact')):
		Global.currentLevel = 'Level1'
		if get_tree().change_scene('res://scenes/Level1.tscn') != OK:
			print ('An unexpected error occured when trying to switch to next scene')


func _ready():
	# roda o gif de tutorial da prancheta
	$Animation.play('gif')


func _on_Back_pressed():
	# volta para a cena de tutorial anterior
	if get_tree().change_scene('res://scenes/Tutorial/TutorialInteraction.tscn') != OK:
			print ('An unexpected error occured when trying to switch to next scene')


func _on_Next_pressed():
	Global.currentLevel = 'Level1'
	if get_tree().change_scene('res://scenes/Level1.tscn') != OK:
		print ('An unexpected error occured when trying to switch to next scene')
