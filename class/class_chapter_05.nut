/*
 *  class chapter_05
 *
 *
 *  Can NOT be used in network game !
 */

//Step 2 =====================================================================================
ch5_cov_lim1 <- {a = 20 , b = 31}

//Step 4 =====================================================================================
ch5_cov_lim2 <- {a = 30 , b = 34}
ch5_cov_lim3 <- {a = 33 , b = 35}


class tutorial.chapter_05 extends basic_chapter
{
	chapter_name  = "Industrial Efficiency"
	chapter_coord = coord(60,7)
	startcash     = 500000	   				// pl=0 startcash; 0=no reset

	wayend = 0
	coorbord = 0
	cov_cir = 0

	comm_script = false

	sch_cov_correct = false

	//Step 1 =====================================================================================
	c_fab_list = [coord(36,4), coord(95,39), coord(76,26),  coord(76,77),  coord(74,47)]
	c_fab_lim =	[	{a = coord(36,4), b = coord(36,6)}, {a = coord(95,39), b = coord(97,41)},
					{a = coord(76,26), b = coord(78,28)}, {a = coord(76,77), b = coord(77,78)}
					{a = coord(74,47), b = coord(76,49)}
				]
	f_name =	[	translate("grain_mill"), translate("Raffinerie"), translate("bakery"), 
					translate("shaft_coal_mine"), translate("old_powerplant_kraftwerk")
				]

	//Step 2 =====================================================================================
	//Para la carretera
	//------------------------------------------------------------------------------------------
	c_way_lim1 = {a = coord(70,50), b = coord(80,76)}
	c_way1 = {a = coord3d(77,76,0), b = coord3d(75,50,-1)}

	//Limites del deposito y rieles
	//--------------------------------------------------------------------------------------------
	c_dep1_lim = {b = coord(78,75), a = coord(77,75)}
	c_dep1 = coord(78,75)
	
	sch_list1 = [coord(77,76), coord(75,50)]
	veh1_name = translate("PMNV_50_Mack")
    veh1_obj = "PMNV_50_Mack"
	veh1_load = 100
	veh1_wait = 0
	d1_cnr = 10
	f1_good = good_alias.coal

	//Step 3 =====================================================================================
    transf_list = [coord(37,6), coord(94,39), coord(77,25), coord(75,77), coord(77,47)]
    f_power = 0
    f_pow_list = [0,0,0,0]

    pow_lim = [{a = coord(35,0), b = coord(78,12)}, {a = coord(72,12), b = coord(78,79)}, {a = coord(78,34), b = coord(95,41)}]

    label_del =  [{a = coord(73,12), b = coord(77,12)}, {a = coord(78,35), b = coord(78,40)}]

	//Step 4 =====================================================================================
    st_name = "PostOffice"
    obj_list1 = [coord(99,45), coord(96,37), coord(98,27), coord(86,27), coord(81,32), coord(76,30), coord(88,31), coord(90,37)]

	//Para el Camion
    veh2_name = translate("RVg_Type_S_Post")
    veh2_obj = "RVg_Type_S_Post"
    c_dep2 = coord(98,33) // depot
	line1_name = "Test 6"
    sch_list2 = [coord(99,44), coord(96,38), coord(98,28), coord(87,27), coord(81,31), coord(76,29), coord(88,32), coord(91,37)]
	veh2_load = 100
	veh2_wait = 12
	d2_cnr = 3

	//Para el barco
	sch_list3 = [coord(98,47), coord(113,57)]
	veh3_name = translate("MV_Balmoral")
	veh3_obj = "MV_Balmoral"
	veh3_load = 100
	veh3_wait = 16
    c_dep3 = coord(94,44) // depot

	//Script
	//----------------------------------------------------------------------------------
	sc_way_name = "Road_070"
	sc_station_name = "CarStop"
	sc_dep_name = "CarDepot"
	sc_trail_name = "PMNV_Mack_Bulk_Trailer_0"
	sc_trail_nr = 1
	sc_barge_mail_name = "Ferry_Mail_Extension_(small)"
	sc_barge_mail_nr = 1

	sc_power_name = "Powerline"
	sc_transf_name = "Aufspanntransformator"

	function start_chapter()  //Inicia solo una vez por capitulo
	{
		rules.clear()
		set_all_rules(0)

		local pl = 0
		if(this.step == 4){
			//Camion de correo
            local c_dep = this.my_tile(c_dep2)
			local c_list = sch_list2
			start_sch_tmpsw(pl,c_dep, c_list)

			//Barco de Correo/Pasajeros
            c_dep = this.my_tile(c_dep3)
			c_list = sch_list3
			start_sch_tmpsw(pl,c_dep, c_list)
		}

		return 0
	}

