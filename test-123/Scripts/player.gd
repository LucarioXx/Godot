extends CharacterBody2D

const SPEED = 50

func _physics_process(delta):
	var input_vector = Vector2.ZERO

	# Eingaben abfragen (horizontal & vertikal)
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# Wenn eine Richtung gedrückt ist → normalisieren (damit diagonale Bewegung nicht schneller ist)
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()

	# Geschwindigkeit berechnen
	velocity = input_vector * SPEED

	# Bewegung ausführen
	move_and_slide()
