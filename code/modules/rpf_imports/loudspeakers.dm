/obj/structure/announcementmicrophone
	name = "captain's microphone"
	desc = "Should work right as rain.."
	icon = 'icons/obj/device.dmi'
	icon_state = "mic"
	anchored = TRUE
	var/id = 0 // This is for the ID system, it allows us to have multiple of these in a map.
	// IMPORTANT VARS GO UP HERE ^^

	var/broadcast_start_sound = 'sound/effects/broadcasttest.ogg'
	var/broadcast_start_sound_volume = 85

	var/broadcast_end_sound = 'sound/effects/broadcasttestend.ogg' //"feedbacknoise"
	var/broadcast_end_sound_volume = 85

	var/list/additional_talk_sound = list('sound/effects/radio1.ogg', 'sound/effects/radio2.ogg', 'sound/effects/radio3.ogg', 'sound/effects/radio4.ogg')
	var/additional_talk_sound_vary = 0.5
	var/additional_talk_sound_volume = 75

	var/speakerstyle = "boldannounce" // h3 + warning makes it CURLY (disco freaky) :>
	var/textstyle = "staffwarn"

	var/broadcasting  = FALSE
	var/listening = FALSE
	var/broadcast_range = 8

	var/cooldown // Cooldown for inputs

/obj/structure/announcementmicrophone/attack_hand(mob/user)
	. = ..()
	if(!cooldown)
		if(!broadcasting)
			broadcasting = TRUE
			listening = TRUE
			set_cooldown(6 SECONDS)
			for(var/obj/structure/announcementspeaker/s in world)
				if(id == s.id)
					soundoverlay(s, newplane = EFFECTS_ABOVE_LIGHTING_PLANE)
					playsound(s.loc, broadcast_start_sound, broadcast_start_sound_volume, 0)
					//s.overlays += image('icons/obj/structures.dmi', icon_state = "rpfsafe") // call a proc on the speakers in the future to update icon?
					// dunno if we wanna make it update icon at all

		else
			broadcasting = FALSE
			listening = FALSE
			set_cooldown(20 SECONDS)
			for(var/obj/structure/announcementspeaker/s in world)
				if(id == s.id)
					playsound(s.loc, broadcast_end_sound, broadcast_end_sound_volume, 0)
					s.overlays.Cut()
					soundoverlay(s, newplane = EFFECTS_ABOVE_LIGHTING_PLANE)
		playsound(src.loc, "button", 75, 1)
	update_icon()

/obj/structure/announcementmicrophone/RightClick(mob/user)
	. = ..()
	if(broadcasting)
		if(listening)
			listening = FALSE
		else
			listening = TRUE
		playsound(src.loc, "button", 75, 1)
		update_icon()

/obj/structure/announcementmicrophone/hear_talk(mob/living/M as mob, msg, var/verb="says", datum/language/speaking=null)
	if(broadcasting)
		if(listening)
			if(M in range(2, get_turf(src)))
				var/ending = copytext(msg, -1)
				if(!(ending in PUNCTUATION))
					msg = "[msg]."

				msg = replacetext(msg, "/", "")
				msg = replacetext(msg, "~", "")
				msg = replacetext(msg, "@", "")
				msg = replacetext(msg, " i ", " I ")
				msg = replacetext(msg, " ive ", " I've ")
				msg = replacetext(msg, " im ", " I'm ")
				msg = replacetext(msg, " u ", " you ")
				msg = add_shout_append(capitalize(msg))//So that if they end in an ! it gets bolded
				var/spkrname = ageAndGender2Desc(M.age, M.gender)
				msg = replace_characters(msg, list("&#34;" = "\""))
				transmitmessage(M.GetVoice(), msg, verb)
/*
/obj/structure/announcementmicrophone/see_emote(mob/M as mob, text, var/emote_type)
	if(broadcasting)
		if(listening)
			if(emote_type != AUDIBLE_MESSAGE)
				return
			if(M in range(2, get_turf(src)))
				var/start_pos = findtext(text, "</B>") + length("</B>")
				var/output = copytext(text, start_pos)
				output = trim(output)
				var/spkrname = ageAndGender2Desc(M.age, M.gender)
				transmitemote(spkrname, output)
				return // Not sure how to fix it. Right now it spits out this: Young Woman <B>Arb. Mcintosh Willey</B> screams!
			else
				return
*/
/obj/structure/announcementmicrophone/proc/transmitmessage(spkrname, msg, var/verbtxt)
	var/list/mobstosendto = list()
	for(var/obj/structure/announcementspeaker/s in world)
		if(id == s.id)
			for(var/mob/living/carbon/m in view(world.view + broadcast_range, get_turf(s)))
				if(!m.stat == UNCONSCIOUS || !m.is_deaf() || !m.stat == DEAD)
					mobstosendto |= m
					soundoverlay(s, newplane = EFFECTS_ABOVE_LIGHTING_PLANE)
			if(additional_talk_sound)
				playsound(get_turf(s), pick(additional_talk_sound), additional_talk_sound_volume, additional_talk_sound_vary)
	for(var/mob/living/carbon/m in mobstosendto)
		to_chat(m,"<h2><span class='[speakerstyle]'>[spkrname] [verbtxt], \"<span class='[textstyle]'>[msg]</span>\"</span></h2>")

/obj/structure/announcementmicrophone/proc/transmitemote(spkrname, emote)
	var/list/mobstosendto = list()
	for(var/obj/structure/announcementspeaker/s in world)
		if(id == s.id)
			for(var/mob/living/carbon/m in view(world.view + broadcast_range, get_turf(s)))
				if(!m.stat == UNCONSCIOUS || !m.is_deaf() || !m.stat == DEAD)
					mobstosendto |= m
					soundoverlay(s, newplane = EFFECTS_ABOVE_LIGHTING_PLANE)
	for(var/mob/living/carbon/m in mobstosendto)
		to_chat(m,"<h2><span class='[speakerstyle]'>[spkrname] [emote]</h2>")

/*
/obj/structure/announcementmicrophone/proc/speakmessage(var/text)
	var/turf/die = get_turf(handset)
	die.audible_message("\icon[handset] [text]",hearing_distance = 2)// TEMP HACKY FIX!!
*/

/obj/structure/announcementmicrophone/proc/set_cooldown(var/delay)
	cooldown = 1
	spawn(delay)
		if(cooldown)
			cooldown = 0

/obj/structure/announcementmicrophone/update_icon()
	. = ..()
	overlays.Cut()
	if(broadcasting && !listening)
		overlays += image(icon=src.icon, icon_state = "mic_silent")
	else if(broadcasting && listening)
		overlays += image(icon=src.icon, icon_state = "mic_on")

/obj/structure/announcementspeaker/
	name = "Loudspeaker"
	icon = 'icons/obj/device.dmi'
	icon_state = "battererburnt"
	anchored = TRUE
	var/id = 0

/obj/structure/announcementspeaker/red
    id = RED_TEAM

/obj/structure/announcementspeaker/blue
    id = BLUE_TEAM

/obj/structure/announcementmicrophone/red
    id = RED_TEAM

/obj/structure/announcementmicrophone/blue
    id = BLUE_TEAM