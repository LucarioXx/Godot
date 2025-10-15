extends CharacterBody2D

# Eine saubere Methode, um die Zustände der KI zu definieren.
enum State { IDLE, CHASING, RETURNING }

@export var speed = 150.0

# Wir starten im IDLE (Leerlauf) Zustand.
var current_state = State.IDLE
var player
var spawn_position

# Diese Funktion wird einmal aufgerufen, wenn der Schleim im Spiel erscheint.
func _ready():
	# Wir merken uns, wo wir gestartet sind. Das ist unser Zuhause.
	spawn_position = global_position

# Diese Funktion wird 60 Mal pro Sekunde aufgerufen.
func _physics_process(delta):
	# Die Logik wird basierend auf dem aktuellen Zustand ausgewählt.
	match current_state:
		State.IDLE:
			# Im Leerlauf tun wir nichts. Die Geschwindigkeit ist null.
			velocity = Vector2.ZERO
		State.CHASING:
			# Wenn wir jagen, machen wir genau das, was wir vorher gemacht haben.
			chase_player()
		State.RETURNING:
			# Wenn wir zurückkehren, bewegen wir uns zum Spawnpunkt.
			return_to_spawn()
	
	move_and_slide()

# Diese Funktion wird aufgerufen, wenn der Spieler den Bereich betritt.
func _on_detection_area_body_entered(body):
	# Wir prüfen, ob das, was den Bereich betreten hat, auch wirklich der Spieler ist.
	if body.is_in_group("player"):
		player = body
		current_state = State.CHASING # Zustand ändern: Jagen!

# Diese Funktion wird aufgerufen, wenn der Spieler den Bereich verlässt.
func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player = null
		current_state = State.RETURNING # Zustand ändern: Zurückkehren!

func chase_player():
	if not player:
		# Sicherheitshalber: Wenn der Spieler plötzlich weg ist, kehre zurück.
		current_state = State.RETURNING
		return
	
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed

func return_to_spawn():
	# Finde die Richtung zu unserem "Zuhause".
	var direction = global_position.direction_to(spawn_position)
	
	# Prüfen, ob wir schon fast da sind (um nerviges Wackeln zu vermeiden).
	if global_position.distance_to(spawn_position) > 5:
		velocity = direction * speed
	else:
		# Wir sind da! Wechsle in den Leerlauf.
		velocity = Vector2.ZERO
		current_state = State.IDLE