
map.file = "scenario_1.sve"

scenario.short_description = "Produce cars"
scenario.author = "unknown (scripting by Dwachs)"
scenario.version = "0.1"

function get_rule_text(pl)
{
	return "No rules. Only pressure to win."
}

function get_goal_text(pl)
{
	return @"Supply the car seller at (86,35). <br><br>
	The scenario is won if car shop starts selling."
}

function get_info_text(pl)
{
	return @"Your transport company is engaged to help the people of Steinenbruck to be able to leave the wilderness."
}

function get_result_text(pl)
{
	local con = get_car_consumption()

	local text = "The car dealer sold " + con + " cars."
	if ( con > 0 )
		text = "<it>Congratulation!</it><br> <br> You won the scenario!"
	else
		text = "Steinenbruck people are still bound to stay in their boring village."

	return text
}

// accessor to the car statistics
local car_slot = null

function start()
{
	car_slot = factory_x(86, 35).input.Autos
}

function get_car_consumption()
{
	return car_slot.consumed.reduce( max )
}

function is_scenario_completed(pl)
{
	// make the car shop sell something
	return  get_car_consumption() > 0 ? 100 : 0;
}
