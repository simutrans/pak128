
map.file = "tramadness.sve"

scenario.short_description = "TraMMadness"
scenario.author = "Optimix (scripting by Dwachs)"
scenario.version = "0.2"


// error messages
const err_station_protected = "This station cannot be removed or expanded."
const err_no_station_expansion = "No expansion of stations allowed."
const err_no_headquarter = "Your company's headquarter is in Oxford. You do not have the executive rights to move it."

// texts
function get_info_text(pl)
{
	return ttextfile("info.txt")
}

function get_rule_text(pl)
{
	return ttextfile("rule.txt")
}

function get_goal_text(pl)
{
	return ttext("The scenario is won as soon as there is a passenger appearing at Cambridge TOP station.")
}

function get_result_text(pl)
{
	if (is_scenario_completed(pl))
		return ttext("<it>Congratulation!</it><br> <br> You won the scenario!")
	else
		return ttext("There is still no passenger at Cambridge TOP station.")
}

function is_work_allowed_here(pl, tool_id, pos)
{
	// no extension of existing stations
	if (tool_id == tool_build_station) {
		for(local i=-1; i<=1; i++) {
			for(local j=-1; j<=1; j++) {
				if ( (i!=0  ||  j!=0)  &&  world.is_coord_valid({x=pos.x+i, y=pos.y+j}) ) {
					if(square_x(pos.x + i, pos.y + j).halt) {
						return ttext(err_no_station_expansion)
					}
				}
			}
		}
	}

	// do not build headquarter
	if (tool_id == tool_headquarter) {
		return ttext(err_no_headquarter)
	}

	return null // null is equivalent to 'allowed'
}

local halt = null

function start()
{
	// only road and tram allowed
	foreach(wt in all_waytypes) {
		if (wt != wt_tram) {
			if (wt != wt_road) {
				rules.forbid_way_tool(0, tool_build_way, wt)
				rules.forbid_way_tool(0, tool_build_bridge, wt)
				rules.forbid_way_tool(0, tool_build_tunnel, wt)
				rules.forbid_way_tool(0, tool_build_station, wt)
				if (wt != wt_rail) {
					rules.forbid_way_tool(0, tool_remove_way, wt)
				}
			}
			rules.forbid_way_tool(0, tool_remove_wayobj, wt)
			rules.forbid_way_tool(0, tool_build_wayobj, wt)
			rules.forbid_way_tool(0, tool_build_depot, wt)

			if (wt != wt_rail) {
				rules.forbid_way_tool(0, tool_build_roadsign, wt)
			}
		}
	}

	// protect main stations
	rules.forbid_way_tool_rect(0, tool_remover, wt_all, { x=25, y=45, z=5 }, { x=25, y=45, z=5 }, ttext(err_station_protected))
	rules.forbid_way_tool_rect(0, tool_remover, wt_all, { x=34, y=39, z=0 }, { x=34, y=39, z=0 }, ttext(err_station_protected))
	rules.forbid_way_tool_rect(0, tool_remover, wt_all, { x=18, y=55, z=0 }, { x=18, y=55, z=0 }, ttext(err_station_protected))

	rules.forbid_way_tool_rect(0, tool_remove_way, wt_all, { x=25, y=45, z=5 }, { x=25, y=45, z=5 }, ttext(err_station_protected))
	rules.forbid_way_tool_rect(0, tool_remove_way, wt_all, { x=34, y=39, z=0 }, { x=34, y=39, z=0 }, ttext(err_station_protected))
	rules.forbid_way_tool_rect(0, tool_remove_way, wt_all, { x=18, y=55, z=0 }, { x=18, y=55, z=0 }, ttext(err_station_protected))

	resume_game()
}

function resume_game()
{
	// initialize variable to access the stations statistics
	halt = tile_x(25, 45, 5).halt
}


function is_scenario_completed(pl)
{
	local happy = halt.happy.reduce( function(a,b){return a+b;} )
	if (happy > 0)
		return 100 // complete
	return 0
}

