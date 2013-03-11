/*
 *  Swiss mountains - sceanraio
 *
 *  tested with 112.2 nightly r6379, pak128 2.2.0 r1170
 *  Can NOT be used in network game !
 */

const version = 2                             // version of script
map.file = "swiss.sve"                        // specify the savegame to load
scenario.short_description = "Swiss mountains"
scenario.author            = "ny911 (map & scripting)"
scenario.version           = "0." + (version + 1)
scenario.translation      <- "de=ny911"

const startcash     = 1                       // pl=0 startchash in millions
const max_x         = 1000                    // max. size of map  !!!!!
const forget_time   = 12                      // month to forget one terraforming
const city_growth   = 250                     // min. year city growth for extra forget terraforming
const target_good_1 = 6600                    // target planks consumption (best 7000)
const target_good_2 = 9900                    // target concrete & steel  consumption (best 9000)
const traffic_level = 8                       // traffic level
const price_terra   = 10000                   // placeholder, change in savegame
const price_tree    = 200                     // placeholder, change in savegame
const name_concrete = "Concrete"              // internal name of good
const name_steel    = "Stahl"                 // internal name of good
const name_planks   = "Bretter"               // internal name of good

tourism <- {
        skiing_1 = { pos = {x = 488, y = 171, z =  3}, happy = 4000, unhappy = 40, factor =  1, text = "Skiing Resort Ischgl" }
        skiing_2 = { pos = {x = 474, y = 219, z =  2}, happy = 4000, unhappy = 40, factor =  1, text = "Skiing Resort St. Moritz" }
        skiing_3 = { pos = {x = 384, y = 200, z =  0}, happy = 4000, unhappy = 40, factor =  1, text = "Skiing Resort Chur" }
        skiing_4 = { pos = {x = 237, y = 284, z =  1}, happy = 4000, unhappy = 40, factor =  1, text = "Skiing Resort Zermatt" }
        skiing_5 = { pos = {x = 194, y = 283, z =  4}, happy = 4000, unhappy = 40, factor =  1, text = "Skiing Resort Aosta" }
        skiing_6 = { pos = {x = 166, y = 364, z =  1}, happy = 4000, unhappy = 40, factor =  1, text = "Skiing Resort Modane" }
        Mt_Eiger = { pos = {x = 234, y = 212, z =  5}, happy =   50, unhappy =  2, factor = 10, text = "Mount Eiger" }
        Mt_Blanc = { pos = {x = 135, y = 300, z =  5}, happy =   50, unhappy =  2, factor = 10, text = "Mount Blanc" }
        Mt_Feld  = { pos = {x = 236, y =  30, z =  1}, happy =   50, unhappy =  2, factor = 10, text = "Mount Feldberg" }
        Mt_Bonette={ pos = {x =  38, y = 492, z =  0}, happy =   50, unhappy =  2, factor = 10, text = "Mount Bonette" }
        Mt_Dole  = { pos = {x =  54, y = 228, z =  1}, happy =   10, unhappy =  1, factor = 20, text = "Mount La Dole" }
        Mt_Penna = { pos = {x = 373, y = 474, z =  1}, happy =   50, unhappy =  2, factor = 10, text = "Mount Penna" }
           }
stop_messages <- { x = 6, y = 6, z = -6 }
forbid_tools  <- [tool_build_way, tool_build_bridge]
forbid_list <- {
        way   = { a = {x = 0, y = 0, z = 6}, b = {x = 511, y = 511, z = 10},
                 waytyp=wt_all, tools=tool_build_way, text = "So high in the mountains the air is too thin for passengers." }
        canal = { a = {x = 0, y = 0, z =-4}, b = {x = 511, y = 511, z = 10},
                 waytyp=wt_water, tools=tool_build_way, text = "No Canals in the mountains." }
        runway= { a = {x = 0, y = 0, z =-5}, b = {x = 511, y = 511, z = 10},
                 waytyp=wt_air, tools=tool_build_way, text = "No Airports in the mountains." }
        }


persistent.max_terra <- 4 * forget_time       // max. terra forming actions
persistent.citylist <- {}                     // table to save terraforming amount
persistent.wholesale <- {}                    // future list of wholesales in game
persistent.tunnel_max <- 0                    // max rock pressure in level at start=0
persistent.counter <- 0                       // stores the loops in each month
persistent.last_month <- -1                   // stores lastmonth default -1
persistent.version <- version                 // stores version of script
persistent.citizen <- 0                       // stores citizens at startgame time


