extends KinematicBody2D

const SPEED_UP_PER_BOOST = 20

var dead = false
var speed = 250
var direction = Vector2.UP

var acking_death = 0.0

# kolik sekund ma jeste nitro
var boost = 0

# kolik se prida ke speed po cas boostu
const BOOST_VALUE = 100

# kolik sekund vydrzi lahev nitra
const BOOST_TIME = 5

var touch_base = Vector2.ZERO
var touch_enabled = false

func _enter_tree() -> void:
	$Shape/Anim.play('default')
	var score = get_parent().get_node("GUI/Score")
	score.text = str(Game.points)
	
	if OS.has_touchscreen_ui_hint():
		$Camera.zoom = Vector2(0.1,0.1)

func die() -> void:
	dead = true
	collision_layer = 0
	$Shape/Anim.stop()
	$Ouch.show()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_cancel'):
		get_tree().set_input_as_handled()
		get_tree().change_scene("res://Menu.tscn")
		Game.reset()
		return
	
	if dead:
		if event is InputEventMouse:
			if event.button_mask:
				acking_death = 0.01
			else:
				acking_death = 0.0
		
		if event.is_action_pressed('ui_accept'):
			get_tree().set_input_as_handled()
			get_tree().change_scene("res://Menu.tscn")
			Game.reset()
		
		return
	
	if event is InputEventMouse:
		if event.button_mask:
			if not touch_enabled:
				touch_enabled = true
				touch_base = event.global_position
			else:
				var delta = event.global_position - touch_base
				
				if abs(delta.x) > abs(delta.y):
					if delta.x > 0:
						direction = Vector2.RIGHT
					else:
						direction = Vector2.LEFT
				else:
					if delta.y > 0:
						direction = Vector2.DOWN
					else:
						direction = Vector2.UP
		else:
			touch_enabled = false
	
	var left = event.get_action_strength("ui_left")
	var right = event.get_action_strength("ui_right")
	var up = event.get_action_strength("ui_up")
	var down = event.get_action_strength("ui_down")
	
	if max(left, right) > max(up, down):
		if left > 0.7 and left > right:
			direction = Vector2.LEFT
		elif right > 0.7:
			direction = Vector2.RIGHT
	else:
		if up > 0.7 and up > down:
			direction = Vector2.UP
		elif down > 0.7:
			direction = Vector2.DOWN
	
	if direction == Vector2.LEFT:
		$Shape.rotation_degrees = -90
	elif direction == Vector2.RIGHT:
		$Shape.rotation_degrees = 90
	elif direction == Vector2.UP:
		$Shape.rotation_degrees = 0
	elif direction == Vector2.DOWN:
		$Shape.rotation_degrees = 180
	
	$Ouch.rect_rotation = -rotation_degrees

func _physics_process(delta: float) -> void:
	if acking_death:
		acking_death += delta
		if acking_death > 1.5:
			get_tree().change_scene("res://Menu.tscn")
			Game.reset()
	
	if dead:
		return
	
	boost -= delta
	if boost < 0:
		boost = 0
	
	if boost:
		move_and_slide(direction * (speed + BOOST_VALUE))
	else:
		move_and_slide(direction * speed)
	
	var collected = $Collector.get_overlapping_bodies()
	
	if collected:
		var items = collected[0]
		var pos = items.world_to_map(global_position)
		var cell = items.get_cellv(pos)
		
		if cell == 6:
			$Pile.play()
			Game.points += 50
		elif cell == 7:
			$stack.play()
			Game.points += 25
		elif cell == 8:
			boost += BOOST_TIME
		
		items.set_cellv(pos, -1)
	
	var score = get_parent().get_node("GUI/Score")
	score.text = str(Game.points)
	
	var exiting = $Exiter.get_overlapping_areas()
	
	if exiting:
		var scene_name = get_tree().get_current_scene().get_name()
		
		if scene_name == 'Level1':
			get_tree().change_scene("res://Level2.tscn")
		elif scene_name == 'Level2':
			get_tree().change_scene("res://Level3.tscn")
		elif scene_name == 'Level3':
			get_tree().change_scene("res://Level4.tscn")
		elif scene_name == 'Level4':
			get_tree().change_scene("res://Level5.tscn")
		elif scene_name == 'Level5':
			get_tree().change_scene("res://Level6.tscn")
		elif scene_name == 'Level6':
			get_tree().change_scene("res://Level7.tscn")