	function set_goal_text(text){
    local ok_tx =  translate("Ok")
    local trf_name = translate("Build drain")    //Aufspanntransformator 
    local toolbar = translate("SPECIALTOOLS")
    
    switch (this.step) {
		case 1:
		break
		case 2:
			local c_w1 = coord(c_way1.a.x, c_way1.a.y)
			local c_w2 = coord(c_way1.b.x, c_way1.b.y)

			text.w1 = c_w1.href("("+c_w1.tostring()+")")
			text.w2 = c_w2.href("("+c_w2.tostring()+")")

			text.dep = c_dep1.href("("+c_dep1.tostring()+")")
			text.veh = veh1_name
			text.good = translate(f1_good)
			text.all_cov = d1_cnr
			text.cir = cov_cir
			text.load = veh1_load
			text.wait = get_wait_time_text(veh1_wait)
		break
		case 3:
        if (pot0==0){
          text = ttextfile("chapter_05/03_1-2.txt")
          text.tx="<em>[1/2]</em>"
          text.trf_name = trf_name 
          text.toolbar = toolbar

          local tran_tx = ""
          for(local j=0;j<transf_list.len();j++){
                if (glsw[j]==0){
                    tran_tx +=format("<st>%s %d</st> ", trf_name, j+1) + transf_list[j].href("("+transf_list[j].tostring()+")") + "<br/>" 
                }
                else {
                    tran_tx +=format("<em>%s %d</em> ",trf_name ,j+1)+"("+transf_list[j].tostring()+") <em>"+ok_tx+"</em><br/>" 
                }
            }
	      text.tran = tran_tx
	      }

          else if (pot0==1 && pot1==0){
		      text = ttextfile("chapter_05/03_2-2.txt")
		      text.tx="<em>[2/2]</em>"
              text.powerline_tool = translate("Powerline")
              text.toolbar = toolbar
           
              local tran_tx = ""
              local f_list = c_fab_list
              for(local j=0;j<f_list.len();j++){
		         if (glsw[j]==0){
						tran_tx +=format("<st>%s</st> ",f_name[j]) + f_list[j].href("("+f_list[j].tostring()+")") + "<br/>" 
                 }
                  else {
                    tran_tx +=format("<em>%s</em> ",f_name[j]) + "("+f_list[j].tostring()+") <em>"+translate("OK")+"</em><br/>" 
                 }
              }
              f_power = f_power + f_pow_list[0] + f_pow_list[1] + f_pow_list[2] 
              text.pow = f_power
              text.tran = tran_tx
        }
		break
		case 4:
        if (pot0==1 && pot1==0){
			text = ttextfile("chapter_05/04_1-3.txt")
			text.tx="<em>[1/3]</em>"
			text.toolbar = toolbar
			local st_tx = ""
			local c_list = obj_list1  //Lista de build
			local siz = c_list.len()
			local offi_name = translate("PostOffice")
			for(local j=0;j<siz;j++){
				if (glsw[j]==0){
					st_tx +=format("<st>%s %d</st> ",offi_name, j+1) + c_list[j].href("("+c_list[j].tostring()+")")+"<br/>" 
				}
				else {
					st_tx +=format("<em>%s %d</em> ",offi_name ,j+1)+"("+c_list[j].tostring()+")<em>"+ok_tx+"</em><br/>" 
				}
			}
			text.st = st_tx
		}
        if (pot1==1 && pot2==0 || !correct_cov){
			text = ttextfile("chapter_05/04_2-3.txt")
			text.tx = "<em>[2/3]</em>"
			local list_tx = ""
			local c_list = sch_list2
			local siz = c_list.len()
			for (local j=0;j<siz;j++){
				local c = coord(c_list[j].x, c_list[j].y)
				local tile = my_tile(c)
				local st_halt = tile.get_halt()
				if(sch_cov_correct){
					list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
					continue
				}
				if(tmpsw[j]==0){
					list_tx += format("<st>%s %d:</st> %s<br>", translate("Stop"), j+1, c.href(st_halt.get_name()+" ("+c.tostring()+")"))
				}
				else{						
					list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
				}
			}
			local c = coord(c_list[0].x, c_list[0].y)
			local tile = my_tile(c)
			text.stnam = "1) "+tile.get_halt().get_name()+" ("+c.tostring()+")"

			text.list = list_tx
			text.dep = c_dep2.href("("+c_dep2.tostring()+")")
			text.veh = veh2_name
			text.all_cov = d2_cnr
			text.cir = cov_cir
			text.load = veh2_load
			text.wait = get_wait_time_text(veh2_wait)
		}
        if (pot2==1 && pot3==0 || !correct_cov){
			text = ttextfile("chapter_05/04_3-3.txt")
			text.tx = "<em>[3/3]</em>"
			local list_tx = ""
			local c_list = sch_list3
			local siz = c_list.len()
			for (local j=0;j<siz;j++){
				local c = coord(c_list[j].x, c_list[j].y)
				local tile = my_tile(c)
				local st_halt = tile.get_halt()
				if(sch_cov_correct){
					list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
					continue
				}
				if(tmpsw[j]==0){
					list_tx += format("<st>%s %d:</st> %s<br>", translate("Stop"), j+1, c.href(st_halt.get_name()+" ("+c.tostring()+")"))
				}
				else{						
					list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
				}
			}
			local c = coord(c_list[0].x, c_list[0].y)
			local tile = my_tile(c)
			text.stnam = "1) "+tile.get_halt().get_name()+" ("+c.tostring()+")"

			text.list = list_tx
			text.dep = c_dep3.href("("+c_dep3.tostring()+")")
			text.ship = veh3_name
			text.load = veh3_load
			text.wait = get_wait_time_text(veh3_wait)
		}
		break
		case 5:

		break
		case 6:

		break
		case 7:
		break

		case 8:
		break

		case 9:	
        break
	    }

        text.f1 = c_fab_list[0].href(""+f_name[0]+" ("+c_fab_list[0].tostring()+")")+""
	    text.f2 = c_fab_list[1].href(""+f_name[1]+" ("+c_fab_list[1].tostring()+")")+""
	    text.f3 = c_fab_list[2].href(""+f_name[2]+" ("+c_fab_list[2].tostring()+")")+""
	    text.f4 = c_fab_list[3].href(""+f_name[3]+" ("+c_fab_list[3].tostring()+")")+""
	    text.f5 = c_fab_list[4].href(""+f_name[4]+" ("+c_fab_list[4].tostring()+")")+""

		text.tool1 = tool_alias.inspe
		text.tool2 = tool_alias.road
		text.tool3 = tool_alias.spec

	    return text
	}
	
