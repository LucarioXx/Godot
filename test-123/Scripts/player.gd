extends CharacterBody2D

const SPEED = 50
var cdirection = "none"


var last_dir = Vector2(0, 1)  # Standard: nach unten schauen

func _physics_process(delta):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
	)

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		velocity = input_vector * SPEED
		animation_player(input_vector)
		last_dir = input_vector  # Merke die letzte Bewegungsrichtung
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("front_idle")
		

	# Geschwindigkeit berechnen
	velocity = input_vector * SPEED 

	# Bewegung ausführen
	move_and_slide()

func animation_player(inputvalue):
	var anim= $AnimatedSprite2D

	if inputvalue.x > 0 and inputvalue.y == 0:
		anim.flip_h = false
		anim.play("side_walk")
	elif inputvalue.x > 0 and inputvalue.y < 0:
		anim.flip_h = false
		anim.play("side_walk")
	elif inputvalue.x > 0 and inputvalue.y > 0:
		anim.flip_h = false
		anim.play("side_walk")
	elif inputvalue.x < 0 and inputvalue.y == 0:
		anim.flip_h = true
		anim.play("side_walk")
	elif inputvalue.x < 0 and inputvalue.y < 0:
		anim.flip_h = true
		anim.play("side_walk")
	elif inputvalue.x < 0 and inputvalue.y > 0:
		anim.flip_h = true
		anim.play("side_walk")

	
