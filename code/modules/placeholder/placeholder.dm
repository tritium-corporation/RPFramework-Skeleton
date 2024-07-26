// NOTES FOR STUFF:

	// 1. THE CARGO MACHINE DOESN'T KNOW IF IT DOESNT HAVE PADS FOR SOME REASON?? I TRY TO MAKE IT ERROR OUT IF THERE'S NO PADS ON THE MAP BUT IT STILL ACTS AS IF IT DID IT SUCCESSFULLY..
		// ^^ Still struggling with this one.

	// 2. THE CARGO MACHINE DOESN'T KNOW HOW TO SPAWN THE ITEMS ON THE PADS. I TRIED TO USE SOME VOODOO MOLOCH MAGIC BUT IT DOESN'T WORK. // Fixed
	// 3. WE GOTTA ADD A BASIC IMPLEMENTATION OF CARGO BUYING, TRY TO NOT TOUCH THE LIST? IT SHOULD WORK THE WAY IT DOES THO!! :sob: // Done
	// Fixed the useability shit dw

/obj/structure/closet/crate/scuffedcargo/
	name = "TEST CRATE #1"
	icon = 'icons/obj/storage.dmi'
	icon_state = "securecrate"
	icon_opened = "securecrateopen"
	icon_closed = "securecrate"

/obj/structure/closet/crate/scuffedcargo/New()
	var/list/will_contain = WillContain()
	if(will_contain)
		create_objects_in_loc(src, will_contain)



/obj/structure/closet/crate/scuffedcargo/shotguns
	name = "Surplus shotgun ammunition crate"
	desc = "I LOVE TEST CRATES!!"
/obj/structure/closet/crate/scuffedcargo/redcrate4/shotguns/WillContain()
	return list(
	)




/obj/machinery/kaos/cargo_machine
	name = "R.E.D. Cargo Machine"
	desc = "You use this to buy shit."
	icon = 'icons/obj/old_computers.dmi'
	icon_state = "cargo_machine"
	anchored = TRUE
	density = TRUE
	var/credits
	var/loggedin = FALSE
	var/list/INPUTS = list("BROWSE CATALOG", "SELL PRODUCTS", "WITHDRAW MONEY", "CONTACT MIDDLE MANAGEMENT", "RECONNECT PADS", "CHECK BALANCE", "LOGOUT", "CANCEL")
	var/list/pads
	var/id
	var/withdraw_amount
	var/line_input
	var/cooldown
	var/useable = TRUE
	use_power = 1
	idle_power_usage = 300
	active_power_usage = 300
	clicksound = "keyboard"
	// When adding products, use this format
	// list("name" = "name in input list", "price" = price, "category" = "What category", "path" = object path),
	var/list/products = list(
		list("name" = "Dev shotgun crate", "price" = 20, "category" = "Weaponry", "path" = /obj/structure/closet/crate/scuffedcargo/shotguns), // Low price for basic pistols
	)

	var/list/categories = list("Consumables", "Weaponry", "Wearable", "Ammunition", "Miscellaneous")

/obj/machinery/kaos/cargo_machine/proc/pingpads()
	for(var/obj/structure/cargo_pad/pad in pads)
		pad.pingpad()
		if(pads.len > 4)
			playsound(pad.loc,'sound/machines/rpf/UImsg.ogg', 10, 0)
		else
			playsound(pad.loc,'sound/machines/rpf/UImsg.ogg', 20, 0)

