extends KinematicBody2D

const UP = Vector2(0,-1) # This allows us to discover the floor

var movement = Vector2()
export var speed = 250
export var jumpPower = -400
export var jetpackPower = -150
var jetpackJuice = 100   #gas for the jetpack

var Bullet = preload("res://World Tiles/Bullet.tscn")
var bulletCount = 5
export var maxBulletCount = 5
onready var shotcount = $shotcount
var boom = preload("res://boom.tscn")

export var maxHealth = 5
var health = 5

func _ready():
	bulletCount = maxBulletCount
	health = maxHealth

func _physics_process(delta):
	movement.y += 10
	shotcount.set_text(bulletCount as String)
	
	if Input.is_action_pressed("ui_right"):
		movement.x = speed
	elif Input.is_action_pressed("ui_left"):
		movement.x = -speed
	else:
		movement.x = 0
		
	
	if Input.is_action_pressed("jetpack"):
		if jetpackJuice > 0:	#whilst there is gas in the jetpack
			movement.y = jetpackPower
			jetpackJuice -= 1
		
	elif jetpackJuice < 100: #when you take off the button will add up until gets to 100
			jetpackJuice += 2
		
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			movement.y = jumpPower
		
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	if Input.is_action_just_pressed("reload"):
		reloadGun()

	if Input.is_action_just_pressed("damage_health"):
		health -= 1
		if health < 1:
			explode()
			visible = false
	
	move_and_slide(movement, UP)
	
	
	$hand.look_at(get_global_mouse_position())
	$gun.look_at(get_global_mouse_position())
	
func shoot():
	if bulletCount > 0:
	
		var b = Bullet.instance()
	
		var peuwSound = $peuw
		peuwSound.play()
	
		b.bulletInfo($gun/Muzzle.global_position,$gun.rotation)
		get_parent().add_child(b)
		bulletCount = bulletCount - 1
	else:
		var chink = $chink
		chink.play()
		pass
	
	
func reloadGun():
	bulletCount = maxBulletCount
	var gunreload = $gunreload
	gunreload.play()
	
#need to do here	
func explode():
	var deathBomb = boom.instance()
	deathBomb.position = self.position
	deathBomb.position.y -= 20
	get_parent().add_child(deathBomb)
	deathBomb.emitting = true