function get_info_text(pl)
{
	local info = ttextfile("info.txt")
	info.startyear = settings.get_start_time().year
	info.citizen   = integer_to_string(persistent.citizen)
	info.startcash = money_to_string(startcash * 1000000)
	info.factories = world.get_factories()[0]   // well, that's the current amount
	info.towns     = world.get_towns()[0]       // well, that's the current amount
	return info
}


function get_rule_text(pl)
{
	local rule = ttextfile("rule.txt")
	rule.terra_forget = forget_time
	rule.terra_max    = persistent.max_terra / forget_time
	rule.terra_growth = city_growth
	rule.price_terra  = money_to_string(price_terra)
	rule.price_tree   = money_to_string(price_tree)
	rule.city_list    = city_list_terra()
	rule.wholesales   = tunnel_wholesale_list()
	rule.tunnel_max   = persistent.tunnel_max
	rule.target_good_1= integer_to_string(target_good_1)
	rule.target_good_2= integer_to_string(target_good_2)
	return rule
}


function get_goal_text(pl)
{
	local goal = ttextfile("goal.txt")
	local places = ""
	foreach (p in tourism)
	{
		places+= "(" + my_number(p.pos.x) + "," + my_number(p.pos.y) + "," + p.pos.z + ")"
		places+= " <a href=\"(" + p.pos.x + "," + p.pos.y + ")\">" + ttext(p.text) + "</a>"
		places+= " (" + integer_to_string(p.happy)
		places+= " / " + integer_to_string(p.unhappy) + ")<br>"
	}
	goal.tourism_list = places
	places = "("+stop_messages.x+","+stop_messages.y+","+stop_messages.z+")"
	goal.stop_messages = "<a href=\"" + places + "\">" + places + "</a>"
	return goal
}


function get_result_text(pl)
{
	local result = ttextfile("result.txt")
	local places = ""
	foreach (p in tourism)
	{
		local p2 = p.pos.x + "," + p.pos.y
		local halt = tile_x( p.pos.x, p.pos.y, p.pos.z ).get_halt()
		places+= " <a href=\"(" + p2 + ")\">" + ttext(p.text) + "</a>"
		if (! (halt == null))
		{
			local h1 = halt.get_happy().reduce(sum) - halt.get_happy()[0]
			local h2 = halt.get_unhappy().reduce(sum) - halt.get_unhappy()[0]
			if (h1 < p.happy)   h1 = "<st>" + h1 + "</st>"
			if (h2 >= p.unhappy) h2 = "<st>" + h2 + "</st>"
			places+= " ( "+h1+" / "+h2+" )<br>"
		}
         	else  places+= " (<st>" + ttext("no station") + "</st>)<br>"
	}
	result.tourism_list = places
	result.ratio_scenario = get_percentage(pl)
	switch(hq_level(pl) ) {
		case 0: result.hq_text = ttext("You did not build a luxurious headquarter yet. Go earn more money.")
			break
		case 1: result.hq_text = ttext("You build only a small headquarter.")
			break
		case 2: result.hq_text = ttext("You build a luxurious headquarter.")
			break
	}
	return result
}


function get_about_text(pl)
{
	local about = ttextfile("about.txt")
	about.short_description = scenario.short_description
	about.version = scenario.version
	about.author = scenario.author
	about.translation = scenario.translation
	return about
}


function start()
{
	persistent.citizen = world.get_citizens()[0]
	player_x(0).book_cash( ( (startcash * 1000000) - player_x(0).get_cash()[0]) * 100)
	// make list of all 'material wholesale' in the game
	foreach (position in factory_list_x() )
	{
		local factory = factory_x(position.x,position.y)
		if (factory.output.len() == 0)        //  get last consumer
		{
			local s = ","
                   	foreach (good, slot in factory.input) s+= good + ","
			if ( (s.find(name_concrete) != null) && (s.find(name_steel) != null) )
			{
				local n = position.x * max_x + position.y
				local h =
				{
					pos = { x = position.x , y = position.y }
					cityname = world.find_nearest_city(position).get_name()
				}
				persistent.wholesale.rawset(n,h)
			}
		}
	}
	resume_game()
}


function my_number(a)
{
	if (a <  10) return "00"+a
	if (a < 100) return "0"+a
	return a
}


function round_up(a,b)
{
	local c = (a / b).tointeger()
	if (c * b != a) { c++ }
	return c
}


function sum(a,b)
{
	return a+b
}


function hq_level(pl)
{
	local level = player_x(pl).get_headquarter_level()
	local pos = player_x(pl).get_headquarter_pos()
	if ( !(pos.x >= 0) ) { level = 0 }
	return level
}