/obj/machinery/kaos/cargo_machine/proc/playpadsequence(mob/user)
	useable = FALSE
	reconnectpads()
	playsound(src.loc, "sound/machines/rpf/barotraumastuff/UI_labelselect.ogg", 75, 0.2) // IDEA: MAKE IT A PROC!! PLEASE?? MAYBE???!! // I did it, past me.
	to_chat(user, "\icon[src]RE-ESTABLISHING CONNECTION... PLEASE WAIT..")
	spawn(2 SECONDS)
		playsound(src.loc, 'sound/machines/rpf/beepsound1.ogg', 60, 0)
		pinglight()
		spawn(2 SECONDS)
			useable = TRUE
			set_light(3, 3,"#ebc683")
			if (pads.len < 0 | pads.len == null | pads.len == 0) // I WANT TO MAKE SURE IM SANE. SO I DID IT THREE TIMES.
				set_light(3, 3,"#ebc683")
				to_chat(src, "\icon[src]ERROR. NO CARGO PADS LOCATED. CONTACT R.E.D. ADMINISTRATOR.")
				playsound(src.loc, 'sound/machines/rpf/harshdeny.ogg', 250, 0.5)
				to_chat(user, "\icon[src]AMOUNT OF LINKED PADS: [pads.len]")
			else
				playsound(src.loc, 'sound/machines/rpf/consolebeep.ogg', 250, 0.5)
				to_chat(src, "\icon[src]LINK ESTABLISHED SUCCESSFULLY.")
				speak("LINK ESTABLISHED SUCCESSFULLY. RETRY OPERATION.")
				to_chat(user, "\icon[src]AMOUNT OF LINKED PADS: [pads.len]")

/obj/machinery/kaos/cargo_machine/proc/get_objects_on_turf(turf/T)
	// Initialize an empty list to hold the objects
	var/list/objects_on_turf = list()

	// Loop through the contents of the turf
	for (var/obj/A in T)
		// Add each object to the list
		objects_on_turf += A

	// Return the list of objects
	return objects_on_turf

/obj/machinery/kaos/cargo_machine/proc/get_dense_objects_on_turf(turf/T)
	// Initialize an empty list to hold the objects
	var/list/dense_objects_on_turf = list()

	// Loop through the contents of the turf
	for (var/obj/A in T)
		if(A.density | istype(A, /obj/structure/closet) | istype(A, /mob/living/carbon))
		// Add each object to the list
			dense_objects_on_turf += A

	// Return the list of objects
	return dense_objects_on_turf

/obj/machinery/kaos/cargo_machine/proc/pinglight()
	spawn(0.1 SECONDS)
		set_light(3, 3,"#f0e2c9")
		pingpads()
		spawn(0.1 SECONDS)
			set_light(1, 1,"#110f0c")

/obj/machinery/kaos/cargo_machine/proc/resetlightping()
	spawn(0.12 SECONDS)
		set_light(4, 4,"#fffdfc")
		spawn(0.1 SECONDS)
			set_light(3, 3,"#ebc683")

/obj/machinery/kaos/cargo_machine/proc/get_people_on_turf(turf/T)
	// Initialize an empty list to hold the objects
	var/list/people_on_turf = list()

	// Loop through the contents of the turf
	for (var/mob/living/carbon/A in T)
		// Add each object to the list
		people_on_turf += A

	// Return the list of objects
	return people_on_turf

/obj/machinery/kaos/cargo_machine/proc/speak(var/message)
	var/list/hearme
	if (!message)
		return
	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>The Cargo Machine</span> beeps, \"[message]\"</span>", 2)
		hearme += O
	return

/obj/machinery/kaos/cargo_machine/proc/reconnectpads()
	pads = list()
	for(var/obj/structure/cargo_pad/pad in world)
		if (pad.id == src.id && !pad.broken)
			pads += pad

/obj/machinery/kaos/cargo_machine/New()
	credits = rand(300, 500) // temporary(?)
	reconnectpads()

