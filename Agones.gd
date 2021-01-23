extends Node

var agones_port = "9358"

func _ready():
	if OS.has_environment("AGONES_SDK_HTTP_PORT"):
		agones_port = OS.get_environment("AGONES_SDK_HTTP_PORT")
	else:
		printerr("No agones sdk port specified, falling back to default local port")

func ready():
	var request = HTTPRequest.new()
	add_child(request)
	
	request.request("http://localhost:" + agones_port + "/ready", ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, JSON.print({}))
	var result = yield(request, "request_completed")
	request.queue_free()
	
	if result[1] != 200:
		printerr("Failed to mark server as ready")
		return false
		
	return true

func health():
	var request = HTTPRequest.new()
	add_child(request)
	
	request.request("http://localhost:" + agones_port + "/health", ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, JSON.print({}))
	var result = yield(request, "request_completed")
	request.queue_free()
	
	if result[1] != 200:
		printerr("Failed to send health event")
		return false
		
	return true
	
func reserve(seconds):
	var request = HTTPRequest.new()
	add_child(request)
	
	request.request("http://localhost:" + agones_port + "/reserve", ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, JSON.print({"seconds": seconds}))
	var result = yield(request, "request_completed")
	request.queue_free()
	
	if result[1] != 200:
		printerr("Failed to reserve gameserver")
		return false
		
	return true
	
func allocate():
	var request = HTTPRequest.new()
	add_child(request)
	
	request.request("http://localhost:" + agones_port + "/allocate", ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, JSON.print({}))
	var result = yield(request, "request_completed")
	request.queue_free()
	
	if result[1] != 200:
		printerr("Failed to mark server as allocated")
		return false
		
	return true

func shutdown():
	var request = HTTPRequest.new()
	add_child(request)
	
	request.request("http://localhost:" + agones_port + "/shutdown", ["Content-Type: application/json"], false, HTTPClient.METHOD_POST, JSON.print({}))
	var result = yield(request, "request_completed")
	request.queue_free()
	
	if result[1] != 200:
		printerr("Failed to mark server as shutdown")
		return false
		
	return true
	
func gameserver():
	var request = HTTPRequest.new()
	add_child(request)
	
	request.request("http://localhost:" + agones_port + "/gameserver", ["Content-Type: application/json"], false, HTTPClient.METHOD_GET)
	var result = yield(request, "request_completed")
	request.queue_free()
	
	if result[1] != 200:
		printerr("Failed to retrieve gameserver configuration")
		return false
		
	return JSON.parse(result[3].get_string_from_utf8()).result