	function is_chapter_completed(pl) {
		local percentage=0
		save_glsw()
		save_pot()
		switch (this.step) {
			case 1:
				if(pot0==1){
					this.next_step()
				}
				return 0
			break;
			case 2:
				if (pot0==0){
					local coora = coord3d(c_way1.a.x,c_way1.a.y,c_way1.a.z)
					local coorb = coord3d(c_way1.b.x,c_way1.b.y,c_way1.b.z)

					local t_start = tile_x(coora.x,coora.y,coora.z)
					local t_end = tile_x(coorb.x,coorb.y,coorb.z)

					if(!t_start.find_object(mo_way)){
						label_x.create(coord(coora.x, coora.y), player_x(0), translate("Place the Road here!."))
					}
					else t_start.remove_object(player_x(0), mo_label)

					if(!t_end.find_object(mo_way)){
						label_x.create(coord(coorb.x, coorb.y), player_x(0), translate("Place the Road here!."))
					}
					else t_end.remove_object(player_x(0), mo_label)

					if (coorbord != 0){
						//Creea un cuadro label
						local opt = 0
						local del = false
						local text = "X"
						label_bord(c_way_lim1.a, c_way_lim1.b, opt, del, text)		
					}

					//Comprueba la conexion de la via
					local obj = false
					local dir = 2		
					local fullway = get_fullway(coora, coorb, dir, obj)

					if (fullway==0){
						coorbord = 0
						//elimina el cuadro label
						local opt = 0
						local del = true
						local text = "X"
						label_bord(c_way_lim1.a, c_way_lim1.b, opt, del, text)

						pot0=1
						return 10
					}
					else {
						coorbord = fullway
					}
				}
				else if (pot0==1 && pot1==0){
					local siz = sch_list1.len()
					local c_list = sch_list1
					local name =  translate("Place Stop here!.")
					local load = good_alias.goods
					local all_stop = is_stop_building(siz, c_list, name, load)

					if (all_stop){
						reset_glsw()
						pot1=1
					}
				}
				else if (pot1==1 && pot2==0){
					local tile = my_tile(c_dep1)
					if(!tile.find_object(mo_way)){
						label_x.create(c_dep1, player_x(0), translate("Place the Road here!."))
					}
					else {

						if (!tile.find_object(mo_depot_road)){
							label_x.create(c_dep1, player_x(0), translate("Build a Depot here!."))
						}
						else{
							tile.remove_object(player_x(0), mo_label)
							pot2=1
						}	
					}
				}
				else if (pot2==1 && pot3==0){
					cov_cir = get_convoy_nr((ch5_cov_lim1.a), d1_cnr)

					//gui.add_message(""+cov_cir+"")
					if (cov_cir == d1_cnr){
						this.next_step()
					}
				}
				return 0
			break;
			case 3:
                if (pot0==0){
					local transf_count = 0
                    for(local j=0;j<transf_list.len();j++){
                        local tile = my_tile(transf_list[j])
                        local f_transfc = tile.find_object(mo_transformer_c)
                        local f_transfs = tile.find_object(mo_transformer_s)
                        if (f_transfc || f_transfs){
                            glsw[j]=1
							transf_count++
                        }
                        else
                            label_x.create(transf_list[j], player_x(0), translate("Transformer Here!."))
                    }

					if(transf_count == transf_list.len()){
                        pot0 = 1
						reset_glsw()

						//Crear cuadro label para las power line
						local opt = 0
                        local del = false
						for(local j = 0;j<pow_lim.len();j++){
							label_bord(pow_lim[j].a, pow_lim[j].b, opt, del, "X")
						}
                        //Elimina cudro label
                        del = true
						for(local j = 0;j<label_del.len();j++){
							label_bord(label_del[j].a, label_del[j].b, opt, del, "X")
						}
                        return 20
                    }  
                }
                else if (pot0==1 && pot1 == 0){
					local f_list = c_fab_list
					local f_tile_t = my_tile(transf_list[4])
					local f_transf = f_tile_t.find_object(mo_transformer_s)
			           // f_power = 0
					for(local j=0;j<f_list.len();j++){
						local tile = my_tile(f_list[j])
						local factory = tile.find_object(mo_building).get_factory()
						if (factory){
						    if(factory.is_transformer_connected()){
						        local transf = factory.get_transformer()
						        if (transf.is_connected(f_transf)){
									glsw[j] = 1
						        }
						    }
						}  
					}              
					if (glsw[0] == 1 && glsw[1] == 1 && glsw[2] == 1 && glsw[3] == 1){
						//Elimina cuadro label para las power line
						local opt = 0
						local del = true

						for(local j = 0;j<pow_lim.len();j++){
							label_bord(pow_lim[j].a, pow_lim[j].b, opt, del, "X")
						}

						this.next_step()
						return 30
					}
				}
				return 0
			break;
			case 4:

				if (pot0==0){
                    local play = 1
                    local c_list = obj_list1
                    local obj = mo_building
                    local station = false
                    local lab_name = translate("Mail Extension Here!.")

                    delete_objet(play, c_list, obj, lab_name, station)
                    pot0=1  
				}
				if (pot0==1 && pot1==0){
				    local c_list = obj_list1
					local nr = c_list.len()
                    local load = good_alias.mail
                    local lab_name = translate("Mail Extension Here!.")
				    local all_stop = is_stop_building_ex(nr, c_list, lab_name, load)
				    if (all_stop && pot1==0){
					    pot1=1
					    reset_glsw()
				    }
                }
				if (pot1==1 && pot2==0){
				    local c_dep = this.my_tile(c_dep2)
                    local line_name = line1_name
                    set_convoy_schedule(pl,c_dep, wt_road, line_name)

					local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
					local cov_list = depot.get_convoy_list()		//Lista de vehiculos en el deposito
					local convoy = convoy_x(gcov_id)
					if (cov_list.len()>=1){
						convoy = cov_list[0]
					}
					local all_result = checks_convoy_schedule(convoy, pl)
					sch_cov_correct = all_result.res == null ? true : false

					cov_cir = get_convoy_nr((ch5_cov_lim2.a), d2_cnr)
					if (current_cov == ch5_cov_lim2.b){
						sch_cov_correct = false
						pot2=1
					}
                }
				if (pot2==1 && pot3==0){
				    local c_dep = this.my_tile(c_dep3)
					local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
					local cov_list = depot.get_convoy_list()		//Lista de vehiculos en el deposito
					local convoy = convoy_x(gcov_id)
					if (cov_list.len()>=1){
						convoy = cov_list[0]
					}
					local all_result = checks_convoy_schedule(convoy, pl)
					sch_cov_correct = all_result.res == null ? true : false

					if (current_cov == ch5_cov_lim3.b){
						sch_cov_correct = false
						this.next_step()
					}
				}
				return 10+percentage
				break
			case 5:
				this.step=1
				persistent.step=1
				persistent.status.step = 1
				return 100
				break
		}
		percentage=(this.step-1)+1
		return percentage
	}
	
