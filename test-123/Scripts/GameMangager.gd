extends Node

var max_health = 100
var current_health = max_health

var high_score = 0
var current_score = 0

signal health_changed(new_health)

func take_damage(amount):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)

	if current_health == 0:
		game_over()

	health_changed.emit(current_health) # Signal auslösen

func game_over():
	print("Game Over!")
	get_tree().reload_current_scene() # Szene neu laden
	