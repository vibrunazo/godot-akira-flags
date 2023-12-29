extends Object

class_name Countries

## list of all country ids
static var ids = [
	'brazil',
	'japan',
]

## Returns the Texture2D for the flag of a given country id. Null if not found.
static func get_flag(id: String) -> Texture2D:
	if not ids.has(id): return null
	var path: String = "res://countries/flags/%s.png" % id
	var tex: Texture2D = load(path)
	return tex
	
## Returns the AudioStream for the spoken audio of the name of a given country id. Null if not found.
static func get_audio(id: String) -> AudioStream:
	if not ids.has(id): return null
	var path: String = "res://countries/audio/%s.ogg" % id
	var res: AudioStream = load(path)
	return res

## Returns the CountryData resource for a given country id
static func get_data(id: String) -> CountryData:
	if not ids.has(id): return null
	var path: String = "res://countries/res/%s.tres" % id
	var res: CountryData = load(path)
	return res
