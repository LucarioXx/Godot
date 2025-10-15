# Wir sagen dem Skript, dass es die Fähigkeiten des CharacterBody2D-Nodes erweitert.
extends CharacterBody2D

# Eine Variable für die Geschwindigkeit.
# Durch @export können wir sie direkt im Godot-Editor anpassen!
@export var speed = 300.0

# Diese Funktion wird von Godot konstant in jedem Physik-Frame aufgerufen.
# Perfekt für alles, was mit Bewegung und Physik zu tun hat.
func _physics_process(delta):
	# 1. Finde die Eingaberichtung heraus.
	# Godot fragt, welche Tasten für "links", "rechts", "hoch", "runter" gedrückt werden
	# und erstellt daraus einen Richtungs-Pfeil (Vektor).
	var direction = Input.get_vector("left", "right", "up", "down")

	# 2. Berechne die Geschwindigkeit.
	# Wir nehmen den Richtungs-Pfeil und geben ihm unsere gewünschte "Länge" (Geschwindigkeit).
	velocity = direction * speed

	# 3. Bewege die Figur.
	# Das ist die magische Funktion des CharacterBody2D.
	# Sie bewegt die Figur und sorgt automatisch dafür, dass sie an Wänden abprallt.
	move_and_slide()



@export var speed = 300.0

func _physics_process(delta):

	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()