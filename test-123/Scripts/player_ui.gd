extends CanvasLayer

@onready var health_bar = $HealthBar
@onready var score_label
@onready var health_label = $HealthBar/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = GameMangager.max_health
	health_bar.value = GameMangager.current_health
	
	GameMangager.health_changed.connect(update_health)

func update_health(new_health):
	health_bar.value = new_health
	health_label.text = str(new_health) + "/" + str(GameMangager.max_health)