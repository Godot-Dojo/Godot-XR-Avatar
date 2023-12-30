extends XRToolsSceneBase


# Called when the node enters the scene tree for the first time.
func _ready():
	super()

	# Ensure networing is disabled
	multiplayer.multiplayer_peer = null

	# Subscribe to network signals
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	$Map/LobbyMenu.connect_scene_signal("server_started", _on_server_started)


func _on_connected_to_server() -> void:
	# Transition to the arena when we connect to a remote server
	load_scene("res://scenes/network/arena/network_arena.tscn")


func _on_server_started() -> void:
	# Transition to the arena when the server is started
	load_scene("res://scenes/network/arena/network_arena.tscn")
