/*
 *  class chapter_00
 *
 *
 *  Can NOT be used in network game !
 */

class tutorial.chapter_00 extends basic_chapter
{
	chapter_name  = "Checking Compatibility"
	chapter_coord = coord(0,0)
	startcash     = 10   				// pl=0 startcash; 0=no reset

	comm_script = false

	function start_chapter()  //Inicia solo una vez por capitulo
	{
		return 0
	}

	function set_goal_text(text){
		local tx_a = format("<em>%s %s<em>",pak_name, translate("OK"))
		if(!resul_version.pak) tx_a = "<st>"+pak_name+"</st>"

		local tx_b = format("<em>v%s %s<em>",simu_version, translate("OK"))
		if(!resul_version.st) tx_b = "<st>v"+simu_version+"</st>"

		text.pak = tx_a
		text.stv = tx_b

		text.current_stv = current_st
		text.current_pak = current_pak
		return text
	}
	
	function is_chapter_completed(pl) {

		this.step = 1
		return 0
		
	}
	
	function is_work_allowed_here(pl, tool_id, pos) {
		local label = tile_x(pos.x,pos.y,pos.z).find_object(mo_label)
		local result=null	// null is equivalent to 'allowed'
		
		result = translate("Action not allowed")

		return result	
	}
	
	function is_schedule_allowed(pl, schedule) {
		local result=null	// null is equivalent to 'allowed'
		return translate("Creating Schedules is currently not allowed")
	}
	
	function set_all_rules(pl) {
		local forbid =	[	4129,tool_build_way,tool_build_bridge,tool_build_tunnel,tool_build_station,
							tool_remove_way,tool_build_depot,tool_build_roadsign,tool_build_wayobj
						]
		foreach(wt in all_waytypes)
			foreach (tool_id in forbid) {
				rules.forbid_way_tool(pl, tool_id, wt )
			}
		local forbid =	[	tool_remover,tool_set_marker,tool_add_city,tool_plant_tree,tool_add_citycar,tool_buy_house,
							tool_change_water_height,tool_set_climate,tool_lower_land,tool_raise_land,tool_setslope, 4137,
							tool_restoreslope,tool_make_stop_public,tool_stop_mover,tool_build_transformer,tool_build_station
						]
		foreach (tool_id in forbid)
			rules.forbid_tool(pl, tool_id )
	}
	function script_text()
	{	
		return null
	}
}        // END of class

// END OF FILE
