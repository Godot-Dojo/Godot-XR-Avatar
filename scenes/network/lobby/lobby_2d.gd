extends Control


signal server_started


func _ready() -> void:
	# Drop existing network
	multiplayer.multiplayer_peer = null


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_host_button_pressed() -> void:
	# Create the server
	var port := roundi(%HostPort.value)
	var peer := ENetMultiplayerPeer.new()
	var err := peer.create_server(port)
	if err != OK:
		print("Error ", err, " creating server")
		return

	# Use the server
	multiplayer.multiplayer_peer = peer
	server_started.emit()


func _on_join_button_pressed() -> void:
	# Create the client
	var host := str(%JoinHost.text)
	var port := roundi(%JoinPort.value)
	var peer := ENetMultiplayerPeer.new()
	var err := peer.create_client(host, port)
	if err != OK:
		print("Error ", err, " creating client")
		return

	# Use the client - lobby loads arena on server-connect
	multiplayer.multiplayer_peer = peer
