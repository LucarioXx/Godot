extends CharacterBody2D

# NEU: Wir fügen den wichtigen ATTACKING-Zustand hinzu.
enum State { IDLE, CHASING, ATTACKING, RETURNING }

@export var health = 100
@export var speed = 25
@export var attack_range = 10# Etwas größerer Wert für bessere Tests
@export var attack_damage = 10

var current_state = State.IDLE
var player
var spawn_position

func _ready():
	spawn_position = global_position

func _physics_process(delta):
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO 
			update_animation(Vector2.ZERO)
		State.CHASING:
			chase_player()
		State.ATTACKING: 
			velocity = Vector2.ZERO
			update_animation(Vector2.ZERO) 
		State.RETURNING:
			return_to_spawn()
	
	move_and_slide()

# --- Zustands-Logik ---

func chase_player():
	if not player:
		current_state = State.RETURNING
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)

	# GEÄNDERT: Die Kernlogik ist jetzt korrekt.
	if distance_to_player > attack_range:
		# Wenn wir zu weit weg sind, jagen wir.
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		update_animation(direction)
	else:
		# Wenn wir nah genug dran sind, greifen wir an!
		current_state = State.ATTACKING
		$AttackTimer.start() # Starte den Countdown für den Angriff.

func return_to_spawn():
	var direction = global_position.direction_to(spawn_position)

	if global_position.distance_to(spawn_position) > 5:
		velocity = direction * speed
		update_animation(direction)
	else:
		velocity = Vector2.ZERO
		current_state = State.IDLE

# --- Signal-Funktionen ---

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		current_state = State.CHASING

func _on_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		# GEÄNDERT: Wir rennen nur weg, wenn wir nicht gerade angreifen.
		if current_state == State.CHASING:
			current_state = State.RETURNING

# NEU: Diese Funktion wird aufgerufen, wenn der AttackTimer abläuft.
func _on_attack_timer_timeout():
	if player and global_position.distance_to(player.global_position) <= attack_range:
		GameMangager.take_damage(attack_damage) # Verursacht Schaden beim Spieler.
		current_state = State.CHASING
	else:
		current_state = State.RETURNING

	

# --- Helfer-Funktionen ---

func update_animation(direction):
	# GEÄNDERT: Behandelt den Fall, wenn der Schleim stillsteht.
	if direction == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
		return

	if abs(direction.x) > abs(direction.y):
		$AnimatedSprite2D.play("side_walk")
		$AnimatedSprite2D.flip_h = direction.x < 0
	else:
		if direction.y < 0:
			$AnimatedSprite2D.play("up")
		else:
			$AnimatedSprite2D.play("down")
