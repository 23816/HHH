extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -350.0
const GRAVITY = 700.0  # 可以设定为你游戏中的重力值

var jump_count = 0
var max_jumps = 2

var start_position = Vector2(1, 1)
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	position = start_position  # 确保角色开始时的位置正确

func _physics_process(delta):
	# 处理重力
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		# 重置跳跃计数器
		jump_count = 0

		if abs(velocity.x) > 2:
			anim.play("run")
		else:
			anim.play("idle")

	# 处理角色翻转
	if velocity.x < 0:
		anim.flip_h = true
	elif velocity.x > 0:
		anim.flip_h = false

	# 处理跳跃
	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jumps:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		anim.play("jump")

	# 获取输入方向并处理移动/减速
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		# 平滑减速
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	move_and_slide()

	# 处理重生
	if position.y > 1000:
		respawn()

func respawn():
	position = start_position
	velocity = Vector2.ZERO  # 重置速度
	jump_count = 0  # 重置跳跃计数
