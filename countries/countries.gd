extends Object

class_name Countries

## list of all country ids
static var ids = [
	'argentina',
	'australia',
	'belgium',
	'brazil',
	'cameroon',
	'canada',
	'chile',
	'china',
	'colombia',
	'costarica',
	'dominican_republic',
	'france',
	'germany',
	'guyana',
	'hungary',
	'india',
	'indonesia',
	'israel',
	'italy',
	'japan',
	'kiribati',
	'lebanon',
	'malaysia',
	'mexico',
	'newzeland',
	'nigeria',
	'poland',
	'portugal',
	'somalia',
	'southkorea',
	'southafrica',
	'spain',
	'thailand',
	'turkey',
	'uk',
	'ukraine',
	'uruguay',
	'us',
	'vietnam',
	'wales',
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

## Returns the pronoun used to refer to the country of given id.
static func get_pronoun(id: String) -> CountryData.PRONOUN:
	if not ids.has(id): return CountryData.PRONOUN.MALE
	var path: String = "res://countries/res/%s.tres" % id
	var res: CountryData = load(path) as CountryData
	return res.pronoun

## Returns the AudioStream for the spoken audio of the PRONOUN of a given country id. Null if not found.
static func get_pronoun_audio(id: String) -> AudioStream:
	if not ids.has(id): return null
	var pronoun: CountryData.PRONOUN = get_pronoun(id)
	var path: String = "res://games/ballgame/audio/do.ogg"
	if pronoun == CountryData.PRONOUN.FEMALE:
		path = "res://games/ballgame/audio/da.ogg"
	var res: AudioStream = load(path)
	return res
