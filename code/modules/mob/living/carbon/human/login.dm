/mob/living/carbon/human/Login()
	..()
	update_hud()
	if(species) species.handle_login_special(src)
	set_hud_stats(8)
	return