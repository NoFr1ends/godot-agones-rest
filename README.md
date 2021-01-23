# godot-agones-rest
A simple wrapper around the agones rest interface.

It is recommended to use GRPC client instead of the rest client. 
This repository is only for testing purposes and users who do not want to deal with GDnative addons

## Installation
Copy the ``Agones.gd`` to your project and configure it as a singleton.

## Example
Mark the server as ready:
```gdscript
var agones = $"/root/Agones"
if not yield(agones.ready(), "completed"):
	print("Failed to mark server as ready")
	# retry ready
```
