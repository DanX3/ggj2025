extends Node2D

var waveIndex = 0
var spawnIndex = 0
var wavePowerLeft = 0
var enemiesLeft = 0

const WaveDurationSec = 30

@export var Enemies: Array[EnemyValue]

@export var Waves: Array[Wave]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_start()

func wave_start():
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
	
