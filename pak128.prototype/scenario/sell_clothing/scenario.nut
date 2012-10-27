map.file = "sell_clothing.sve"

scenario.short_description = "Make & Sell Textiles"
scenario.author = "Severous (scripting by Dwachs & Freca)"
scenario.version = "0.3"

// to easily adjust difficulty
trawler_target1 <- 6
trawler_target2 <- 12
endyear <- 1940


// texts
function get_info_text(pl)
{
	local text = ttextfile("info.txt");
	text.endyear = endyear;
	return text
}

function get_rule_text(pl)
{
	local text = ttext("You can set up routes anywhere on the map and service any existing industries.") + "<br><br>"

	if (persistent.stage <= 3)
		text += ttext("-- <it>Only ships all allowed to cross the sound near Coventry. No bridges or tunnels allowed. </it>") + "<br><br>"

	return text
}


function get_goal_text(pl)
{
	local text

	if (persistent.stage < 6) {
		text = ttextfile("goal" + (persistent.stage+1) + ".txt")
	}
	else {
		text = ttext("You won the scenario!")
	}

	switch(persistent.stage) {
		case 0:
			text.trawler = trawler_target1
			break
		case 2:
			text.trawler = trawler_target2
			break
		default:
			break
	}
	return text
}


/**
 * Text on the result-tab of the scenario window.
 * It shows the reason for losing, or a comment on the last state, or what is still missing to complete the next stage.
 * Depends on the result of "is_scenario_completed(pl)", <0 is indicator for losing.
 * If game is not lost, text depends on actual stage.
 * Has to cover all possible returncodes form "is_scenario_completed(pl)".
 */
function get_result_text(pl)
{
	local percentage = is_scenario_completed(pl)
	if (percentage == -10) {
		// time out
		return ttext("<st>You lost!</st> <br> <br>You were not able to employ and keep running enough trawlers.")
	}
	if (percentage == -11) {
		// over supply of fish cannery
		return ttext("<st>You lost!</st> <br> <br>The is too much fish at the cannery.")
	}

	if (percentage == -19) {
		return ttext("<st>You lost!</st> <br> <br>You could not finish the goal within the given time frame.")
	}

	switch(persistent.stage) {
		case 0:
			local text = ttext("You are running {trawler} trawlers, which delivered {fish} tons of fish. Too less, unfortunately.")
			text.fish = fish_cannery_fish_slot.storage[0]
			text.trawler = get_trawler_count()
			return text
		case 1:
			return ttext("Your fishing transportation is running well.<br><br>No production at the steel works, yet.")

		case 2:
			local text = ttext("Steel is produced, your trawlers are running, and there are already {goods} goods at the supermarket in Coventry.")
			text.goods = get_goods_at_coventry_supermarket()
			return text
		case 3:
			return ttext("The supermarket is selling canned fish quickly.<br><br>The textile factory is not yet producing.")
		case 4:
			return ttext("The first crates of textiles can now be transported. You can are allowed to build bridges.<br><br>The supermarket in London is waiting for the first delivery.")
		case 5:
			return ttext("London seems to love canned fish!<br><br>The citizens of Salisbury are waiting eagerly to test the fish.")
		case 6:
			return ttext("You won!")
	}
	// should not happen
	return "You did not achieve anything. Absolutely."
}

/**
 * Heart of the whole scenario
 * Calculates "stage" and returns the percentage of completion of the scenario.
 * First part checks for serveral lose-conditions.
 * Second parts checks the trigger for finishing the actual stage, sets the number for the next stage
 */
