extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed: int = 400
var screen_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	# スクリーンのサイズを取得
	screen_size = get_viewport_rect().size


# 毎フレーム呼び出される
# delta は [フレームの長さ - 前のフレームが完了するまでに要した時間]
# これによってフレームレートの変動の影響を受けなくなる
func _process(delta):
	# プレイヤー入力方向ベクトル
	var velocity: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	# length() -> ベクトルの長さ（絶対値）
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	position += velocity * delta
	# プレイヤー座標が画面の最小値または最大値の範囲外に出ないように抑える
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	# 動いている向きによってアニメーション画像を変える
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		# 斜め移動の場合もこの分岐に入る（横移動のアニメーションが優先される）ので、その場合は縦が反転しないようにする
		$AnimatedSprite.flip_v = false
		# xが負（左を向いている）なら画像を左右反転させる
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		# yが正（下を向いている）なら、画像を上下反転させる
		$AnimatedSprite.flip_v = velocity.y > 0
