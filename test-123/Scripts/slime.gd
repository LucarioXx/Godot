extends CharacterBody2D

# Eine saubere Methode, um die Zustände der KI zu definieren.
enum State { IDLE, CHASING, RETURNING }

@export var health = 100
@export var speed = 25

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
			velocity = Vector2.ZERO
			$AnimatedSprite2D.play("idle")
		State.CHASING:
			pass
		State.RETURNING:
			pass

	
	move_and_slide()


func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		current_state = State.CHASING
		print("Player detected! Chasing...")
		$AnimatedSprite2D.play("move")


func _on_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		current_state = State.RETURNING 