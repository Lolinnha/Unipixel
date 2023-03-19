extends Area2D


func _process(delta):

	if PhGlobal.selected3 ==true and PhGlobal.selected1==false and PhGlobal.selected2==false: 
		followMouse()

	if PhGlobal.points == 6:
		print('você ganhou!')

func followMouse():
	position = get_global_mouse_position()

func _on_Tape_3_input_event(viewport, event, shape_idx):

	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			PhGlobal.selected3 = true
		if not event.pressed:
			PhGlobal.selected3 = false
		get_scale()
		if scale.x and scale.y == 1.5:
			self.set_scale(scale/1.5)

func _on_Tape_3_mouse_entered():
	if PhGlobal.zoom1 ==false and PhGlobal.zoom2==false and PhGlobal.zoom6==false and PhGlobal.zoom4==false and PhGlobal.zoom5==false:
		PhGlobal.zoom3 = true
		if PhGlobal.zoom3 == true:
			self.set_scale(scale*1.5)

func _on_Tape_3_mouse_exited():
	PhGlobal.zoom3 = false
	if scale.x and scale.y == 1.5:
		self.set_scale(scale/1.5)


