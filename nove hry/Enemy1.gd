extends KinematicBody2D

const SPEED_UP = 0.5
const MIN_PATIENCE = 1
const MAX_PATIENCE = 5

const UP    = Vector2(0, -1)
const DOWN  = Vector2(0, +1)
const LEFT  = Vector2(-1, 0)
const RIGHT = Vector2(+1, 0)

const DIRECTIONS = [UP, RIGHT, DOWN, LEFT]

var patience = (MIN_PATIENCE + MAX_PATIENCE) / 2.0
var direction = 0

export var speed = 175

func _enter_tree() -> void:
	$Anim.play("walk")

func _physics_process(delta: float) -> void:
	speed += SPEED_UP * delta
	
	var move = move_and_slide(DIRECTIONS[direction] * speed)
	var eaten = $DangerZone.get_overlapping_bodies()
	
	if eaten:
		$Explosion.play()
		eaten[0].die()
	
	patience -= delta
	
	if not move or patience < 0:
		if patience < 0:
			patience = MIN_PATIENCE + randf() * (MAX_PATIENCE - MIN_PATIENCE)
		
		direction = (direction + 1) % len(DIRECTIONS)
		
		if DIRECTIONS[direction] == UP:
			rotation_degrees = 180
		elif DIRECTIONS[direction] == RIGHT:
			rotation_degrees = -90
		elif DIRECTIONS[direction] == DOWN:
			rotation_degrees = 0
		elif DIRECTIONS[direction] == LEFT:
			rotation_degrees = 90
	
	var nearby = $SirenZone.get_overlapping_bodies()
	if nearby:
		var distance = abs(position.distance_to(nearby[0].position))
		var radius = $SirenZone/Shape.shape.radius
		$Siren.volume_db = min((distance / radius) * -20 + 20, 6)
	else:
		$Siren.volume_db = -80