function is_scenario_completed(pl)
{
	if (pl != 0) return 0                        // other player get only 0%
	persistent.counter++
	if (persistent.last_month != world.get_time().month)
	{
             	persistent.last_month = world.get_time().month
             	persistent.counter = 0                  // new month, set counter = 0
	}
	if (persistent.counter == 2) forget_terra_forming()
	if (persistent.counter == 3) check_wholesale()
	return get_percentage(pl)
}


function resume_game()
{
	tourism_target <- 0
	// check for script version and compatibility, then use update
	if ( persistent.version < version )
	     update()			// do update old versions
	else gui.open_info_win()		// show scenario window
	// correct settings of savegame
	settings.set_industry_increase_every(0)
	settings.set_traffic_level(traffic_level)
	// forbid tools
	local pl = 0
	foreach (tool in forbid_tools)
		foreach (cube in forbid_list)
			rules.forbid_way_tool_cube(pl, tool, cube.waytyp, cube.a, cube.b, ttext(cube.text) )
	rules.forbid_tool(pl, tool_restoreslope )
	rules.forbid_tool(pl, tool_lower_land )
	rules.forbid_tool(pl, tool_raise_land )
	//  calc max points for game target
	foreach ( point in tourism )
		tourism_target+= point.happy * point.factor
	if (tourism_target < 1) tourism_target = 1    // don't let it = 0
}


function tunnel_allowed(pos)
{
	// make deep tunnels expansive
	local max = persistent.tunnel_max
	local ground = square_x(pos.x,pos.y).get_ground_tile()
	local deep = ground.z - pos.z
	if ( (deep > max) || (max == 0) )
	{
		if (max == 0 && deep == 0) { deep = 1 }
		local text = ttext("The tunnel has to resist a maximal rock pressure of {deep} levels. The construction materials are best until {max} Levels.")
		text.max = max
		text.deep = deep
		return text.tostring()
	}
	return null
}


function tunnel_wholesale_list()
{
	local text = ""
	foreach (consumer in persistent.wholesale)
	{
		local factory = factory_x(consumer.pos.x,consumer.pos.y)
		local concrete = factory.input[name_concrete].get_consumed().reduce(sum)
		local steel = factory.input[name_steel].get_consumed().reduce(sum)
		local planks = factory.input[name_planks].get_consumed().reduce(sum)
		local h = "(" + consumer.pos.x + "," + consumer.pos.y + ")"
		concrete = (concrete < target_good_2) ? "<st>"+concrete+"</st>":concrete
		steel = (steel < target_good_2) ? "<st>"+steel+"</st>":steel
		planks = (planks < target_good_1) ? "<st>"+planks+"</st>":planks
		text+= " <a href=\"" + h + "\">" + translate(factory.get_name()) + "</a> "
		text+= ttext("near") + " " + consumer.cityname
		text+= " ( " + concrete+" / "+steel+" / "+planks + " )<br>"
	}
	return text
}


function terra_forming_allowed(pos)
{
	// don't care about underground slopes
	local ground = square_x(pos.x,pos.y).get_ground_tile()
	local deep = ground.z - pos.z
	if (deep != 0) return null
	// nearest city
	local city = world.find_nearest_city( pos )
	local citynr = city.get_pos().x * max_x + city.get_pos().y
	local text = ""
	local count = 0
	local growth = 1
	if (citynr in persistent.citylist)
	   	count = persistent.citylist.rawget(citynr)
	if (count+forget_time > persistent.max_terra)
	{
		if ( (count > 0) && (city.get_growth().reduce(sum) > city_growth ) )
		growth = 2
		text = ttext( "Citizens of {city} don't like any more terra forming. Wait minimum {time} month.")
		text.city = city.get_name()
		text.time = ( forget_time - (persistent.max_terra - count) ) / growth
		return text.tostring()
	}
	count+= forget_time
	persistent.citylist.rawset(citynr, count)
	local halt = tile_x( stop_messages.x, stop_messages.y, stop_messages.z ).get_halt()
	if ( (!(halt == null)) && (halt.get_name() == "no message")) return null  // don't translate !!!
	text = ttext( "Terra forming near of City {city}: {counter} / {max}")
	text.city = city.get_name()
	text.max = persistent.max_terra / forget_time
	text.counter = round_up(count,forget_time)
	gui.add_message( text.tostring() )
	return null
}


