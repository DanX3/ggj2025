extends Node2D

var waveIndex = 0
var spawnIndex = 0
var wavePowerLeft = 0
var enemiesLeft = 0

const WaveDurationSec = 30

@onready var waveLabel = $CanvasLayer/Label

@export var Enemies: Array[EnemyValue]
@export var Waves: Array[Wave]
@export var canRestart = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("wave_start")

func wave_start():
	$Player.heal()
	$Timer.start()
	spawnIndex = 0
	wavePowerLeft = Waves[waveIndex].power
	enemiesLeft = 0

func wave_stop():
	$Timer.stop()

func _on_timer_timeout() -> void:
	var sequence =  Waves[waveIndex].sequence
	var enemyIndex = sequence[spawnIndex]
	var enemyEntry = Enemies[enemyIndex]
	if enemyEntry.value <= wavePowerLeft:
		var newEnemy = $Spawner.spawn(enemyEntry.scene)
		spawnIndex = (spawnIndex + 1) % sequence.size()
		wavePowerLeft -= enemyEntry.value
		enemiesLeft += 1
		newEnemy.tree_exited.connect(_enemy_died)
	else:
		$Timer.stop()

func _enemy_died():
	enemiesLeft -= 1
	if enemiesLeft == 0:
		print("wave finished")
		$AnimationPlayer.play("show_powerup")


func show_powerup():
	pass


func _on_player_game_over() -> void:
	$AnimationPlayer.play("game_over")

func _unhandled_input(event: InputEvent) -> void:
	if canRestart and Input.is_action_just_pressed("trigger"):
		get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_powerup_menu_done() -> void:
	waveIndex += 1
	if waveIndex >= Waves.size():
		print("You win!!")
		get_tree().quit()
		return
		
	wave_start()
