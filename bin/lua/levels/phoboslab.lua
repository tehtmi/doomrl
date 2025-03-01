-- PHOBOS LAB -----------------------------------------------------------

register_level "phobos_lab"
{
	name  = "Phobos Lab",
	entry = "On level @1 he sneaked into the Phobos Lab.",
	welcome = "You arrive at the Phobos Lab. You are overcome by the feeling of nostalgia!",
	level = 7,

	OnRegister = function ()
		register_item "lever_phoboslab1"
		{
			name   = "lever",
			color  = MAGENTA,
			sprite = 248,
			weight = 0,
			type   = ITEMTYPE_LEVER,
			flags  = { IF_NODESTROY },

			good = "neutral",
			desc = "unlocks door",

			color_id = false,

			OnUse = function(self,being)
				generator.transmute( "ldoor", "door", level.data.door1 )
				ui.msg("Green access granted, west doors unlocked.")
				return true
			end,
		}
		register_item "lever_phoboslab2"
		{
			name   = "lever",
			color  = MAGENTA,
			sprite = 248,
			weight = 0,
			type   = ITEMTYPE_LEVER,
			flags  = { IF_NODESTROY },

			good = "neutral",
			desc = "unlocks door",

			color_id = false,

			OnUse = function(self,being)
				generator.transmute( "ldoor", "door", level.data.door1 )
				generator.transmute( "ldoor", "door", level.data.door2 )
				generator.transmute( "acid",  "bridge",level.data.bridge )
				ui.msg("Blue access granted, east doors unlocked.")
				level.status = 1
				return true
			end,
		}
	end,	

	Create = function ()
		level.style = 1
		generator.fill( "floor", area.FULL )
		level.data.bridge = area.new(50,10,60,11)
		level.data.door1  = area.new(45,10,45,11)
		level.data.door2  = area.new(61,10,61,11)
		level.data.trap11 = area.new(8,4,8,7)
		level.data.trap12 = area.new(8,14,8,17)
		level.data.trap21 = area.new(34,2,35,3)
		level.data.trap22 = area.new(34,18,35,19)

		local mod1,mod2 = generator.roll_pair{"mod_power","mod_agility","mod_bulk","mod_tech"}

		local translation = {
			['.'] = "floor",
			['#'] = { "wall",   flags = { LFPERMANENT } },
			['%'] = { "cwall1", flags = { LFPERMANENT } },
			['X'] = { "dwall",  flags = { LFPERMANENT } },
			['+'] = { "door",   flags = { LFPERMANENT } },
			['L'] = { "ldoor",  flags = { LFPERMANENT } },
			['='] = "acid",
			['>'] = "stairs",
			['9'] = { "floor", item = "lever_phoboslab1" },
			['0'] = { "floor", item = "lever_phoboslab2" },

			['f'] = { "floor", being = "former" },
			['s'] = { "floor", being = "sergeant" },
			['i'] = { "floor", being = "former" },
			['I'] = { "floor", being = core.ifdiff( 3, "imp" ) },
			['F'] = { "floor", being = core.ifdiff( 2, "former" ) },
			['S'] = { "floor", being = core.ifdiff( 3, "sergeant" ) },
			['d'] = { "floor", being = core.ifdiff( 4, "ndemon", "demon" ) },
			['D'] = { "floor", being = core.ifdiff( 5, "ndemon" ) or core.ifdiff( 3, "demon" ) },

			['!'] = { "floor", item = "lhglobe" },
			['"'] = { "floor", item = "epack" },
			['}'] = { "floor", item = "ashotgun" },
			['1'] = { "floor", item = mod1 },
			['2'] = { "floor", item = mod2 },
			['|'] = { "floor", item = "ammo" },
			['-'] = { "floor", item = "shell" },
			['['] = { "floor", item = "barmor" },
			[']'] = { "floor", item = "garmor" },
			['3'] = { "floor", item = "smed" },
			['4'] = { "floor", item = "lmed" },
		}

		local map = [=[

#############################################%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#########........................##iI-######%%%...%%...%%%%.d%%%.%%%%%%%d...%%
########...D..............i.......#I.-######%%4.%..d.%D.%.D....D..!%%%4..%%..%
#####Ds#..........................###########%%..D%%%%....%%%%d.%%%%%%%%D.%D%%
#####d.#....##################....######################++##X%%..%%..d%...%.d%
#####d.#...##==============]|##...###########......F..f..s.SX%%%.D..%...%%%9%%
#####DS#...=====SI.========.|!#...###########.S#============X%%%%%%%%%%%%%%%%%
########...=====f..===========#...###########..=============XXXXXXXXXXXXXXXXXX
#---..3#.f.===================#...###########..##===========X1-|...XXX.....XXX
#".....+.F.=================.0#...+...d.....L....===========L......+.......>!X
#".....+.F.=================..#.I.+.......d.L....===========L......+.......[}X
#|||..3#.f.===================#...###########..##===========X2-|...XXX.....XXX
########...=====f..===========#...###########..=============XXXXXXXXXXXXXXXXXX
#####DS#...=====SI.========.-!#...###########.S#============X#################
#####d.#...##==============]-##...###########.....F..f...s.SX#################
#####d.#....##################....######################++####################
#####Ds#..........................#####################..s.###################
########...D..............i.......#iI|############==============##############
#########........................##I.|###########==####....####==#############
#################################################==####3..3####==#############
]=]
		generator.place_tile( translation, map, 1, 1 )

		level:player(57,19)
	end,

	OnKillAll = function ()
		if level.status < 4 then
			ui.msg("\"This lab won't do any more experiments... I wonder if there are others?\"")
			level.status = 4
		end
	end,

	OnTick = function ()
		if level.status == 1 then
			if player.x < 12 then
				ui.msg("The walls lower!")
				generator.transmute( "wall", "floor", level.data.trap11 )
				generator.transmute( "wall", "floor", level.data.trap12 )
				player:remove_affect("enviro")
				player:play_sound("door.open")
				level.status = 2
			end
		elseif level.status == 2 then
			if player.x > 30 then
				ui.msg("The walls lower!")
				generator.transmute( "wall", "floor", level.data.trap21 )
				generator.transmute( "wall", "floor", level.data.trap22 )
				player:remove_affect("enviro")
				player:play_sound("door.open")
				level.status = 3
			end
		end
	end,

	OnEnter = function ()
		level.status = 0
	end,

	OnExit = function ()
		ui.msg("\"So much for the lab, next time I'll use neurotoxin...\"")
		player:add_history("He broke through the lab.")
	end,


}
