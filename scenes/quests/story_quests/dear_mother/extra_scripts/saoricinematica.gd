extends CharacterBody2D

@export_file("*.tscn") var ruta_player_real: String 

@export var cambiar_al_inicio: bool = false

func _ready() -> void:
	if cambiar_al_inicio:
		convertir_a_jugador()

func convertir_a_jugador() -> void:
	if ruta_player_real == "":
		print("¡Error! No has asignado la ruta del Player jugable en el Inspector.")
		return
		
	var escena_player: PackedScene = load(ruta_player_real) as PackedScene
	
	if escena_player:
		var nuevo_player: Player = escena_player.instantiate() as Player
		
		nuevo_player.name = "Player" 
		nuevo_player.global_position = global_position
		
		get_parent().add_child(nuevo_player)
		
		if nuevo_player.has_node("Camera2D"):
			var nueva_camara: Camera2D = nuevo_player.get_node("Camera2D") as Camera2D
			nueva_camara.make_current()
			nueva_camara.reset_smoothing()
		
		nuevo_player.set_physics_process(true)
		nuevo_player.set_process_input(true)
		
		queue_free()