/obj/machinery/kaos/cargo_machine/attackby(obj/item/C as obj, mob/user as mob)
	if(istype(C, /obj/item/spacecash))
		var/obj/item/spacecash/dolla = C
		if(dolla.worth <= 0)
			to_chat(user, "\icon[src]You cannot insert that into the machine.")
			playsound(src.loc, 'sound/machines/rpf/denybeep.ogg', 100, 0.5)
		else
			to_chat(user, "\icon[src]You insert [C.name] into the machine.")
			playsound(user.loc, 'sound/machines/rpf/audiotapein.ogg', 50, 0.4)
			src.credits += dolla.worth
			qdel(C)
	if(istype(C, /obj/item/stack/teeth/human)) // FUCK YOU SCAVS, YOU DID TIS TO ME
		var/obj/item/stack/teeth/human/toof = C
		if(toof.amount <= 0)
			qdel(toof) // no you dont get to insert 0 teeth for cash.
			return
		if(toof.amount >= 1)
			toof.amount--
			src.credits += 5
			playsound(user.loc, 'sound/machines/rpf/audiotapein.ogg', 50, 0.4) // it sounds nicer when its played from the person ngl
			if(toof.amount == 1) // fuck you..
				qdel(toof)
				return
			return
	if(istype(C, /obj/item/clothing/head/helmet/redhelmet) && id == "blue" || istype(C, /obj/item/clothing/head/helmet/bluehelmet) && id == "red" ) // meh
		src.credits += 10
		playsound(user.loc, 'sound/machines/rpf/audiotapein.ogg', 50, 0.4)
		qdel(C)

	if(istype(C, /obj/item/card/id/dog_tag/red) && id == "blue" || istype(C, /obj/item/card/id/dog_tag/blue) && id == "red" ) // meh
		src.credits += 10
		playsound(user.loc, 'sound/machines/rpf/audiotapein.ogg', 50, 0.4)
		qdel(C)

