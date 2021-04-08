/*
 *  class chapter_01
 *
 *
 *  Can NOT be used in network game !
 */


class tutorial.chapter_01 extends basic_chapter
{
	chapter_name  = "Getting Started"
	chapter_coord = coord(113,189)
	startcash     = 500000   				// pl=0 startcash; 0=no reset
	
	comm_script = false

	// Step 1 =====================================================================================
	c_cty = coord(92,33)
	c_fac = coord(95,39)
	c_st  = coord(91,26)
	tx_cty = translate("This is a town centre")
	tx_fac = translate("This is a factory")
	tx_st = translate("This is a station")
	tx_link = translate("This is a link")

	// Step 2 =====================================================================================
	c_test = coord3d(0,0,1)

	// Step 3 =====================================================================================
	c_buil1=coord3d(95,33,0)
	c_buil2=coord3d(95,30,0)
	buil1_name = ""
	buil2_name = ""

	// Step 4 =====================================================================================
	postc={ a = coord(92,33), b = coord(93,34) }
	city_lim = {a = coord(83,21), b = coord(103,42)}
	cty1 = {c = coord(92,33), name = ""}
	
	function start_chapter()  //Inicia solo una vez por capitulo
	{
		cty1.name = get_city_name(cty1.c)
		local t1 = my_tile(c_buil1)
		local buil1 = t1.find_object(mo_building)
		buil1_name = buil1 ? translate(buil1.get_name()):"No exite"

		local t2 = my_tile(c_buil2)
		local buil2 = t2.find_object(mo_building)
		buil2_name = buil1 ? translate(buil2.get_name()):"No exite"
		return 0
	}

	function set_goal_text(text){
		switch (this.step) {
			case 1:
				text.pos = c_cty.href("("+c_cty.tostring()+")")
				text.pos1 = c_cty.href(""+tx_cty+" ("+c_cty.tostring()+")")
				text.pos2 = c_fac.href(""+tx_fac+" ("+c_fac.tostring()+")")
				text.pos3 = c_st.href(""+tx_st+" ("+c_st.tostring()+")")
				text.link = "<a href='script:script_text()'>"+tx_link+"  >></a>"
			break;
			case 3: 
				text.pos = "<a href=\"("+c_buil1.x+","+c_buil1.y+")\">"+buil1_name+" ("+c_buil1.tostring()+")</a>"
				text.buld_name = "<a href=\"("+c_buil2.x+","+c_buil2.y+")\">"+buil2_name+" ("+c_buil2.tostring()+")</a>"
			break;
			case 4: 
				text.pos2 = "<a href=\"("+postc.a.x+","+postc.a.y+")\">" + translate("Town Centre")+" ("+postc.a.tostring()+")</a>"
			break;
			
		}
		text.town = cty1.name
		text.tool1 = tool_alias.inspe
		return text
	}
	
	function is_chapter_completed(pl) {
		local percentage=0
		local txt=c_test.tostring()
		switch (this.step) {
			case 1:
				if (pot0 == 1) {
					//reset_pot()
					this.next_step()
				}
				return percentage
				break

			case 2:
				if (txt!="0,0,1" || pot0 == 1) {
					//Creea un cuadro label
					local opt = 0
					local del = false
					local text = "X"
					label_bord(city_lim.a, city_lim.b, opt, del, text)
					this.next_step()
				}
				return percentage
				break
		
			case 3:
				local next_mark = true

				if(pot0==0){
					try {
						 next_mark = delay_mark_tile(c_buil1, c_buil1, 0)
					}
					catch(ev) {
						return 0
					}
				}
				else if (pot0==1 && pot1==0){
					local stop_mark = true
					try {
						 next_mark = delay_mark_tile(c_buil1, c_buil1, stop_mark)
					}
					catch(ev) {
						return 0
					}
					pot1=1
				}
				else if(pot2==0){
					try {
						 next_mark = delay_mark_tile(c_buil2, c_buil2, 0)
					}
					catch(ev) {
						return 0
					}
				}
				else if(pot2==1 && pot3==0){
					local stop_mark = true
					try {
						 next_mark = delay_mark_tile(c_buil2, c_buil2, stop_mark)
					}
					catch(ev) {
						return 0
					}
					pot3=1
				}
				if (pot3==1 && pot4==0){
					comm_script = false
					this.next_step()
				}
				return percentage
				break
			case 4:
				local next_mark = true

				try {
					 next_mark = delay_mark_tile(postc.a, postc.b, 0)
				}
				catch(ev) {
					return 0
				}

				if ((pot0 == 1 && next_mark)){
					comm_script = false
					this.next_step()
				}
			break
			case 5:
				persistent.step=1
				persistent.status.step = 1
				return 100
			break

		}
		//percentage=33*(this.step-1)+1
		return 0
	}
	
	function is_work_allowed_here(pl, tool_id, pos) {
		local label = tile_x(pos.x,pos.y,pos.z).find_object(mo_label)
		local result=null	// null is equivalent to 'allowed'
		
		result = translate("Action not allowed")

		switch (this.step) {
			case 1:
				break
			case 2:
				break
			case 3: 
				if(pot0==0){
					if ((tool_id == 4096)&&(pos.x == c_buil1.x)&&(pos.y == c_buil1.y)){
						pot0 = 1
						return null
					}
				}
				else if (pot1==1 && pot2==0){
					if ((tool_id == 4096)&&(pos.x == c_buil2.x)&&(pos.y == c_buil2.y)){
						pot2 = 1
						return null
					}
				}
				break
			case 4:
				if ((tool_id == 4096 )&&(pos.x>=postc.a.x)&&(pos.x<=postc.b.x)&&(pos.y>=postc.a.y)&&(pos.y<=postc.b.y)){
					pot0 = 1
					return null
				}
					
				break
		}
		if (tool_id == 4096){	
			if (label && label.get_text()=="X")
				return translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."		
			else if (label)	
				return translate("Text label")+" ("+pos.tostring()+")."
			result = null	// Always allow query tool
		}
		if (label && label.get_text()=="X")
			return translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."	

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
		if (this.step==1){
			pot0=1
		}
		else if (this.step==2){
			pot0 = 1
		}
		else if(this.step==3){
			comm_script = true
			//Creea un cuadro label
			local opt = 0
			local del = false
			local text = "X"
			label_bord(city_lim.a, city_lim.b, opt, del, text)
			pot0=1
			pot2=1
			//this.next_step()
		}
		else if (this.step==4){
			comm_script = true
			pot0 = 1
		}	
		return null
	}
}        // END of class

// END OF FILE
