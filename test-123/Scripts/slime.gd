extends CharacterBody2D

# Eine saubere Methode, um die Zustände der KI zu definieren.
enum State { IDLE, CHASING, RETURNING }

@export var health = 100
@export var speed = 25
@export var attack_range = 10

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
			chase_player(delta)
		State.RETURNING:
			return_to_spawn(delta)
	move_and_slide()


func _on_detection_area_body_entered(body):
	print(body)
	if body.is_in_group("Player"):
		player = body
		current_state = State.CHASING
		print("Player detected! Chasing...")


func _on_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		current_state = State.RETURNING 

func chase_player(delta):
	if not player:
		current_state = State.RETURNING
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)

	if distance_to_player > attack_range:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		$AnimatedSprite2D.play("move")
	else:
		current_state = State.RETURNING

func return_to_spawn(delta):
	var direction = global_position.direction_to(spawn_position)

	if global_position.distance_to(spawn_position) > 5:
		velocity = direction * speed
	else:
		# Wir sind da! Wechsle in den Leerlauf.
		velocity = Vector2.ZERO
		current_state = State.IDLE
