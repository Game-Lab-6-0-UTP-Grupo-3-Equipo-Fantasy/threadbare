extends Area2D

@export var velocidad: float = 400.0 
@export var objetivo_path: NodePath 
@export var persiguiendo: bool = false 

var jugador: Node2D
var juego_terminado: bool = false 

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if objetivo_path:
		jugador = get_node(objetivo_path) as Node2D
	anim_sprite.play("walk")

func _process(delta: float) -> void:
	if juego_terminado:
		return

	if jugador and not is_instance_valid(jugador):
		jugador = null

	var player_real = get_tree().get_first_node_in_group("player") as Node2D
	
	if player_real and jugador != player_real:
		jugador = player_real
		persiguiendo = true

	if not jugador or not persiguiendo:
		return
		
	var direccion: Vector2 = global_position.direction_to(jugador.global_position)
	global_position += direccion * velocidad * delta
	
	if direccion.x != 0:
		anim_sprite.flip_h = direccion.x < 0

func _on_body_entered(body: Node2D) -> void:
	if not juego_terminado and body.name == "Player":
		juego_terminado = true 
		anim_sprite.play("idle")
		
		body.set_physics_process(false)
		body.set_process_input(false)
		
		var tween: Tween = create_tween()
		tween.tween_property(body, "modulate", Color(1, 0, 0, 1), 0.2)
		tween.tween_property(body, "modulate", Color(1, 1, 1, 0), 0.5)
		
		# 3. Esperamos a que la animación de humo termine
		await get_tree().create_timer(1.0).timeout
		
		var escena_actual: String = get_tree().current_scene.scene_file_path
		SceneSwitcher.change_to_file_with_transition(
			escena_actual,
			"", 
			Transition.Effect.FADE,
			Transition.Effect.FADE
		)
