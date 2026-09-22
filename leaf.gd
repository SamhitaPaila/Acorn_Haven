extends Area2D

var speed = 120
var drift_speed = 40
var drift_time = 0.0
var start_x = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	start_x = position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta
	drift_time += delta
	position.x = start_x + sin(drift_time * 1.5) * 50.0
	if position.y > 750:
		queue_free()