/obj/machinery/kaos/cargo_machine/attack_hand(mob/living/user as mob) // notice: find a way to sync both versions without having them be duplicates // Done, ignore this notice
	var/machine_input
	if(!user.Adjacent(src))
		return
	if (useable)
		set_light(3, 3,"#ebc683")
	if (!useable)
		to_chat(user, "\icon[src]The machine is currently busy processing something..")
		playsound(src.loc, 'sound/machines/rpf/denybeep.ogg', 100, 0.3)
	else if(!loggedin && useable)
		playsound(src.loc, "sound/machines/rpf/press1.ogg", 100, 0.7)
		var/line_input = sanitize(input(user, "ENTER LOGIN.", "R.E.D. CARGO MACHINE", "")) // remove hint when we're done
		line_input = sanitize(line_input)
		if(!line_input)
			to_chat(user, "\icon[src]You must enter a login.")
			playsound(src.loc, 'sound/machines/rpf/denybeep.ogg', 100, 0.5)
			set_light(0)
		else
			if(line_input == GLOB.cargo_password)
				playsound(src, "switch_sound", 100, 1)
				to_chat(user, "\icon[src]Welcome, <span class='warning'>Administrator</span>.")
				playsound(src.loc, 'sound/machines/rpf/consolebeep.ogg', 100, 0.5)
				loggedin = TRUE
				machine_input = input(user, "CARGO MACHINE.") as null|anything in INPUTS
				//var/machine_input = input(user, "CARGO MACHINE.") as null|anything in INPUTS // Figure out how to make this work without breaking the machine
			else
				to_chat(user, "\icon[src]Incorrect login.")
				playsound(src.loc, 'sound/machines/rpf/denybeep.ogg', 100, 0.5)
				set_light(0)
	else if (loggedin & useable)
		machine_input = input(user, "CARGO MACHINE.") as null|anything in INPUTS
	if(machine_input == "LOGOUT")
		set_light(0)
		to_chat(user, "\icon[src]Goodbye, <span class='warning'>Administrator</span>.")
		playsound(src.loc, 'sound/machines/rpf/consolebeep.ogg', 100, 0.5)
		src.loggedin = FALSE
	else if(machine_input == "WITHDRAW MONEY" && useable)
		var/withdraw_amount = input(user, "ENTER AMOUNT TO WITHDRAW.", "CARGO MACHINE.") as num
		if(src.credits == 0)
			playsound(src.loc, 'sound/machines/rpf/denybeep.ogg', 100, 0.5)
			to_chat(user, "\icon[src]You have no money to withdraw.")
		else
			if(withdraw_amount > src.credits | withdraw_amount < 0 | !withdraw_amount)
				to_chat(user, "\icon[src]You cannot withdraw that amount.")
				playsound(src.loc, 'sound/machines/rpf/denybeep.ogg', 100, 0.5)
			else
				playsound(src.loc, "sound/machines/rpf/press1.ogg", 100, 0.7)
				spawn(0.6 SECONDS)
					playsound(src.loc, 'sound/machines/rpf/transcriptprint.ogg', 90, 0)
					spawn(1.68 SECONDS)
						src.credits -= withdraw_amount
						var/obj/item/spacecash/bundle/P = new /obj/item/spacecash/bundle(get_turf(src))
						P.worth = withdraw_amount
						P.update_icon()
						P.name = "[withdraw_amount] credits"
						P.desc = "It's money.."
						to_chat(user, "\icon[src]You withdraw [withdraw_amount] credits.")
	else if(machine_input == "CHECK BALANCE" && useable)
		if(src.credits > 0)
			playsound(src, "keyboard_sound", 100, 1)
			to_chat(user, "\icon[src]The machine has [src.credits] credits.")
			src.speak("The machine has [src.credits] credits.")
			playsound(src.loc, 'sound/machines/rpf/consolebeep.ogg', 100, 0.5)
		else
			to_chat(user, "\icon[src]The machine has no credits.")
			playsound(src.loc, 'sound/machines/rpf/consolebeep.ogg', 100, 0.5)
	else if(machine_input == "CONTACT MIDDLE MANAGEMENT" && useable)
		var/line_input = sanitize(input(user, "ENTER MESSAGE.", "CARGO MACHINE.", ""))
		line_input = sanitize(line_input)
		if(line_input && !cooldown)
			playsound(src.loc, "sound/machines/rpf/press1.ogg", 100, 0.7)
			spawn(0.25 SECONDS)
				playsound(src.loc, 'sound/machines/rpf/sendmsgcargo.ogg', 100, 0)
				spawn(1.06 SECONDS)
					log_and_message_admins("[user] has messaged R.E.D. Middle Management at [src]!<br><span class='danger'>The message is as follows...</span><br><span class='boldannounce'>'[line_input]'</span>")
					to_chat(user, "\icon[src]Your message has been sent to R.E.D. Middle Management.")
					src.speak("Your message has been sent to <span='alert'>R.E.D. Middle Management</span>.")
					cooldown = TRUE
					spawn(30 SECONDS)
						cooldown = FALSE
		else if(cooldown)
			to_chat(user, "\icon[src]The machine is still processing your last message.")
			playsound(src.loc, 'sound/machines/rpf/denybeep.ogg', 100, 0.5)
		else if(!line_input)
			to_chat(user, "\icon[src]You must enter a message.")
			playsound(src.loc, 'sound/machines/rpf/consolebeep.ogg', 100, 0.5)
	else if(machine_input == "RECONNECT PADS" && useable)
		//reconnectpads() // COMMENT OUT WHEN NOT TESTING!!
		set_light(1, 1,"#110f0c")
		playpadsequence(user)
	else if(machine_input == "BROWSE CATALOG" && useable)
		if(!pads)
			to_chat(user, "\icon[src]ERROR. NO LINKED CARGO PADS. REESTABLISH CONNECTION AND TRY AGAIN.")
			playsound(src.loc, 'sound/machines/rpf/denybeep.ogg', 100, 0.5)
		else if(pads.len > 0)
			playsound(src.loc, "sound/machines/rpf/press1.ogg", 100, 0.7)
			var/list/CATEGORY_INPUTS = list()
			for(var/category in categories)
				CATEGORY_INPUTS += "- [category]"
			CATEGORY_INPUTS += "-- Return --"
			var/selected_category = input(user, "CHOOSE A CATEGORY TO BROWSE.") as null|anything in CATEGORY_INPUTS
			if((selected_category=="-- Return --") && useable)
				playsound(src.loc, "sound/machines/rpf/UI_labelselect.ogg", 100, 0.15)
			else if(selected_category && useable)
				playsound(src.loc, "sound/machines/rpf/press1.ogg", 100, 0.7)
				var/list/PRODUCT_INPUTS = list()
				for(var/product in products)
					if("- " + product["category"] == selected_category)
						PRODUCT_INPUTS += "- [product["name"]] -- [product["price"]] credits"
				PRODUCT_INPUTS += "-- Return --"
				var/selected_product = input(user, "CHOOSE A PRODUCT TO BUY.") as null|anything in PRODUCT_INPUTS
				//to_chat(user, "\icon[src]PRODUCTS: [products]") // broken devmsg
				if((selected_product=="-- Return --") && useable)
					playsound(src.loc, "sound/machines/rpf/barotraumastuff/UI_labelselect.ogg", 100, 0.15)
				else if(selected_product && useable)
					playsound(src.loc, "sound/machines/rpf/press1.ogg", 100, 0.7)
					var/pos1 = findtext(selected_product, "- ") + 2
					var/pos2 = findtext(selected_product, " --")
					var/productname = copytext(selected_product, pos1, pos2)
					var/product
					for(var/p in products)
						if(p["name"] == productname)
							product = p
							break
					productname = product["name"]
					var/productprice = product["price"]
					var/productpath = product["path"]
					var/turf/pickedloc
					var/list/clear_turfs = list()
					var/padstatusprint = "...///Begining PD-LOG <br>///..."
					var/obj/structure/cargo_pad/pickedpad
					//var/list/cargoturfs = list()
				//	var/hasdenseobject
					if(productprice <= src.credits) // This shitcode works! Checks for dense objects on the turf!
						var/padnum = 0
						reconnectpads() // let's be cheeky and silently reocnnect it just incase one got deleted
						for(var/obj/structure/cargo_pad/pad in pads)
							if(get_dense_objects_on_turf(get_turf(pad)).len <= 0)
								padnum += 1
								padstatusprint += "<br>...///PD-[padnum]-CLR///...<br>"
								clear_turfs += pad
							else
								padnum += 1
								padstatusprint += "<br>...///PD-[padnum]-BLKD - CLEAR THE PAD.///...<br><br>!COMPANY REMINDER: PURCHASES ARE NON REFUNDABLE!<br><br>"
								continue
						// 	cargoturfs += get_turf(pad) // supplyshuttle.dm shitcode that i stole. doesn't work.
						// for(var/turf/T in cargoturfs)
						// 	hasdenseobject = FALSE
						// 	for(var/obj/object in get_objects_on_turf(T))
						// 		if(object.density == 1)
						// 			continue
						// 			hasdenseobject = TRUE
						// 	if(hasdenseobject == FALSE)
						// 		clear_turfs += T
						// 	else if(hasdenseobject == TRUE)
						// 		to_chat(user, "\icon[src]There's dense stuff on the pad.")
						//i = rand(1,clear_turfs.len) // supplyshuttle.dm shitcode that i stole. doesn't work.
						pickedpad = pick(clear_turfs)
						pickedloc = get_turf(pickedpad)
					if(!clear_turfs)
						to_chat(user, "\icon[src]ERROR. ALL PADS OCCUPIED. MAKE SPACE AND TRY AGAIN.")
						playsound(src.loc, 'sound/machines/rpf/denybeep.ogg', 100, 0.5)
					if(!pads) // if this somehow were to happen id be in awe.
						to_chat(user, "\icon[src]ERROR. NO LINKED CARGO PADS. REESTABLISH CONNECTION AND TRY AGAIN.")
						playsound(src.loc, 'sound/machines/rpf/denybeep.ogg', 100, 0.5)
					else if(productprice <= src.credits)
						useable = FALSE
						playsound(src.loc, 'sound/machines/rpf/cargo_starttp.ogg', 100, 0)
						spawn(2.2 SECONDS)
						//	pad.lightup()
							pickedpad.isselected()
							var/obj/glowobj = new /obj/effect/overlay/cargopadglow(pickedloc)
							playsound(pickedpad.loc, 'sound/machines/rpf/cargo_endtp.ogg', 200, 0)
							spawn(2.65 SECONDS)
								var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
								sparks.set_up(3, 0, pickedloc)
								sparks.start()
								pickedpad.isselectedbrighter()
								spawn(0.025 SECONDS)
									var/list/togib = get_people_on_turf(get_turf(pickedpad))
									for(var/mob/gibthisguy in togib)
										if(gibthisguy.loc == pickedpad.loc) // sanity check I guess
											log_and_message_admins("[gibthisguy] has <span class='danger'>gibbed themselves</span> on the following cargo pad: [pickedpad]!")
											to_chat(gibthisguy, "\icon[glowobj]You gibbed yourself on the cargo pad. Congratulations.. Your story ends here..<span class='alert'>(DEV MSG)</span>")
											gibthisguy.gib()
										else
											continue // if this were to happen, it would be a miracle
									new productpath(pickedloc)
							spawn(2.7 SECONDS)
								pickedpad.isselected()
					//				pad.lightdown()
						//A.SetName("[productname]")
								to_chat(user, "\icon[src]You have purchased [productname].")
								src.credits -= productprice
								spawn(0.1 SECONDS)
									qdel(glowobj)
									pickedpad.isdeselected()
								spawn(2 SECONDS)
									resetlightping()
									playsound(src.loc, 'sound/machines/rpf/ChatMsg.ogg', 100, 0)
									useable = TRUE
									speak("The request was processed successfully.")

					else if(productprice > src.credits)
						to_chat(user, "\icon[src]Insufficient funds to purchase [product["name"]].")
						playsound(src.loc, 'sound/machines/rpf/denybeep.ogg', 100, 0.5)
					else if(clear_turfs.len <= 0)
						to_chat(user, "\icon[src]No space to drop off [product["name"]].")
						playsound(src.loc, 'sound/machines/rpf/denybeep.ogg', 100, 0.5)
					else if(pickedloc == null)
						to_chat(user, "\icon[src]FATAL ERROR.")
					else
						to_chat(user, "\icon[src]An UNKNOWN error has occured.")
	else if(machine_input == "SELL PRODUCTS" && useable)
		var/confirm = input(user, "Are you sure you want to sell all items on the pads?", "CARGO MACHINE.") as null|anything in list("Yes", "No")
		if(confirm == "Yes") // Figure out a way to get the items that are on the pads, use get_value to get their value, and delte them.
			if(!pads)
				to_chat(user, "\icon[src]ERROR. NO LINKED CARGO PADS. REESTABLISH CONNECTION AND TRY AGAIN.")
				playsound(src.loc, 'sound/machines/rpf/denybeep.ogg', 100, 0.5)
			else if(pads.len > 0)
				reconnectpads() // reocnnecting just INCASE
				useable = FALSE
				playsound(src.loc, 'sound/machines/rpf/cargo_starttp.ogg', 100, 0)
				spawn(2.2 SECONDS)
					for(var/obj/structure/cargo_pad/pad in pads)
					//	pad.lightup()
						pad.isselected()
						var/obj/glowobj = new /obj/effect/overlay/cargopadglow(pad.loc)
						if(pads.len > 4)
							playsound(pad.loc, 'sound/machines/rpf/cargo_endtp.ogg', 27, 0)
						else
							playsound(pad.loc, 'sound/machines/rpf/cargo_endtp.ogg', 40, 0)
						spawn(2.65 SECONDS)
							var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
							sparks.set_up(3, 0, pad.loc)
							sparks.start()
							pad.isselectedbrighter()
							/*spawn(0.025 SECONDS)
								var/list/togib = get_people_on_turf(get_turf(pad))
								for(var/mob/gibthisguy in togib)
									if(gibthisguy.loc == pad.loc) // sanity check I guess
										log_and_message_admins("[gibthisguy] has <span class='danger'>sold themselves</span> on the following cargo pad: [pad]!")
										to_chat(gibthisguy, "\icon[glowobj]You gibbed yourself on the cargo pad. Congratulations.. Your story ends here..<span class='alert'>(DEV MSG)</span>")
										gibthisguy.gib()
									else
										continue*/
						spawn(2.7 SECONDS)
							pad.isselected()
							// temporary src loc
							//				pad.lightdown()
							//A.SetName("[productname]")
							var/turf/sellturf = get_turf(pad)
							for(var/obj/item in sellturf)
								if(istype(item, /obj/item/))
									src.credits += get_value(item)
									qdel(item)
								else if(istype(item, /obj/structure/closet))
									for(var/obj/iteminside in (item.contents))
										//src.credits += get_value(iteminside)
										//qdel(iteminside)
										if(istype(iteminside, /mob/living/carbon/human))
											var/personinside = iteminside
											var/mob/living/carbon/human/H = user
											for(var/obj/item/organ/internal/organ in (H.organs)) // Internals // doesnt work
												src.credits += get_value(organ)
												qdel(organ)
											for(var/obj/item/organ/external/organ in (H.organs)) // Externals // doesnt work
												src.credits += get_value(organ)
												qdel(organ)
											to_chat(personinside, "\icon[pad]You find yourself transported to an unfamiliar place..") // this wont print for some reason?
											src.credits += get_value(personinside)
											qdel(personinside)
											qdel(item)
										else
											src.credits += get_value(iteminside)
											qdel(iteminside)
									src.credits += get_value(item)
									qdel(item)
							spawn(0.1 SECONDS)
								qdel(glowobj)
								pad.isdeselected()
					spawn(5.375 SECONDS)
						resetlightping()
						playsound(src.loc, 'sound/machines/rpf/ChatMsg.ogg', 100, 0)
						useable = TRUE
					//				speak("\icon[src]The request was processed successfully.")
				to_chat(user, "\icon[src]All items on the pads have been sold. <span class='alert'>(DEV MSG)</span>")
				playsound(src.loc, 'sound/machines/rpf/consolebeep.ogg', 100, 0.5)
		else
			to_chat(user, "\icon[src]Sell operation cancelled.")
			playsound(src.loc, 'sound/machines/rpf/denybeep.ogg', 100, 0.5)

