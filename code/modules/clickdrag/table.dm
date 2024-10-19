/obj/structure/table/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob, params)
	. = ..()
	if(istype(O, /obj/item) || istype(O, /obj/structure))
		if(!CanPhysicallyInteract(user))
			return
		if((!(istype(O, /atom/movable)) || O.anchored || !Adjacent(user) || !Adjacent(O) || !user.Adjacent(O)))
			return ..()
		if(params)
			var/list/mouse_control = params2list(params)
			var/p_x = 0
			var/p_y = 0
			if(mouse_control["icon-x"])
				p_x = text2num(mouse_control["icon-x"])-16
			if(mouse_control["icon-y"])
				p_y = text2num(mouse_control["icon-y"])-16

			if(get_turf(O) != get_turf(src))
				step_towards(O, src)
			var/time
			switch(isitem(O))
				if(FALSE) time = 2 SECONDS
				else time = 1 SECOND
			animate(O, time, easing = SINE_EASING, pixel_x = p_x, pixel_y = p_y)
			if(ishuman(user) && !isitem(O))
				var/mob/living/carbon/human/H = user
				H.adjustStaminaLoss(rand(25,35))