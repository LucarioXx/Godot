extends CharacterBody2D

const SPEED = 50
var cdirection = "none"
var last_dir = Vector2.DOWN


func _physics_process(delta):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
	)

	if input_vector != Vector2.ZERO:
		# Bewegung aktiv
		input_vector = input_vector.normalized()
		velocity = input_vector * SPEED
		animation_player(input_vector, false)  # false = nicht idle
		print(input_vector)
		last_dir = input_vector  # Merke die letzte Bewegungsrichtung
	else:
		# Stillstand
		velocity = Vector2.ZERO

		animation_player(last_dir, true)  # true = idle
	

		$AnimatedSprite2D.play("front_idle")
		

	# Geschwindigkeit berechnen
	velocity = input_vector * SPEED 

	# Bewegung ausführen

	move_and_slide()


func animation_player(direction: Vector2, is_idle: bool):
	var anim = $AnimatedSprite2D


	# --- Bewegung rechts/links ---
	if direction.x > 0 and abs(direction.x) > abs(direction.y):
		anim.flip_h = false
		anim.play("side_idle" if is_idle else "side_walk")

	elif direction.x < 0 and abs(direction.x) > abs(direction.y):
		anim.flip_h = true
		anim.play("side_idle" if is_idle else "side_walk")

	# --- Bewegung nach oben ---
	elif direction.y < 0:
		anim.flip_h = false
		anim.play("back_idle" if is_idle else "back_walk")

	# --- Bewegung nach unten ---
	elif direction.y > 0:
		anim.flip_h = false
		anim.play("front_idle" if is_idle else "front_walk")
