extends Node2D

var waveIndex = 0
var spawnIndex = 0
var wavePowerLeft = 0
var isGameOver = false

const WaveDurationSec = 30

@onready var waveLabel = $CanvasLayer/Label

@export var Enemies: Array[EnemyValue]
@export var Waves: Array[Wave]
@export var canRestart = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_start()

func wave_start():
	waveLabel.text = "Wave " + str(waveIndex + 1)
	$Player.heal()
	$Timer.wait_time = Waves[waveIndex].spawnPeriod_s
	$Timer.start()
	spawnIndex = 0
	wavePowerLeft = Waves[waveIndex].power
	$AnimationPlayer.play("wave_start")

func wave_stop():
	for bubble in get_tree().get_nodes_in_group("bubble"):
		bubble.queue_free()
	$Timer.stop()

func _on_timer_timeout() -> void:
	var sequence =  Waves[waveIndex].sequence
	var enemyIndex = sequence[spawnIndex]
	var enemyEntry = Enemies[enemyIndex]
	if enemyEntry.value <= wavePowerLeft:
		var newEnemy = $Spawner.spawn(enemyEntry.scene) as Enemy
		# reduce spaeed of enemies placed up and down
		# since there is less time to shoot them down
		var speedFactor = 0.5 + 0.5 * abs(Vector2.RIGHT.dot(newEnemy.global_position.normalized()))
		newEnemy.SPEED *= speedFactor
		
		spawnIndex = (spawnIndex + 1) % sequence.size()
		wavePowerLeft -= enemyEntry.value
		newEnemy.tree_exited.connect(_enemy_died)
	else:
		$Timer.stop()

func _enemy_died():
	if get_tree() == null:
		return
	if get_tree().get_nodes_in_group("enemy").is_empty():
		if not isGameOver:
			$AnimationPlayer.play("show_powerup")


func _on_player_game_over() -> void:
	isGameOver = true
	$AnimationPlayer.play("game_over")

func _unhandled_input(event: InputEvent) -> void:
	if canRestart and Input.is_action_just_pressed("trigger"):
		get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_powerup_menu_done() -> void:
	$AnimationPlayer.play("on_powerup_done")
	waveIndex += 1
	if waveIndex >= Waves.size():
		print("You win!!")
		get_tree().quit()
		return


func _on_player_damaged() -> void:
	$Camera2D/CameraShake.shake()
