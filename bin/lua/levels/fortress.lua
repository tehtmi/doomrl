-- Angel of Death Fortress ----------------------------------------------

register_level "unholy_cathedral"
{
	name  = "Unholy Cathedral",
	entry = "On level @1 he invaded the Unholy Cathedral!",
	welcome = "You arrive at the Unholy Cathedral. You feel something sinister in the air.",
	level = 17,

	canGenerate = function ()
		return DIFFICULTY > 1
	end,

	OnRegister = function ()

		register_item "spear"
		{
			name     = "Longinus Spear",
			color    = YELLOW,
			sprite   = SPRITE_SPEAR,
			psprite  = SPRITE_PLAYER_SPEAR,
		 	glow     = { 1.0,1.0,0.0,1.0 },
			level    = 200,
			weight   = 0,
			set      = "angelic",
			group    = "weapon-melee",
			desc     = "Legend says that no one wielding the Spear of Destiny can ever be defeated.",
			flags    = { IF_UNIQUE, IF_HALFKNOCK, IF_NUKERESIST },

			type        = ITEMTYPE_MELEE,
			damage      = "8d8",
			damagetype  = DAMAGE_PLASMA,
			altfire     = ALT_SCRIPT,
			altfirename = "holy flame",

			OnFirstPickup = function(self,being)
				being:quick_weapon("spear")
				ui.blink( WHITE, 100 )
				ui.msg("You perceive an aura of holiness around this weapon!")
			end,

			OnAltFire = function(self,being)
				if being.tired then
					ui.msg("You are too tired to invoke the Spear!");
				else
					level:explosion( being.position , 3, 50, 10, 10, YELLOW, "soldier.phase", DAMAGE_FIRE, self, { EFSELFSAFE } )
					ui.blink(YELLOW,50)
					ui.blink(WHITE,50)
					being.tired = true
					being.scount = being.scount - 1000
				end
				return false
			end,
		}

		register_item "uscythe"
		{
			name     = "Azrael's Scythe",
			color    = YELLOW,
			sprite   = SPRITE_STAFF,
			psprite  = SPRITE_PLAYER_STAFF,
			glow     = { 1.0,0.5,0.0,1.0 },
			level    = 200,
			weight   = 0,
			group    = "weapon-melee",
			desc     = "You don't want to know whose scythe this is...",
			flags    = { IF_UNIQUE, IF_HALFKNOCK, IF_NUKERESIST },

			type        = ITEMTYPE_MELEE,
			damage      = "9d9",
			damagetype  = DAMAGE_PLASMA,
			altfire     = ALT_SCRIPT,
			altfirename = "whisper of death",

			OnFirstPickup = function(self,being)
				being:quick_weapon("uscythe")
				ui.blink( RED, 100 )
				ui.msg("You perceive an aura of evil around this weapon!")
			end,
			
			OnAltFire = function(self,being)
				if being.tired then
					ui.msg("You are too tired to invoke the Scythe!");
				else
					ui.blink( RED, 50 )
					ui.msg("You feel your life energy draining away!")
					for b in level:beings() do
						if not b:is_player() then
							b:apply_damage( 20, TARGET_TORSO, DAMAGE_PLASMA, self )
						end
					end
					being.hpmax = math.max(being.hpmax - 5,5)
					being.hp = math.max(being.hp - 10,1)
					being.tired = true
					being.scount = being.scount - 1000
				end
				return false
			end,
		}

		register_badge "death3"
		{
			name  = "Longinus Gold Badge",
			desc  = "Complete Unholy Cathedral",
			level = 3,
		}

		register_badge "death4"
		{
			name  = "Longinus Platinum Badge",
			desc  = "Complete Unholy Cathedral on N!",
			level = 4,
		}

		register_badge "death5"
		{
			name  = "Longinus Diamond Badge",
			desc  = "Complete Unholy Cathedral on N! w/o Bru",
			level = 5,
		}

	end,

	Create = function ()
		level.style = 3
		generator.fill( "rwall", area.FULL )
		local reward = "spear"
		if statistics.kills == statistics.max_kills and DIFFICULTY >= DIFF_HARD then
			reward = "uscythe"
		end
		if player:has_medal("hellchampion3") then
			reward = "udragon"
		end

		local translation = {
		['.'] = "floorb",
		[','] = {"floorb", flags = {LFBLOOD} },
		['#'] = "rwall",
		['+'] = "doorb",
		['>'] = "stairs",
		['='] = "lava",
		['$'] = { "odoorb", item = reward },
		['s'] = { "floorb", being = "lostsoul" },
		['d'] = { "floorb", being = "demon" },
		['S'] = { "floorb", flags = { LFBLOOD }, being = core.ifdiff( 3, "lostsoul" ) },
		['D'] = { "floorb", being = core.ifdiff( 4, "demon" ) },
		['A'] = { "floorb", flags = { LFBLOOD }, being = "angel" },
		}

		local map = [[
##############.................................................#############
###.......................===============================..............#####
#..............============================#######============..,..........#
..........===================.............##...d.##===================......
.......=========.......######.#####.#####.#..D...d#.........============....
......======.########.###...###...###...###.....d.#..##..#######..======....
.....=====.,,##.....###..s...s..s..s...s..#...d...########,,,,,###..=====...
....=====.,,##..##...#..##...##...##...##.#.d...D..d..##,,,,,,,,###.=====...
.........,,,+,,,,,,,,+,,,S,,,,S,,,,S,,,,,,+,,,,,,,,,,,+,,,,A,,,,###..=====..
.>........,,+,,,,,,,,+,,,,,,S,,,S,,,,,S,,,+.,,,,,,,,,,+,,,,,,,,,#$#..====...
....=====..,##..##...#..##...##...##...##.#...d..D..d.##,,,,,,,,###..====...
.....=====...##.....###..s...s.s..s....s..#.D...d.########,,,,,###..=====...
......======.########.###...###...###...###...d...#..##..#######..======....
.......=========.......######.#####.#####.#.D..D..#.........============....
..........===================.............##.....##===================......
#...............===========================#######============.............#
###........................=============================..............######
###############...............................................##############
]]
		generator.place_tile( translation, map, 2, 2 )
		generator.set_permanence( area.FULL )

		level:player(3,10)
		level.status = 0
	end,

	OnKillAll = function ()
		if level.status == 0 then
			level.status = 1
			ui.msg("As you kill the Angel of Death the cathedral suddenly")
			ui.msg_enter("starts to fall apart!")
			level:nuke()
		end
	end,

	OnFire = function(item,being)
		if being:is_player() and item.itype == ITEMTYPE_RANGED then
			ui.msg("You pull the trigger... nothing happens!")
			return false
		end
		return true
	end,

	OnExit = function ()
		if level.status == 0 then
			ui.msg("...Or wonder, till it drives you mad,")
			ui.msg("What would have followed if you had....")
			player:add_history("He fled the Unholy Cathedral seeing no chance to win.")
		else
			ui.msg("Never again...")
			player:add_history("He then destroyed the Unholy Cathedral!")
			if not level.flags[ LF_NUKED ] then
				player:add_badge("death3")
				if DIFFICULTY >= DIFF_NIGHTMARE then
					player:add_badge("death4")
					if player:get_trait( traits["brute"].nid ) == 0 then player:add_badge("death5") end
				end
			end
		end
	end,
}
