/datum/job/assistant
	total_positions = 0

/datum/map/roleplay
	allowed_jobs = list(
	/datum/job/assistant,
	/datum/job/base,
	/datum/job/base/second
	)

/mob/living/carbon/human/proc/set_language(var/language_name)
	if(aspect_chosen(/datum/aspect/one_word))
		return
	remove_language(LANGUAGE_GALCOM)
	var/datum/language/L = null
	add_language(language_name)
	L = all_languages[language_name]

	if(L)
		default_language = L

/datum/job/assistant
	title = "REDACTED"
	hide_at_roundstart = TRUE
	hide_at_latejoin = TRUE
	total_positions = 0
	spawn_positions = 0