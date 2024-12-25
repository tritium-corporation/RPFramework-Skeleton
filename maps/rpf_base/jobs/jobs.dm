/datum/job/base
	title = "Base Occupation"
	department = "Security"
	department_flag = SEC
	total_positions = -1
	create_record = FALSE
	account_allowed = FALSE
	social_class = SOCIAL_CLASS_MIN
	has_email = FALSE
	latejoin_at_spawnpoints = TRUE
	can_be_in_squad = TRUE
	announced = TRUE

	//Baseline skill defines
	medical_skill = 10
	surgery_skill = 10
	ranged_skill = 10
	engineering_skill = 10
	melee_skill = 10
	//Gun skills
	auto_rifle_skill = 10
	semi_rifle_skill = 10
	sniper_skill = 10
	shotgun_skill = 10
	lmg_skill = 10
	smg_skill = 10

/datum/job/basesecond
	title = "Base Occupation Second"
	department = "Security"
	department_flag = SEC
	total_positions = -1
	create_record = FALSE
	account_allowed = FALSE
	social_class = SOCIAL_CLASS_MIN
	has_email = FALSE
	latejoin_at_spawnpoints = TRUE
	can_be_in_squad = TRUE
	announced = TRUE

	//Baseline skill defines
	medical_skill = 10
	surgery_skill = 10
	ranged_skill = 10
	engineering_skill = 10
	melee_skill = 10
	//Gun skills
	auto_rifle_skill = 10
	semi_rifle_skill = 10
	sniper_skill = 10
	shotgun_skill = 10
	lmg_skill = 10
	smg_skill = 10

	// EXAMPLE of an on-equip VV
/*
	equip(var/mob/living/carbon/human/H)
		..()
		H.add_stats(rand(12,17), rand(10,16), rand(8,12))
		H.fully_replace_character_name("Pvt. [H.real_name]")
		H.set_language(LANGUAGE_RED)
		H.assign_random_quirk()
		if(announced)
			H.say(";Soldier reporting for duty!")
		H.set_hud_stats()
*/

// Landmark start example
/obj/effect/landmark/start/base_occupation
	name = "Base Occupation"

/mob/proc/voice_in_head(message)
	to_chat(src, "<i>...[message]</i>")

GLOBAL_LIST_INIT(lone_thoughts, list(
		"Why are we still here, just to suffer?",
		"We fight to win, and that's all that matters.",
		"Why we don't get any more reinforcements?",
		"We have not gotten any orders from central command in months...",
		"Did something happened while we were fighting in trenches?",
		"Is there any reason to keep fighting?",
		"Did anyone notice when ash started to fall?",
		"It's middle of summer. Why it's so cold?",
		"Greg died last night.",
		"I do not want to die.",
		"I miss my loved ones.",
		"There is no hope... anymore...",
		"Is there actually a central command?",
		"Is any of this real?",
		"My teeth hurt.",
		"I am not ready to die.",
		"Who keeps dropping the artillery?",
		"I don't remember joining the military..."))

/mob/living/proc/assign_random_quirk()
	if(prob(75))//75% of not choosing a quirk at all.
		return
	var/list/random_quirks = list()
	for(var/thing in subtypesof(/datum/quirk))//Populate possible quirks list.
		var/datum/quirk/Q = thing
		random_quirks += Q
	if(!random_quirks.len)//If there's somewhow nothing there afterwards return.
		return
	var/datum/quirk/chosen_quirk = pick(random_quirks)
	src.quirk = new chosen_quirk
	to_chat(src, "<span class='bnotice'>I was formed a bit different. I am [quirk.name]. [quirk.description]</span>")
	switch(chosen_quirk)
		if(/datum/quirk/cig_addict)
			var/datum/reagent/new_reagent = new /datum/reagent/nicotine
			src.reagents.addiction_list.Add(new_reagent)
		if(/datum/quirk/alcoholic)
			var/datum/reagent/new_reagent = new /datum/reagent/ethanol
			src.reagents.addiction_list.Add(new_reagent)