/obj/effect/overlay/cargopadglow
	name = "Cargo Pad"
	desc = "Huh... I wonder what this does.."
	icon = 'icons/obj/old_computers.dmi'
	icon_state = "portal"
	density = 0
//	plane = ABOVE_OBJ_PLANE
	plane = WALL_PLANE
//	layer = ABOVE_OBJ_LAYER
	anchored = 1

//Just for looks, it shows off nicely where the cargo will be dropped off.
/obj/structure/cargo_pad
	name = "Cargo Pad"
	desc = "Papa said that I shouldn't stand on this when it lights up.."
	icon = 'icons/obj/old_computers.dmi'
	icon_state = "cargo_pad"
	density = FALSE
	unacidable = TRUE
	anchored = TRUE
	plane = WALL_PLANE
	var/id
	var/broken = FALSE

/obj/structure/cargo_pad/proc/isselected()
	set_light(2, 1,"#e26868")

/obj/structure/cargo_pad/proc/isselectedbrighter()
	set_light(3, 1,"#fdcaca")

/obj/structure/cargo_pad/proc/isdeselected()
	set_light(0)

/obj/structure/cargo_pad/proc/pingpad()
	spawn(0.05 SECONDS)
		set_light(1, 1,"#e26868")
		var/obj/glowobj = new /obj/effect/overlay/cargopadglow(src.loc)
		spawn(0.05 SECONDS)
			qdel(glowobj)
			set_light(0)

/obj/structure/cargo_pad/ex_act()
	return

/obj/structure/cargo_pad/blue

	isselected()
		set_light(2, 1,"#6899e2")

	isselectedbrighter()
		set_light(3, 1,"#cad7fd")

	pingpad()
		spawn(0.05 SECONDS)
			set_light(1, 1,"#6899e2")
			var/obj/glowobj = new /obj/effect/overlay/cargopadglow(src.loc)
			spawn(0.05 SECONDS)
				qdel(glowobj)
				set_light(0)
