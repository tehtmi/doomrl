-- SPIDER'S LAIR --------------------------------------------------------

register_level "spiders_lair"
{
	name  = "Spider's Lair",
	entry = "On level @1 he ventured into the Spider's Lair.",
	welcome = "You descend into the Spider's Lair. Mechanical clicks everywhere! Oh my god it's full of spiders!",
	level = 14,


	OnRegister = function ()

		register_badge "arachno1"
		{
			name  = "Arachno Bronze Badge",
			desc  = "Clear Spider's Lair",
			level = 1,
		}

		register_badge "arachno2"
		{
			name  = "Arachno Silver Badge",
			desc  = "Clear Spider's Lair on AoD",
			level = 2,
		}

		register_medal "everyspider"
		{
			name  = "Spider-Killer Cross",
			desc  = "Clear Spider's Lair on AoHu",
			hidden  = true,
		}

	end,


	Create = function ()
		level.style = 6
		generator.fill( "cwall2", area.FULL )

		local translation = {
			['.'] = "floorc",
			[','] = { "floorc", flags = { LFBLOOD } },
			['#'] = "cwall2",
			['X'] = { "cwall2", flags = { LFBLOOD } },
			['>'] = "stairs",

			['|'] = { "floorc", item = "rocket" },

			['A'] = { "floorc", being = "arachno" },
			['e'] = { "floorc", being = core.ifdiff( 2, "arachno" ) },
			['m'] = { "floorc", being = core.ifdiff( 3, "arachno" ) },
			['h'] = { "floorc", being = core.ifdiff( 4, "arachno" ) },

			['1'] = { "floorc", item = { "teleport", target = coord.new(8,7)   } },
			['2'] = { "floorc", item = { "teleport", target = coord.new(70,7)  } },
			['3'] = { "floorc", item = { "teleport", target = coord.new(8,13)  } },
			['4'] = { "floorc", item = { "teleport", target = coord.new(70,13) } },
		}

		local map = [[
#######################.....#####.........#####.....########################
############...........####......#####>........####...####......############
#####.....................m####.....A.###.A........##.m...##...........#####
##.......#.........#####.......###...,,,.#...........#......##....#.......##
#..4....|X......###.....####......##,,,,,,#..........#........#...X|...3...#
........|#....##............###A..,,#,,,,,#,,..A....#..........#..#|........
.........#...#.................##,,,,1,,,2,,,.....##...........#..#.........
............#...................,,,,,,,,,,,,,,,###..............#...........
...h.......#.........m........e.,,,,,,,,,,,,,,,.e.........m.....#......h....
...........#.................###,,,,,,,,,,,,,,..................#...........
............#..............##...,,,,,3,,,4,,,,,##..............#............
.........#..#............##....A.,,,#,,,,,#,,,.A.###..........#...#.........
........|#...#..........#........,,,#,,,,,,##.......####....##....X|........
#..2....|#....#........#...........,,#,,.,,..##.........####......X|...1...#
##.......X.....##.....#....m........A,#...A....###..m.............#.......##
#####............##...#................###........###..................#####
############.......###.###............>...####.......####.......############
#######################...######..............#####.########################
]]
		generator.place_tile( translation, map, 2, 2 )
		level:player(41,10)
		level.status = 0
	end,

	OnKillAll = function ()
		if level.status == 0 then
			ui.msg("Suddenly the webs fade. From under the webs, items emerge...")
			level:drop("cell",4)
			level:drop("ashard",2)
			level:drop("psboots")
			level:drop("scglobe")
			level:drop("pcell")

			level:drop_item("bfg9000", coord.new(41,10) )
			level.status = 1
			if CHALLENGE == "challenge_aohu" then
				player:add_medal("everyspider")
			end
		end
	end,

	OnExit = function ()
		if level.status == 0 then
				ui.msg("Arachnophobia!")
				player:add_history("He fled the Lair, knowing how to fear Arachnotrons!")
		else
				ui.msg("Silence rules the spidery lands...")
				player:add_history("He cleared the Lair, kickin' serious spider ass!")
				player:add_badge("arachno1")
				if core.is_challenge("challenge_aod") then player:add_badge("arachno2") end
		end
	end,

}

