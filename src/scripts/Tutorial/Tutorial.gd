extends Node2D


func _input(event):
	if (event.is_action_pressed('interact')):
		if get_tree().change_scene('res://scenes/Tutorial/TutorialInteraction.tscn') != OK:
			print ('An unexpected error occured when trying to switch to next scene')


func _on_Next_pressed():
	# passa para a próxima cena de tutorial
	if get_tree().change_scene('res://scenes/Tutorial/TutorialInteraction.tscn') != OK:
		print ('An unexpected error occured when trying to switch to next scene')


func _on_Back_pressed():
	if get_tree().change_scene('res://scenes/Tutorial/Character.tscn') != OK:
			print ('An unexpected error occured when trying to switch to next scene')
