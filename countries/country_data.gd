extends Resource

class_name CountryData

## The id used to identify the country. Should match the country filename for flag images and audio.
@export var id: String = ''
## The text to display to represent this country
@export var display_name: String = ''
## Pronoun that will be used to refer to this country
@export var pronoun: PRONOUN = PRONOUN.MALE

## Pronouns that can be used to refer to a country
enum PRONOUN {
	MALE,
	FEMALE,
	MALE_PLURAL,
	FEMALE_PLURAL,
}
