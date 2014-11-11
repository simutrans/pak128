/*
 *  Produce cars - scenario
 *
 *  tested with 120.0.1 nightly r7356, pak128 r1490
 *
 */

const version		  = 202	       		       	// version of script
map.file			  = "cars_v02.sve"     		// specify the savegame to load
scenario.short_description = "Produce cars"              // scenario name
scenario.author            = "ny911, Dwachs"
scenario.translation      <- "en=ny911, de=ny911"
scenario.api		 <- "112.3"			// scenario relies on this version of the api
scenario.version           = (version / 1000) + "." + ((version % 1000) / 100) + "." + ((version % 100) / 10) + (version % 10)

car_slot			 <- null			// accessor to the car statistics
cardealer		 <- {x = 86, y = 35}            // coord of the car dealer shop in map
amount_target		 <- 200				// amount of cars to be consumed


function get_rule_text(pl)
{
	return translate("No rules. Only pressure to win.")
}


function get_goal_text(pl)
{
	local point = "(" + cardealer.x + "," + cardealer.y + ")"
	local text  = ttext("Supply the car seller at {link}.<br><br>The scenario is won if car shop sells more then {amount} cars.")
	text.link   = "<a href='" + point + "'>" + point + "</a>"
	text.amount = amount_target
	return text.tostring()
}


function get_info_text(pl)
{
	local text = ttext("Your transport company is engaged to help the people of {cityname} to be able to leave the wilderness.")
	text.cityname = "<a href='(83,33)'>" + translate("Steinenbruck") + "</a>"
	return text.tostring()
}


function get_result_text(player)
{
	local text2  = ""
	local text1  = ttext("The car dealer sold {amount} cars.<br>")
	text1.amount = car_slot.consumed.reduce(sum)
	if ( is_scenario_completed(player) == 100 )
		text2 = translate("<it>Congratulation!</it><br><br>You won the scenario!")
	else
	{
		text2 = ttext("Some {cityname} people are still bound to stay in their boring village.")
		text2.cityname = translate("Steinenbruck")
		text2 = text2.tostring()
	}
	return text1.tostring()+text2
}


function start()
{
	car_slot = factory_x( cardealer.x, cardealer.y ).input.Autos
         settings.set_industry_increase_every(0) 	// correct set of industry_increase !!!
	translate_all_city_names()			// make citynames translate by [lang].tab
}


function is_scenario_completed(player)
{
         if (player != 0) return 0			// only human player
	local cars = car_slot.consumed.reduce(sum)
	return min(100 * cars / amount_target, 100)	// did the car dealer sell (consumed) the target amount
}


function translate_all_city_names()
{
	foreach ( city in city_list_x() )
	{
		local name = translate( city.get_name() )
		if (name != "") city.set_name( name )
	}
}


function sum(a,b)				     	// to use:  [array].reduce( sum )
{
	return a+b
}