function forget_terra_forming()
{
	foreach (city in city_list_x() )    // do forget for each city
	{
		local citynr = city.get_pos().x * max_x + city.get_pos().y
		if (citynr in persistent.citylist)
		{
			local counter = persistent.citylist[citynr]
			local growth = city.get_growth().reduce(sum)
			// normal forget
			if ( (counter > 0) && (growth > 0) )
				counter--
			// additional forget if city growth a much
	        		if ( (counter > 0) && (growth > city_growth ) )
				counter--
			persistent.citylist[citynr] = counter
		}
	}
}


function city_list_terra()
{
	local text = ""
	local citynr = 0
	local cities = [": "]
	foreach (city in city_list_x() )
	{
		citynr = city.get_pos().x * max_x + city.get_pos().y
		local growth = city.get_growth().reduce(sum)
		local count = 0
		if (citynr in persistent.citylist)
			count = persistent.citylist.rawget(citynr)
		cities.append( city.get_name() + ":" + round_up(count,forget_time) + "/" + count + " "
			+ "<a href=\"(" + city.get_pos().x + "," + city.get_pos().y + ")\">" + city.get_name() + "</a>"
			+ " (" + (growth > 0? "+"+growth:" <st>"+growth+"</st>") + " )<br>")
	}
	cities.sort()                              //  sort the list
	foreach (row in cities) text+= row.slice(row.find(":")+1)  //  array to string
	return text
}


function check_wholesale()
{
	local old_tunnel_max = persistent.tunnel_max
	persistent.tunnel_max == 0
	// check planks consumption for tunnel Levels 1+2
	local planks = 0
	local count = persistent.wholesale.len()
	foreach ( consumer in persistent.wholesale )
	{
		local factory = factory_x(consumer.pos.x,consumer.pos.y)
		local consumed = factory.input[name_planks].get_consumed().reduce(sum)
		if (consumed >= target_good_1) planks++
	}
	if (planks >= count / 2) persistent.tunnel_max = 1
	if (planks >= count) persistent.tunnel_max = 2
	// check concrete and steel for additional levels
	if ( persistent.tunnel_max == 2 )
		foreach ( consumer in persistent.wholesale )
		{
			local factory = factory_x(consumer.pos.x,consumer.pos.y)
			local concrete = factory.input[name_concrete].get_consumed().reduce(sum)
			local steel = factory.input[name_steel].get_consumed().reduce(sum)
			if ( (concrete >= target_good_2) && (steel >= target_good_2) )
				persistent.tunnel_max++
		}
	if (! (old_tunnel_max == persistent.tunnel_max) )
	{
		local text = ttext("Maximum Tunnel Level changed to {level} Level.")
		text.level = persistent.tunnel_max
		gui.add_message( text.tostring() )
	}
}


function get_percentage(pl)
{
	local tourism_happy  = 0
	local tourism_unhappy= 0
	local percentage     = 0
	foreach ( point in tourism )
	{
		local halt = tile_x( point.pos.x, point.pos.y, point.pos.z ).get_halt()
		if (! (halt == null))
		{
			tourism_happy+= min(halt.get_happy().reduce(sum) - halt.get_happy()[0],point.happy) * point.factor
			if (halt.get_unhappy().reduce(sum) > point.unhappy)
				tourism_unhappy++
		}
	}
	// for game target get maximum 99%
	if (tourism_target < 1) return 0
	percentage = min( (tourism_happy * 100 / tourism_target), 99)
	// a big HQ gives 1%
	if ( hq_level(pl) >= 2) percentage++
	// if there are to many unhappy reduce percentage
	percentage = min( percentage, 100 - tourism_unhappy )
	return percentage
}


function is_work_allowed_here(pl, tool_id, pos)
{
	local result = null               // null is equivalent to 'allowed'
	if (tool_id == tool_setslope)     result = terra_forming_allowed(pos)
	if (tool_id == tool_build_tunnel) result = tunnel_allowed(pos)
	return result
}


function update()                // update for older versions
{
	local text = ttext("Savegame has a different {more_info} script version! Maybe, it will work.")
	text.more_info = "(0." + (persistent.version + 1) + ")"
	gui.add_message( text.tostring() )
	// version 0.1
	if (persistent.version <= 0)
	{
		tourism.Mt_Feld.happy    = 30  // secession Chapel missing
		tourism.Mt_Bonette.happy = 30  // secession Chapel missing
		tourism.Mt_Penna.happy   = 30  // secession Chapel missing
		foreach ( point in tourism )   // add factor
			point.factor <- 1
	}
	// DONE old versions
	persistent.version = version    // change the old version number
}

// END OF FILE