	function is_work_allowed_here(pl, tool_id, pos) {
        //return tool_id
		glpos = coord3d(pos.x, pos.y, pos.z)
		local t = tile_x(pos.x, pos.y, pos.z)
		local ribi = 0
		local wt = 0
		local slope = t.get_slope()
		local way = t.find_object(mo_way)
        local powerline = t.find_object(mo_powerline)
		local bridge = t.find_object(mo_bridge)
		local label = t.find_object(mo_label)
		local building = t.find_object(mo_building)
		local sign = t.find_object(mo_signal)
		local roadsign = t.find_object(mo_roadsign)
		/*if (way){
			wt = way.get_waytype()
			if (tool_id!=4111)
				ribi = way.get_dirs()
			if (!t.has_way(gl_wt))
				ribi = 0
		}*/
		local result = translate("Action not allowed")		// null is equivalent to 'allowed'
		switch (this.step) {
			case 1:
				for(local j=0;j<c_fab_lim.len();j++){
					if ((pos.x>=c_fab_lim[j].a.x)&&(pos.y>=c_fab_lim[j].a.y)&&(pos.x<=c_fab_lim[j].b.x)&&(pos.y<=c_fab_lim[j].b.y)){
						if (tool_id == 4096){
							pot0=1
							return null			
						}
						else
							result = translate("You must use the inspection tool")+" ("+pos.tostring()+")."	
					}
				}
			break;

			case 2:
				if(pot0==0){
					if(pos.x>=c_way_lim1.a.x && pos.y>=c_way_lim1.a.y && pos.x<=c_way_lim1.b.x && pos.y<=c_way_lim1.b.y){
						if (!way && label && label.get_text()=="X"){
							return translate("Indicates the limits for using construction tools")+" ( "+pos.tostring()+")."	
						}
						local label = coorbord!=0 ? tile_x(coorbord.x, coorbord.y, coorbord.z).find_object(mo_label) : false
						if(label){
							if(tool_id==tool_build_way || tool_id==4113 || tool_id==tool_remover)
								return null	
						}
						else return all_control(result, wt_road, way, ribi, tool_id, pos, coorbord)
					}
				}
				else if(pot0==1 && pot1==0){
                    for(local j=0;j<sch_list1.len();j++){
                       if(pos.x==sch_list1[j].x && pos.y==sch_list1[j].y){
							if(tool_id==tool_build_station || tool_id==tool_remover){
								if(label) t.remove_object(player_x(0), mo_label)
								local c_list = sch_list1
								local good = good_alias.goods
								return is_station_truck_build(pos, tool_id, c_list, good)
							}
						}
					}
				}
				else if(pot1==1 && pot2==0){
					if(pos.x>=c_dep1_lim.a.x && pos.y>=c_dep1_lim.a.y && pos.x<=c_dep1_lim.b.x && pos.y<=c_dep1_lim.b.y){
						if(tool_id==tool_build_way || tool_id==tool_build_depot){
							if(label) t.remove_object(player_x(0), mo_label)
							return null
						}
					}
				}
				else if(pot2==1 && pot3==0){
					if (tool_id==4108) {
						local c_list = sch_list1	//Lista de todas las paradas
						local c_dep = c_dep1		//Coordeadas del deposito 
						local nr = c_list.len()		//Numero de paradas 
						result = translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep.tostring()+")."
						return is_stop_allowed(result, nr, c_list, pos)
					}
				}
			break;

			//Conectando los transformadores
			case 3:
                if (pot0==0){
                    for(local j=0;j<transf_list.len();j++){
                        if(tool_id == tool_build_transformer){
                            local f_transf = t.find_object(mo_transformer_c)
                            if (pos.x==transf_list[j].x && pos.y==transf_list[j].y){
                                if (glsw[j]==0){
                                   if(label) t.remove_object(player_x(0), mo_label)
                                   return null
                                }
                                else return  translate("There is already a transformer here!")+" ("+pos.tostring()+")."
                            }
                            else if (glsw[j]==0) result = translate("Build the transformer here!")+" ("+transf_list[j].tostring()+")."
                        }
                    }
                    if(tool_id == tool_build_transformer)
                        return result
                }
                else if (pot0==1 && pot1 == 0){
                    for(local j=0;j<pow_lim.len();j++){
                       if(pos.x>=pow_lim[j].a.x && pos.y>=pow_lim[j].a.y && pos.x<=pow_lim[j].b.x && pos.y<=pow_lim[j].b.y){
                                           
                            if(tool_id == tool_build_way || tool_id == tool_build_bridge || tool_id == tool_build_tunnel){
                               if (label && label.get_text()=="X")
						        return translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."	
                                else
                                    return null

                                 return result
                            }
                            else if (tool_id == tool_remover || tool_id == tool_remove_way){
                                if (building && !t.get_halt())
                                    return null

                                else if (powerline)
                                    return null

                                return result
                            }
                       }
                       else if (j== pow_lim.len()-1){
                            result = translate("You are outside the allowed limits!")+" ("+pos.tostring()+")."
                       }
                    }
                   if(tool_id == tool_build_way)
                       return result
                   
                }
				break
			case 4:
                if (pot0==1 && pot1==0){
                    //Permite construir paradas
					if (tool_id==4115){
						local c_list = obj_list1
						local nr = c_list.len()
                        local good = good_alias.mail
						return build_stop_ex(nr, c_list, t, label, pos, good, st_name)
					}
					
					//Permite eliminar paradas
					if (tool_id==4097){
						local nr = obj_list1.len()
						local c_list = obj_list1
						return delete_stop_ex(nr, c_list, pos)
					}
                }
                if (pot1==1 && pot2==0){
					if (tool_id==4108) {			
						local c_list = sch_list2  	//Lista de todas las paradas de autobus
						local c_dep = c_dep2 		//Coordeadas del deposito 
						local nr = c_list.len()		//Numero de paradas 
						result = translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep.tostring()+")."
						return is_stop_allowed(result, nr, c_list, pos)
					}
                }
                if (pot2==1 && pot3==0){
					if (tool_id==4108) {			
						local c_list = sch_list3 	 //Lista de todas las paradas de autobus
						local c_dep = c_dep3		 //Coordeadas del deposito 
						local siz = c_list.len()	 //Numero de paradas 
						local wt = wt_water
						result = translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep.tostring()+")."
						return is_stop_allowed_ex(result, siz, c_list, pos, wt)	
					}
                }
			break
			case 5:
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

		checks_current_line(pl, schedule)

		local result=null	// null is equivalent to 'allowed'
		if ( (pl == 0) && (schedule.waytype != wt_road) )
			result = translate("Only road schedules allowed")

		local nr = schedule.entries.len()

		switch (this.step) {
			case 2:
				local selc = 0
				local load = veh1_load
				local time = veh1_wait
				local c_list = sch_list1
				local siz = c_list.len()
				result = set_schedule_list(result, pl, schedule, nr, selc, load, time, c_list, siz)
				if(result != null) reset_tmpsw()
				return result
			break
			case 4:
				if (current_cov> ch5_cov_lim2.a && current_cov< ch5_cov_lim2.b){
					local selc = 0
					local load = veh2_load
					local time = veh2_wait
					local c_list = sch_list2
					local siz = c_list.len()
					result = set_schedule_list(result, pl, schedule, nr, selc, load, time, c_list, siz)
					if(result == null){
						local line_name = line1_name
						update_convoy_schedule(pl, wt_road, line_name, schedule)
					}
				}
				else if (current_cov> ch5_cov_lim3.a && current_cov< ch5_cov_lim3.b){
					local selc = 0
					local load = veh3_load
					local time = veh3_wait
					local c_list = sch_list3
					local siz = c_list.len()
					result = set_schedule_list(result, pl, schedule, nr, selc, load, time, c_list, siz)
				}
				return result
			break
		}
		return result
	}
	function is_convoy_allowed(pl, convoy, depot)
	{
		local result=null	// null is equivalent to 'allowed'

		switch (this.step) {
			case 2:
				if(comm_script) {
					cov_save[current_cov]=convoy
					id_save[current_cov]=convoy.id
					gcov_nr++
					persistent.gcov_nr = gcov_nr
					current_cov++
					gall_cov++
					return null
				}
				local cov = d1_cnr
				local veh = 2
				local good_list = [good_desc_x(f1_good).get_catg_index()] 	 //Coal
				local name = veh1_obj
				local st_tile = 1

				//Para arracar varios vehiculos
				local id_start = ch5_cov_lim1.a
				local id_end = ch5_cov_lim1.b
				local c_sch = sch_list1[0]
				local cir_nr = get_convoy_number_exp(c_sch, depot, id_start, id_end)
				cov -= cir_nr

				result = is_convoy_correct(depot, cov, veh, good_list, name, st_tile)

				if (result!=null){
					local name = veh1_name
					local good = translate(f1_good)
					return truck_result_message(result, name, good, veh, cov)
				}
				if (current_cov> ch5_cov_lim1.a && current_cov< ch5_cov_lim1.b){
					local selc = 0
					local load = veh1_load
					local time = veh1_wait
					local c_list = sch_list1
					local siz = c_list.len()
					return set_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
				}
			break
			case 4:
				if (current_cov> ch5_cov_lim2.a && current_cov< ch5_cov_lim2.b){
					local cov = d2_cnr
					local veh = 1
					local good_list = [good_desc_x(good_alias.mail).get_catg_index()] 	 //Mail
					local name = veh2_obj
					local st_tile = 1

					//Para arracar varios vehiculos
					local id_start = ch5_cov_lim2.a
					local id_end = ch5_cov_lim2.b
					local c_sch = sch_list2[0]
					local cir_nr = get_convoy_number_exp(c_sch, depot, id_start, id_end)
					cov -= cir_nr

					result = is_convoy_correct(depot, cov, veh, good_list, name, st_tile)

					if (result!=null){
						local name = veh2_name
						local good = translate(good_alias.mail)
						return truck_result_message(result, name, good, veh, cov)
					}
					local selc = 0
					local load = veh2_load
					local time = veh2_wait
					local c_list = sch_list2
					local siz = c_list.len()
					return set_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
				}

				else if (current_cov> ch5_cov_lim3.a && current_cov< ch5_cov_lim3.b){
					local cov = 1
					local veh = 2
					local good_list = [good_desc_x(good_alias.mail).get_catg_index(),good_desc_x(good_alias.passa).get_catg_index()]	 //Mail, pass
					local name = veh3_obj
					local st_tile = 1
					result = is_convoy_correct(depot, cov, veh, good_list, name, st_tile)

					if (result!=null){
						local name = veh3_name
						local good = ""+translate(good_alias.passa)+","+translate(good_alias.mail)+""
						return ship_result_message(result, name, good, veh, cov)
					}
					local selc = 0
					local load = veh3_load
					local time = veh3_wait
					local c_list = sch_list3
					local siz = c_list.len()
					return set_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
				}
			break
		}
		return result = translate("It is not allowed to start vehicles.")
	}

	function script_text()
	{
		switch (this.step) {
			case 1:
				if(pot0==0) pot0=1

				return null
			break;
			case 2:
				if (pot0==0){
					local coora = coord3d(c_way1.a.x,c_way1.a.y,c_way1.a.z)
					local coorb = coord3d(c_way1.b.x,c_way1.b.y,c_way1.b.z)

					local t = command_x(tool_build_way)			
					local err = t.work(player_x(0), coora, coorb, sc_way_name)
				}
				if (pot2==0){

					//Para la carretera
					local t_start = my_tile(c_dep1_lim.a)
					local t_end = my_tile(c_dep1_lim.b)
					t_start.remove_object(player_x(0), mo_label)
					local t = command_x(tool_build_way)
					local err = t.work(player_x(0), t_start, t_end, sc_way_name)

					local t_dep = my_tile(c_dep1)
					t = command_x(tool_build_depot)			
					err = t.work(player_x(0), t_dep, sc_dep_name)
				}

				if (pot1==0){
					for(local j=0;j<sch_list1.len();j++){
						local tile = my_tile(sch_list1[j])
						local way = tile.find_object(mo_way)
						tile.remove_object(player_x(1), mo_label)
						local tool = command_x(tool_build_station)			
						local err = tool.work(player_x(0), tile, sc_station_name)
					}
				}

				if (current_cov> ch5_cov_lim1.a && current_cov< ch5_cov_lim1.b){

					local pl = player_x(0)
					local c_depot = my_tile(c_dep1)

					comm_destroy_convoy(pl, c_depot) // Limpia los vehiculos del deposito

					local depot = c_depot.find_object(mo_depot_road)
					local good_nr = good_desc_x(f1_good).get_catg_index()  //Coal
					local name = veh1_obj
					local cov_nr = d1_cnr  //Max convoys nr in depot

					local sched = schedule_x(wt_road, [])
					sched.entries.append(schedule_entry_x(my_tile(sch_list1[0]), veh1_load, veh1_wait))
					sched.entries.append(schedule_entry_x(my_tile(sch_list1[1]), 0, 0))
					local hold_cov = current_cov

					local extender_name = sc_trail_name
					local siz = sc_trail_nr
					local extender = true
					comm_script = true
					for (local j = 0; j<(cov_nr); j++){
						if (!comm_set_convoy(cov_nr, c_depot, name))
							return 0
						for (local count = 0;count<siz;count++){
							if (!comm_set_convoy(j, c_depot, extender_name, extender))
								return 0
						}
					}
					local convoy = depot.get_convoy_list()
					comm_start_convoy(pl, wt_road, sched, convoy, depot)
					comm_script = false
				}

			break
			case 3:

                if (pot0==0){
					
                    for(local j=0;j<transf_list.len();j++){
                        local tile = my_tile(transf_list[j])
                        local f_transfc = tile.find_object(mo_transformer_c)
                        local f_transfs = tile.find_object(mo_transformer_s)
                        local label = tile.find_object(mo_label)	
                        if (label){
							tile.remove_object(player_x(0), mo_label)
                        }

						local tool = command_x(tool_build_transformer)			
						local err = tool.work(player_x(0), tile, sc_transf_name)
                    }
                   
                    pot0 = 1
					reset_glsw()

                    //Elimina cudro label
					local opt = 0
                    local del = true
					label_bord(label_del[0].a, label_del[0].b, opt, del, "X")
					label_bord(label_del[1].a, label_del[1].b, opt, del, "X")
                                   
                }
                if (pot0==1 && pot1 == 0){
					local tool = command_x(tool_build_way)
					local powline_name = sc_power_name
					local nr = transf_list.len()/2
					for(local j=0;j<nr;j++){
						local tile_a = my_tile(transf_list[j])
						local tile_b = my_tile(transf_list[j+1])
						local tile_c = my_tile(transf_list[j+nr])
						local tile_d = my_tile(transf_list[(transf_list.len()-j)-(1)])
						tool.work(player_x(0), tile_a, tile_c, powline_name)
						tool.work(player_x(0), tile_b, tile_d, powline_name)
					}	
           		}
				return null
				break;
			case 4:
				if (pot0==0){
                    local pl = 0
                    local c_list = obj_list1
                    local obj = mo_building
                    local station = false

					for(local j=0;j<c_list.len();j++){
						local tile = my_tile(c_list[j])
						local is_obj = tile.find_object(obj)
						local halt = tile.get_halt()
						if (is_obj){
						    if (!halt){
						        tile.remove_object(player_x(pl), obj)
						    }
						    else if (station){
						        tile.remove_object(player_x(pl), obj)
						    }
						}
					}
                    pot0=1  
				}
				if (pot0==1 && pot1==0){
				    local count=0
				    local nr = obj_list1.len()
				    local c_st = obj_list1

					for(local j=0;j<nr;j++){
						local tile = my_tile(c_st[j])
						local label = tile.find_object(mo_label)
						local halt = tile.get_halt()
						local tool = command_x(tool_build_station)

						if (label)
							tile.remove_object(player_x(1), mo_label)

						tool.work(player_x(0), tile, st_name)
						glsw[j]=1						
					}
					pot1=1
					reset_glsw()
                }
				if (current_cov> ch5_cov_lim2.a && current_cov< ch5_cov_lim2.b){

					local pl = player_x(0)
					local c_depot = my_tile(c_dep2)
					comm_destroy_convoy(pl, c_depot) // Limpia los vehiculos del deposito

					local sched = schedule_x(wt_road, [])
					local c_list = sch_list2
					local siz = c_list.len()
					for(local j = 0;j<siz;j++){
						if(j==0)
							sched.entries.append(schedule_entry_x(my_tile(c_list[j]), veh2_load, veh2_wait))
						else
							sched.entries.append(schedule_entry_x(my_tile(c_list[j]), 0, 0))
					}
					local depot = c_depot.find_object(mo_depot_road)
					local hold_cov = current_cov
					local name = veh2_obj
					local cov_nr = d2_cnr  //Max convoys nr in depot
					comm_script = true
					for (local j = 0; j<(cov_nr); j++){
						if (!comm_set_convoy(cov_nr, c_depot, name))
							return 0
					}
					local convoy = depot.get_convoy_list()
					comm_start_convoy(pl, wt_road, sched, convoy, depot)
					comm_script = false
				}

				else if (current_cov> ch5_cov_lim3.a && current_cov< ch5_cov_lim3.b){
					local pl = player_x(0)
					local c_depot = my_tile(c_dep3)
					comm_destroy_convoy(pl, c_depot) // Limpia los vehiculos del deposito

					local sched = schedule_x(wt_water, [])
					local c_list = sch_list3
					local siz = c_list.len()
					for(local j = 0;j<siz;j++){
						if(j==0)
							sched.entries.append(schedule_entry_x(my_tile(c_list[j]), veh3_load, veh3_wait))
						else
							sched.entries.append(schedule_entry_x(my_tile(c_list[j]), 0, 0))
					}

					local depot = c_depot.find_object(mo_depot_water)
					local name = veh3_obj
					local cov_nr = 1  //Max convoys nr in depot

					local extender_name = sc_barge_mail_name
					local siz = sc_barge_mail_nr
					local extender = true
					if (!comm_set_convoy(cov_nr, c_depot, name))
						return 0
					for (local count = 0;count<siz;count++){
						if (!comm_set_convoy(0, c_depot, extender_name, extender))
							return 0
					}

					local convoy = depot.get_convoy_list()
					comm_start_convoy(pl, wt_water, sched, convoy, depot)
				}
                
				return null
			break
		}
		return null
	}
	
	function set_all_rules(pl)
    {
		local forbid = [tool_remove_wayobj, tool_build_way, tool_build_bridge, tool_build_tunnel, tool_build_station,
                       tool_remove_way, tool_build_depot, tool_build_roadsign, tool_build_wayobj]

		foreach(wt in all_waytypes)
			if (wt != wt_power && wt != wt_road) {
			    foreach (tool_id in forbid)
				    rules.forbid_way_tool(pl, tool_id, wt )
			}

		local forbid =	[	4134,4135, tool_lower_land, tool_raise_land, tool_setslope, tool_build_roadsign,
        					tool_restoreslope, tool_plant_tree, tool_set_marker, tool_stop_mover, tool_buy_house, 
							tool_add_city, tool_make_stop_public, 4137, tool_build_wayobj,tool_remove_wayobj
						]

		foreach (tool_id in forbid)
		    rules.forbid_tool(pl, tool_id)

        if (this.step == 2){
		    local forbid = [tool_remove_wayobj, tool_build_bridge, tool_build_tunnel, tool_build_roadsign, tool_build_wayobj]

		    foreach(wt in all_waytypes)
			    if (wt != wt_power) {
			        foreach (tool_id in forbid)
				        rules.forbid_way_tool(pl, tool_id, wt )
			}
        }

        if (this.step == 3){
		    local forbid = [tool_remove_wayobj, tool_build_way, tool_build_bridge, tool_build_tunnel, tool_build_station,
                           tool_remove_way, tool_build_depot, tool_build_roadsign, tool_build_wayobj]

		    foreach(wt in all_waytypes)
			    if (wt != wt_power) {
			        foreach (tool_id in forbid)
				        rules.forbid_way_tool(pl, tool_id, wt )
			}
            rules.forbid_tool(pl, tool_build_station)
        }
	}

    function delete_objet(pl, c_list, obj, lab_name, station = false)
    {
        for(local j=0;j<c_list.len();j++){
            local tile = my_tile(c_list[j])
            local is_obj = tile.find_object(obj)
            local halt = tile.get_halt()
            if (is_obj){
                if (!halt){
                    tile.remove_object(player_x(pl), obj)
                }

                else if (station){
                    tile.remove_object(player_x(pl), obj)
                }
            }
            if (tile.is_empty())
                label_x.create(c_list[j], player_x(pl), lab_name)
        }
        return null
    }

	function truck_result_message(nr, name, good, veh, cov)
	{
		switch (nr) {
			case 0:
				return format(translate("You must select a [%s]."),name)
				break

			case 1:
				return format(translate("The number of trucks must be [%d]."),cov)
				break

			case 2:
				return format(translate("The number of convoys must be [%d], press the [Sell] button."),cov)
				break

			case 3:
				return format(translate("The truck must be for [%s]."),good)
				break

			case 4:
				return format(translate("The trailers numbers must be [%d]."),veh-1)
				break

			default :
				return translate("The convoy is not correct.")
				break
		}
	}

	function is_station_truck_build(pos, tool_id, c_list, good)
	{
		local result = null
		local is_correct = false
		local st = {is_correct = true, c = null, nr = 0}
		for(local j=0;j<c_list.len();j++){
			local tile = my_tile(c_list[j])
			local halt = tile.get_halt()
			local buil = tile.find_object(mo_building)
			if(buil){
				local st_desc = buil.get_desc()
				local st_list = building_desc_x.get_available_stations(34/*building_desc_x.station*/, st_desc.get_waytype(), good_desc_x(good))
				local sw = false
				
				//gui.add_message(""+st_desc.get_type()+"  , "+st_desc.get_waytype()+"")
				foreach(st in st_list){
					if (st.get_name() == st_desc.get_name())
						sw=true
				}
				//gui.add_message(""+sw+"  , "+st_desc.get_waytype()+"")
				if(sw) st.is_correct = true//halt.accepts_good(good_desc_x(good))
				else {
					st.is_correct = false
					st.c = c_list[j]
					st.nr = j+1
				}
			}
			if (pos.x == c_list[j].x && pos.y == c_list[j].y){
				if(tool_id==tool_build_station){
					if(st.is_correct && result == null) result = null
					else result = format(translate("Station No.%d must accept goods"),st.nr)+" ("+st.c.tostring()+")."
				}	
			}
			if (tool_id==tool_remover && !st.is_correct){
				if(halt){
					local tile_list = halt.get_tile_list()
					foreach(tile in tile_list){
						if(pos.x == tile.x && pos.y == tile.y)
							return null
					}
				}
			}
			if(!st.is_correct) result = format(translate("Station No.%d must accept goods"),st.nr)+" ("+st.c.tostring()+")."
		}
		return result
	}
	function ship_result_message(nr, name, good, veh, cov)
	{
		switch (nr) {
			case 0:
				return format(translate("You must select a [%s]."),name)
				break

			case 1:
				return format(translate("The number of ships must be [%d]."),cov)
				break

			case 2:
				return format(translate("The number of convoys must be [%d], press the [Sell] button."),cov)
				break

			case 3:
				return format(translate("The ship must be for [%s]."),good)
				break

			case 4:
				return translate("The convoy is not correct.")
				break

			default :
				return translate("The convoy is not correct.")
				break
		}
	}
}        // END of class

// END OF FILE