function is_scenario_completed(pl)
{
	local time = world.get_time()

	// check for oversupply
	local fish_in_storage = fish_cannery_fish_slot.storage[0]
	//if (fish_cannery_fish_slot.storage[0] > fish_cannery_fish_slot.max_storage) return -11
	if (fish_in_storage  > 14910) return -11 //fabrik nimm nichts an, wenn es über 15000 geht

	// check for trawlers
	local trawlers = get_trawler_count()
	if (persistent.stage == 1  &&  trawlers < trawler_target1) return -10
	if (persistent.stage == 2  &&  trawlers < trawler_target1) return -10
	if (persistent.stage  > 2  &&  trawlers < trawler_target2) return -10

	// check for delivered textiles
	local sold_textiles = 0 //textile_factory_output.slot.delivered[0]
	if (persistent.stage < 5 && sold_textiles >0) return -12

	// .. too late
	if (time.year >= endyear) return -19

	switch(persistent.stage) {
		case 0:
			if (time.year > 1930) return -10 // lost at stage 0

			if (trawlers >= trawler_target1 && fish_in_storage > 1000) {
				persistent.stage ++;
				gui.open_info_win()
			}
			return min(10, trawlers)
		case 1:
			local stahl = steel_factory_steel_slot.storage[0]
			if (stahl > 0) {
				persistent.stage ++;
				gui.open_info_win()
			}
			return 20
		case 2:
			local received = get_goods_at_coventry_supermarket()
			if (received > 0  &&  trawlers >= trawler_target2) {
				persistent.stage ++;
				gui.open_info_win()
			}
			return 40
		case 3:
			if (textile_factory_textile_slot.storage[0] > 0) {
				// bridge & tunnel allowed
				set_rule_bridge_coventry_sound( 0 /* allow */ )

				persistent.stage ++;
				gui.open_info_win()
			}
			return 60
		case 4:
			if (get_goods_at_london_supermarket() > 0) {
				persistent.stage++
				gui.open_info_win()
			}
			return 75

		case 5:
			if (get_goods_at_salisbury_shoppingmall() > 0) {
				persistent.stage++
				gui.open_info_win()
			}
			return 95
		case 6:
			return 100
		default:
			return 97
	}
}


fish_cannery_fish_slot <- {}
coventry_supermarket_input <- {}
london_supermarket_input <- {}
textile_factory_output <- {}
steel_factory_steel_slot <-{}
textile_factory_textile_slot <-{}
salisbury_shoppingmall_input <-{}

//function to count trawlers, only for this scenario
function get_trawler_count()
{
	local trawlers = 0
	local fish_catg = good_desc_x("fish").catg_index
	local list = convoy_list_x()
	foreach(cnv in list) {
		if (cnv.waytype == wt_water) {
			if (cnv.goods_catg_index.find( fish_catg) != null  &&  cnv.transported_goods.reduce(max)>0) {
				trawlers++
			}
		}
	}
	return trawlers
}

//function to check if there is something in the input slots
function get_goods(input)
{
	local received = 0;
	foreach(slot in input) {
		received += slot.received[0]
	}
	return received
}

function get_goods_at_coventry_supermarket()
{
	return get_goods(coventry_supermarket_input)
}


function get_goods_at_london_supermarket()
{
	return get_goods(london_supermarket_input)
}

function get_goods_at_salisbury_shoppingmall()
{
	return get_goods(salisbury_shoppingmall_input)
}

// called only when scenario is started
function start()
{
	persistent.stage <- 0

	set_rule_bridge_coventry_sound( 1 /* forbid */ )

	resume_game()
}

// called when game is loaded
function resume_game()
{
	// init factory accessors
	fish_cannery_fish_slot = factory_x(1600, 21).input.fish
	coventry_supermarket_input  = factory_x(1621, 8).input
	london_supermarket_input = factory_x(740,79).input
	salisbury_shoppingmall_input = factory_x(11,58).input
	textile_factory_output = factory_x(1609,9).output
	textile_factory_textile_slot = factory_x(1609,9).output.textile
	steel_factory_steel_slot = factory_x(850,56).output.Stahl

	if ( !("stage" in persistent)) {
		persistent.stage <- 0
	}
}

// no bridge across any of these tiles
local coventry_sound = [
	{x=1536, y=127},
	{x=1536, y=97},
	{x=1548, y=97},
	{x=1548, y=47},
	{x=1585, y=47},
	{x=1585, y=20},
	{x=1598, y=20},
	{x=1598, y=0}
]
local err_no_bridge = "The fish industry does not allow to interfere with its enterprises in Coventry sound."

function set_rule_bridge_coventry_sound(forbid)
{
	for(local i=0; i<coventry_sound.len()-1; i++) {
		if (forbid == 1) {
			rules.forbid_way_tool_rect(player_all, tool_build_bridge, wt_all, coventry_sound[i], coventry_sound[i+1], err_no_bridge)
		}
		else {
			rules.allow_way_tool_rect(player_all, tool_build_bridge, wt_all, coventry_sound[i], coventry_sound[i+1])
		}
	}
}
