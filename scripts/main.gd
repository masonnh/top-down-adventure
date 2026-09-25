extends Node2D

var level: int = 3 
var current_level_root: Node = null

@onready var hud: CanvasLayer = $HUD


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level_root = get_node("LevelRoot")
	_load_level(level)


##################
# Level Management
##################
func _load_level(level_number: int) -> void:
	if current_level_root:
		current_level_root.queue_free()
	
	# Change level
	var level_path = "res://scenes/levels/level_%s.tscn" % level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)


func _setup_level(level_root: Node) -> void:
	# Connect Player
	var player = level_root.get_node("Player")
	player.died.connect(_on_player_died)
	$HUD.set_player(player)
	
	# Connect Exit
	var exit = level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)

#################
# Signal Handlers
#################
func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		level += 1
		call_deferred("_load_level", level)


func _on_player_died() -> void:
	# Pause for 1 second before resetting everything
	await get_tree().create_timer(1.0).timeout
	await hud.fade(1.0)
	PlayerStats.reset()
	level = 1
	_load_level(level)
	await hud.fade(0.0)
