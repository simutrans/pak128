//
/*
 *  class chapter_03
 *
 *
 *  Can NOT be used in network game !
 */

class tutorial.chapter_03 extends basic_chapter
{
	chapter_name  = "Riding the Rails"
	chapter_coord = coord(36,4)
	startcash     = 50000000	   				// pl=0 startcash; 0=no reset

	gl_wt = wt_rail

	//Step 5 =====================================================================================
	ch3_cov_lim1 = {a = 0, b = 0}

	//Step 7 =====================================================================================
	ch3_cov_lim2 = {a = 0, b = 0}

	//Step 11 =====================================================================================
	ch3_cov_lim3 = {a = 0, b = 0}

	cy1 = {c = coord(90,30), name = ""}
	cy2 = {c = coord(93,5), name = ""}
	cy3 = {c = coord(37,31), name = ""}
	cy4 = {c = coord(20,112), name = ""}

	//Step 1 =====================================================================================
	//Productor
	fac_1 = {c = coord(64,40), c_list = null /*auto started*/, name = "" /*auto started*/, good = good_alias.grain}

	//Fabrica
	fac_2 = {c = coord(36,4), c_list = null /*auto started*/, name = "" /*auto started*/, good = good_alias.flour}

	//Step 2 =====================================================================================
	//Primer tramo de rieles
	//--------------------------------------------------------------------------------------------
	st1_way_lim = {a = coord(67,34), b = coord(67,40)}					//Limites de la via para la estacion
	bord1_lim = {a = coord(50,27), b = coord(71,34)}					//Marca area con "X"
	label1_lim = coord(67,34)											//Indica el final de un tramo
	c_way1 = {a = coord3d(67,40,-1), b = coord3d(53,27,-1), dir = 2}	//Inicio, Fin de la via y direcion (fullway)

	//Estaciones del Productor
	st1_list = [coord(67,40), coord(67,39), coord(67,38), coord(67,37)]
	//--------------------------------------------------------------------------------------------
	
	//Modificar el terreno
	slope1 = {c = coord(53,26), dir = 72, c_z = -1}
	slope2 = {c = coord(53,25), dir = 0, c_z = 1}

	//Para el tunel
	//-------------------------------------------------------------------------------------------
	c_way2 = {a = coord3d(53,26,-1), b = coord3d(53,15,-1), dir = 0}	//Inicio, Fin de la via y direcion (fullway)
	tun1_lim = {a = coord(53,15), b = coord(53,27)}						//Limites para construir el tunel
	//-------------------------------------------------------------------------------------------

	//Segundo tramo de rieles
	//--------------------------------------------------------------------------------------------
	st2_way_lim = {a = coord(35,6), b = coord(35,9)}				//Limites de la via para la estacion
	bord2_lim = {a = coord(31,10), b = coord(55,16)}				//Marca area con "X"
	label2_lim = coord(35,10)										//Indica el final de un tramo
	c_way3 = {a = coord3d(53,15,-1), b = coord3d(35,6,1), dir = 2}	//Inicio, Fin de la via y direcion (fullway)

	//Estaciones de la Fabrica
	st2_list = [coord(35,6), coord(35,7), coord(35,8), coord(35,9)]
	//--------------------------------------------------------------------------------------------

	//Step 4 =====================================================================================
	//Limites del deposito y rieles
	//--------------------------------------------------------------------------------------------
	c_dep1 = coord(66,36)
	c_dep1_lim = {a = coord(66,36), b = coord(67,36)}
	//--------------------------------------------------------------------------------------------

	//Step 5 =====================================================================================
	loc1_name_obj = "Haru_F7A"
	loc1_tile = 4
	loc1_load = 100
	loc1_wait = 0
	f1_reached = 60

	//Step 6 =====================================================================================
	c_lock = [coord(60,10), coord(77,25)]  //Futuros transformadores

	//Primer tramo de rieles
	//--------------------------------------------------------------------------------------------
	st3_way_lim = {a = coord(38,2), b = coord(44,2)}				//Limites de la via para la estacion
	bord3_lim = {a = coord(44,0), b = coord(81,19)}					//Marca area con "X"
	label3_lim = coord(44,2)										//Indica el final de un tramo
	c_way4 = {a = coord3d(44,2,1), b = coord3d(68,18,2), dir = 5}	//Inicio, Fin de la via y direcion (fullway)

	//Estaciones de la Fabrica
	st3_list = [coord(38,2), coord(39,2), coord(40,2), coord(41,2)]
	//--------------------------------------------------------------------------------------------	

	//Para el puente
	//------------------------------------------------------------------------------------------
	c_bway_lim2 = {a = coord(68,18), b = coord(68,23)}
	c_brge2 = {a = coord(68,19), b = coord(68,22)}
	brge2_z = 0
	//-------------------------------------------------------------------------------------------

	//Segundo tramo de rieles
	//--------------------------------------------------------------------------------------------
	st4_way_lim = {a = coord(75,26), b = coord(75,30)}				//Limites de la via para la estacion
	bord4_lim = {a = coord(66,22), b = coord(80,26)}				//Marca area con "X"
	label4_lim = coord(75,26)										//Indica el final de un tramo
	c_way5 = {a = coord3d(68,23,2), b = coord3d(75,30,0), dir = 3}	//Inicio, Fin de la via y direcion (fullway)

	//Estaciones del Consumidor
	st4_list = [coord(75,30), coord(75,29), coord(75,28), coord(75,27)]
	//--------------------------------------------------------------------------------------------

	//Step 7 =====================================================================================
	//Limites del deposito y rieles
	//--------------------------------------------------------------------------------------------
	c_dep2 = coord(44,3)
	c_dep2_lim = {a = coord(44,2), b = coord(44,3)}
	//--------------------------------------------------------------------------------------------

	loc2_name_obj = "Haru_F7A"
	loc2_tile = 4
	loc2_load = 100
	loc2_wait = 0

	//Consumidor Final
	fac_3 = {c = coord(76,26), c_list = null /*auto started*/, name = "" /*auto started*/, good = good_alias.deliv}
	f3_reached = 30

	//Step 8 =====================================================================================
	//Para la entrada del tunel
	//------------------------------------------------------------------------------------------
	c_tunn1_lim = {a = coord(92,19), b = coord(92,16)}
	start_tunn = coord3d(92,18,0)
	end_tunn = coord3d(92,3,-3)
	//c_tun_lock = coord(92,16)
	//------------------------------------------------------------------------------------------

	//Subterraneo
	//------------------------------------------------------------------------------------------
	c_tunn2_lim = {a = coord(90,19), b = coord(93,3)}
	c_tunn1 = {a = coord3d(92,18,0), b = coord3d(92,3,-3), dir = 2}	//Inicio, Fin de la via y direcion (fullway)

	dir_1 = {s = 4, r = 4 }		//Direccion de la slope y Way ribi
	layer_lvl = 0 
	start_lvl_z = 0
	end_lvl_z = -3
	c_tun_list = [coord3d(92,17,0), coord3d(92,16,-1), coord3d(92,15,-2), coord3d(92,14,-3)]
	//------------------------------------------------------------------------------------------

	//Step 9 =====================================================================================
	c_way_list1 = 	[	{a = coord3d(90,20,0), b = coord3d(32,20,0), tunn = false},
						{a = coord3d(32,21,0), b = coord3d(90,21,0), tunn = false}, 
						{a = coord3d(30,35,0), b = coord3d(30,103,0), tunn = false}, 
						{a = coord3d(31,103,0), b = coord3d(31,34,0), tunn = false}
					]

	c_way_lim1 =	[	{a = coord(32,20), b = coord(90,20)}, {a = coord(32,21), b = coord(90,21)},
						{a = coord(30,34), b = coord(30,103)}, {a = coord(31,34), b = coord(31,103)}
					]
	
	//Para las señales de paso
	sign_list =	[
					{c =coord3d(74,20,0), ribi=8}, {c =coord3d(74,21,0), ribi=2}, {c =coord3d(58,20,0), ribi=8},
					{c =coord3d(58,21,0), ribi=2}, {c =coord3d(37,20,0), ribi=8}, {c =coord3d(37,21,0), ribi=2}, 
					{c =coord3d(30,49,0), ribi=4}, {c =coord3d(31,49,0), ribi=1}, {c =coord3d(30,67,0), ribi=4}, 
					{c =coord3d(31,67,0), ribi=1}, {c =coord3d(30,97,0), ribi=4}, {c =coord3d(31,97,0), ribi=1}
				]
	//Step 10 =====================================================================================
	dir_list = [0,3,6,5,5,2,2,6]

	c_cate_list1 =	[	{a = coord3d(90,20,0), b = coord3d(30,20,0), dir = 0, tunn = false},
						{a = coord3d(30,21,0), b = coord3d(30,105,0), dir = 3, tunn = false},
						{a = coord3d(29,105,0), b = coord3d(26,105,0), dir = 6, tunn = false},
						{a = coord3d(26,106,0), b = coord3d(30,106,0), dir = 5, tunn = false},
						{a = coord3d(31,106,0), b = coord3d(31,21,0), dir = 5, tunn = false}, 
						{a = coord3d(31,21,0), b = coord3d(91,21,0), dir = 2, tunn = false},
						{a = coord3d(92,26,0), b = coord3d(91,2,0), dir = 2, tunn = true},
						{a = coord3d(91,3,0), b = coord3d(91,26,0), dir = 6, tunn = true}
					]
	c_cate_lim1 =	[
						{b = coord3d(91,20,0), a = coord3d(30,20,0)},
						{a = coord3d(30,20,0), b = coord3d(30,105,0)},
						{b = coord3d(30,105,0), a = coord3d(26,105,0)},
						{a = coord3d(26,106,0), b = coord3d(30,106,0)},
						{b = coord3d(31,106,0), a = coord3d(31,21,0)},
						{a = coord3d(31,21,0), b = coord3d(91,21,0)},
						{b = coord3d(92,26,0), a = coord3d(82,1,0)},
						{a = coord3d(91,2,0), b = coord3d(91,26,0)}
					]

	//Limites del deposito y rieles
	//--------------------------------------------------------------------------------------------
	c_dep3 = coord(93,21)
	c_dep3_lim = {a = coord(92,21), b = coord(93,21)}
	//--------------------------------------------------------------------------------------------

	//Step 11 =====================================================================================
    tem_pass = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	loc3_name_obj = "SMC_XT-300_Toasted_Duck"
	loc4_name_obj = "SMC_XT-301_(car)"
	loc5_name_obj = "SMC_XT-309_(back_engine)"
	loc3_tile = 4
	loc3_load = 100
	loc3_wait = 25369

    line_name1 = "Test 4"
	st_lim_a =	[	{a = coord(88,2), b = coord(91,2)}, {a = coord(91,23), b = coord(91,26)}, {a = coord(30,29), b = coord(30,32)},
					{a = coord(26,105), b= coord(29,105)}, {a = coord(31,29), b = coord(31,32)}, {a = coord(92,23), b = coord(92,26)}
				]
	sch_list = [coord(89,2), coord(91,24), coord(30,30), coord(26,105), coord(31,30), coord(92,24)]
	dep_cnr3 = null //auto started
	tmp_d3_cnr = 0

	//Script
	//----------------------------------------------------------------------------------
	sc_way_name = "Rail_140_Tracks"
	sc_tunn_name = "Rail_140_Tunnel"
	sc_bridge_name = "Rail_100_Bridge"
	sc_station_name = "Container1TrainStop"
	sc_dep_name = "TrainDepot"
	sc_veh1_name = "SMC_Early_Grain_Hopper"
	sc_wag1_nr = 7
	sc_veh2_name = "Goods_waggon_2"
	sc_wag2_nr = 6
	sc_wag3_name = "Passagierwagen"
	sc_wag3_nr = 6
	sc_sign_name = "Signals"
	sc_caten_name = "classic_metal_mesh_catenary"
	//------------------------------------------------------------------------------------

	function start_chapter(){  //Inicia solo una vez por capitulo
		rules.clear()
		set_all_rules(0)

		local lim_idx = cv_list[(persistent.chapter - 2)].idx
		ch3_cov_lim1 = {a = cv_lim[lim_idx].a, b = cv_lim[lim_idx].b}
		ch3_cov_lim2 = {a = cv_lim[lim_idx+1].a, b = cv_lim[lim_idx+1].b}
		ch3_cov_lim3 = {a = cv_lim[lim_idx+2].a, b = cv_lim[lim_idx+2].b}

		dep_cnr3 = get_dep_cov_nr(ch3_cov_lim3.a,ch3_cov_lim3.b)

		local t = my_tile(fac_1.c)
		local buil = t.find_object(mo_building)
		if(buil) {
			fac_1.c_list = buil.get_tile_list()
			fac_1.name = translate(buil.get_name())
			local fields = buil.get_factory().get_fields_list()
			foreach(t in fields){
				fac_1.c_list.push(t)
			}
		}

		t = my_tile(fac_2.c)
		buil = t.find_object(mo_building)
		if(buil) {
			fac_2.c_list = buil.get_tile_list()
			fac_2.name = translate(buil.get_name())
			local fields = buil.get_factory().get_fields_list()
			foreach(t in fields){
				fac_2.c_list.push(t)
			}
		}

		t = my_tile(fac_3.c)
		buil = t.find_object(mo_building)
		if(buil) {
			fac_3.c_list = buil.get_tile_list()
			fac_3.name = translate(buil.get_name())
			local fields = buil.get_factory().get_fields_list()
			foreach(t in fields){
				fac_3.c_list.push(t)
			}
		}

		cy1.name = get_city_name(cy1.c)
		cy2.name = get_city_name(cy2.c)
		cy3.name = get_city_name(cy3.c)
		cy4.name = get_city_name(cy4.c)

		local pl = 0
		if(this.step == 11){
            local c_dep = this.my_tile(c_dep3)
			local c_list = sch_list
			start_sch_tmpsw(pl,c_dep, c_list)
		}
	}

	function set_goal_text(text){

		switch (this.step) {
			case 1:
				if (pot0==0){
					text = ttextfile("chapter_03/01_1-2.txt")
					text.tx = ttext("<em>[1/2]</em>")
				}
				else {
					text = ttextfile("chapter_03/01_2-2.txt")
					text.tx = ttext("<em>[2/2]</em>")
				}
				break
			case 2:
				local c1 = coord(c_way1.a.x, c_way1.a.y)
				local c2 = coord(c_way1.b.x, c_way1.b.y)
				local c3 = coord(c_way3.a.x, c_way3.a.y)
				local c4 = coord(c_way3.b.x, c_way3.b.y)

				if (pot0==0){
					text = ttextfile("chapter_03/02_1-5.txt")
					text.tx = ttext("<em>[1/5]</em>")
				}
				else if (pot1==0){
					text = ttextfile("chapter_03/02_2-5.txt")
					text.tx = ttext("<em>[2/5]</em>")
					local norte_tx = translate("nordost")
					local nortw_tx = translate("nordwest")
					local Soute_tx = translate("suedost")
					local Soutw_tx = translate("suedwest")
					local slope_tx = ""
					if (slope_estatus[0]==0){
						slope_tx += ttext("-- " + translate("Slope Height.") + " <em>" + translate("OK") + "</em><br>")
					}
					else
						slope_tx += ttext("-- <a><st>" + translate("Slope Height.") + " [¡No!]</st></a><br>")

					if (slope_estatus[1]==0){
						slope_tx += ttext("-- " + translate("It must be a slope.") + " <em>" + translate("OK") + "</em><br>")
					}
					else
						slope_tx += ttext("-- <a><st>" + translate("It is not a slope.") + " [¡No!]</st></a><br>")

					if (slope_estatus[2]==1){
						slope_tx += ttext("-- " + format(translate("The slope points to the [%s]."),norte_tx) + " <em>" + translate("OK") + "</em><br>")
					}

					if (slope_estatus[3]==1 || slope_estatus[4]==1 || slope_estatus[5]==1){
						slope_tx += ttext("-- <a><st>" + format(translate("The slope points to the [%s]."),norte_tx) + " [¡No!]</st></a><br>")
					}
					text.slpe1 = slope1.c.href("("+slope1.c.tostring()+")")
					text.slpe2 = slope2.c.href("("+slope2.c.tostring()+")")
					text.slope_t = slope_tx
				}
				else if (pot2==0){
					text = ttextfile("chapter_03/02_3-5.txt")
					text.tx = ttext("<em>[3/5]</em>")
					local slope_tx = ""
					if (slope_estatus[1]==1){
						slope_tx += ttext("-- " + translate("The terrain must be flat.") + " <em>" + translate("OK") + "</em><br>")
					}
					if (slope_estatus[2]==1 || slope_estatus[3]==1 || slope_estatus[4]==1 || slope_estatus[5]==1)
						slope_tx += ttext("-- <a><st>" + translate("It is not flat terrain.") + " [¡No!]</st></a><br>")		
					text.slpe1 = slope1.c.href("("+slope1.c.tostring()+")")
					text.slpe2 = slope2.c.href("("+slope2.c.tostring()+")")
					text.slope_t = slope_tx
				}
				else if (pot3==0){
					text = ttextfile("chapter_03/02_4-5.txt")
					text.tx = ttext("<em>[4/5]</em>")
				}
				else if (pot4==0){
					text = ttextfile("chapter_03/02_5-5.txt")
					text.tx = ttext("<em>[5/5]</em>")
				}
				text.tn = coord(c_way2.a.x, c_way2.a.y).href("("+coord(c_way2.a.x, c_way2.a.y).tostring()+")")	
				text.w1 = c1.href("("+c1.tostring()+")")
				text.w2 = c2.href("("+c2.tostring()+")")
				text.w3 = c3.href("("+c3.tostring()+")")
				text.w4 = c4.href("("+c4.tostring()+")")

				if (r_way.r)
					text.cbor = "<em>" + translate("Ok") + "</em>"
				else
					text.cbor = coord(r_way.c.x, r_way.c.y).href("("+r_way.c.tostring()+")")

				break
			case 3:
				if (pot0==0){
					text = ttextfile("chapter_03/03_1-2.txt")
					text.tx = ttext("<em>[1/2]</em>")
				}
				else if (pot0==1&&pot1==0){
					text = ttextfile("chapter_03/03_2-2.txt")
					text.tx = ttext("<em>[2/2]</em>")
				}
				text.tile = loc1_tile
				break
			case 4:
				if (pot0==0){
					text = ttextfile("chapter_03/04_1-3.txt")
					text.tx=ttext("<em>[1/3]</em>")
				}
				else if (pot0==1&&pot1==0){
					text = ttextfile("chapter_03/04_2-3.txt")
					text.tx=ttext("<em>[2/3]</em>")
				}
				else if (pot1==1){
					text = ttextfile("chapter_03/04_3-3.txt")
					text.tx=ttext("<em>[3/3]</em>")
				}
				text.w1 = c_dep1_lim.a.href("("+c_dep1_lim.a.tostring()+")")
				text.w2 = c_dep1_lim.b.href("("+c_dep1_lim.b.tostring()+")")
				text.dep = c_dep1.href("("+c_dep1.tostring()+")")
				break
			case 5:
				text.reached = reached
				text.t_reach = f1_reached
				text.loc1 = translate(loc1_name_obj)
				text.wag = sc_wag1_nr
				text.tile = loc1_tile
				text.load = loc1_load
				text.wait = get_wait_time_text(loc1_wait)
				break
			case 6:
				local c1 = coord(c_way4.a.x, c_way4.a.y)
				local c2 = coord(c_way4.b.x, c_way4.b.y)
				local c3 = coord(c_way5.a.x, c_way5.a.y)
				local c4 = coord(c_way5.b.x, c_way5.b.y)
				if (pot0==0){
					text = ttextfile("chapter_03/06_1-5.txt")
					text.tx=ttext("<em>[1/5]</em>")
				}
				else if (pot1==0){
					text = ttextfile("chapter_03/06_2-5.txt")
					text.tx=ttext("<em>[2/5]</em>")
				}
				else if (pot2==0){
					text = ttextfile("chapter_03/06_3-5.txt")
					text.tx=ttext("<em>[3/5]</em>")
				}
				else if (pot3==0){
					text = ttextfile("chapter_03/06_4-5.txt")
					text.tx=ttext("<em>[4/5]</em>")
				}
				else if (pot4==0){
					text = ttextfile("chapter_03/06_5-5.txt")
					text.tx = ttext("<em>[5/5]</em>")
				}
				text.br = c_brge2.b.href("("+c_brge2.b.tostring()+")")
				text.w1 = c1.href("("+c1.tostring()+")")
				text.w2 = c2.href("("+c2.tostring()+")")
				text.w3 = c3.href("("+c3.tostring()+")")
				text.w4 = c4.href("("+c4.tostring()+")")
				text.tile = loc2_tile
				break
			case 7:
				text.reached = reached
				text.t_reach = f3_reached
				text.loc2 = translate(loc2_name_obj)
				text.wag = sc_wag2_nr
				text.tile = loc2_tile
				text.load = loc2_load
				text.wait = get_wait_time_text(loc2_wait)
				text.w1 = c_dep2_lim.a.href("("+c_dep2_lim.a.tostring()+")")
				text.w2 = c_dep2_lim.b.href("("+c_dep2_lim.b.tostring()+")")
				break
			case 8:	

				if (pot0==0){
					text = ttextfile("chapter_03/08_1-3.txt")
					text.tx = ttext("<em>[1/3]</em>")
					text.t1 = "<a href=\"("+ start_tunn.x+","+ start_tunn.y+")\">("+ start_tunn.tostring()+")</a>"
				}
				else if(pot1==0){
					if(r_way.c.z>end_lvl_z){
						text = ttextfile("chapter_03/08_2-3.txt")
						text.tx = ttext("<em>[2/3]</em>")
						local tx_list = ""
						layer_lvl = r_way.c.z
						local slope = tile_x(r_way.c.x, r_way.c.y, r_way.c.z).get_slope()
						local c_bord = coord(r_way.c.x, r_way.c.y)
						for(local j=0;(start_lvl_z-j)>end_lvl_z;j++){
							local c = slope==0?c_bord:coord(c_tun_list[j].x, c_tun_list[j].y)
							local c_z = start_lvl_z
							if (glsw[j]==0){
								local link = "<a href=\"("+c.x+","+c.y+","+(c_z-j)+")\">("+c.tostring()+","+(c_z-j)+")</a>"
								local layer = translate("Layer level")+" = <st>"+(layer_lvl)+"</st>"
								tx_list += ttext("--> <st>" + format("[%d]</st> %s %s<br>", j+1, link, layer))
								text.lev = layer_lvl
								text.tunn = link
								break
							}
							else {
								local tx_ok = translate("OK")
								local tx_coord = c_tun_list[start_lvl_z+j].tostring()
								local layer = translate("Layer level")+" = "+(c_z-j)+""
								tx_list += ttext("<em>"+format("<em>[%d]</em> %s", j+1, tx_coord+" "+layer+" <em>"+tx_ok+"</em><br>"))
							}
						}
						text.mx_lvl = end_lvl_z
						text.list = tx_list
					}
					else{
						text = ttextfile("chapter_03/08_3-3.txt")
						text.tx = ttext("<em>[3/3]</em>")
						text.lev = layer_lvl+(end_lvl_z-start_lvl_z)
						text.t1 = start_tunn.href("("+start_tunn.tostring()+")")
						text.t2 = end_tunn.href("("+end_tunn.tostring()+")")
					}
				}
				break

			case 9:

				if (pot0==0){
					local way_list = ""
					text = ttextfile("chapter_03/09_1-2.txt")
					text.tx = ttext("<em>[1/2]</em>")
					local w_nr = 0
					for(local j=0;j<c_way_list1.len();j++){
						local c_a = c_way_list1[j].a
						local c_b = c_way_list1[j].b
						if (glsw[j]==0){
							local link1 = c_a.href("("+c_a.tostring()+")")
							local link2 = " --> "+c_b.href("("+c_b.tostring()+")")
							way_list += ttext("<st>" + format("--> [%d]</st> %s", j+1, link1 + link2))
							w_nr = j
							break
						}
						else {
							local tx_ok = translate("OK")
							local tx_coord = "("+c_a.tostring()+") --> ("+c_b.tostring()+")"
							way_list += ttext("<em>" + format("<em>[%d]</em> %s", j+1, tx_coord+" <em>"+tx_ok+"</em><br>"))
						}
					}
					text.list = way_list
					text.w2 = c_way_list1[w_nr].a.href("("+c_way_list1[w_nr].a.tostring()+")")
				 	text.w1 = c_way_list1[w_nr].b.href("("+c_way_list1[w_nr].b.tostring()+")")
				}

				else if (pot1==0){
					text = ttextfile("chapter_03/09_2-2.txt")
					text.tx = ttext("<em>[2/2]</em>")
					local sigtxt = ""
					local list = sign_list
					for(local j=0;j<list.len();j++){
						local c = list[j].c
						if (glsw[j]==0){
							local link = "<a href=\"("+c.x+","+c.y+")\">("+c.tostring()+")</a><br>"
							sigtxt += ttext("<st>" + format(translate("Signal Nr.%d") + "</st> %s", j+1, link))
						}

						else{
							local tx_ok = translate("OK")
							local tx_coord = "("+c.tostring()+")"
							sigtxt += ttext("<em>" + format(translate("Signal Nr.%d") + "</em> %s", j+1, tx_coord+"<em> "+tx_ok+"</em><br>"))
						}
					}
					text.sig = sigtxt
					break
				}
				break
			
			case 10:
                if (pot0==0){
						if (glsw[1]==0){
						text = ttextfile("chapter_03/10_1-4.txt")
						text.tx = ttext("<em>[1/4]</em>")
					}
						else {
						text = ttextfile("chapter_03/10_2-4.txt")
						text.tx = ttext("<em>[2/4]</em>")
					}
				}
				else if (pot1==0){
					text = ttextfile("chapter_03/10_3-4.txt")
					text.tx = ttext("<em>[3/4]</em>")
				}	
				else if (pot2==0){
					text = ttextfile("chapter_03/10_4-4.txt")
					text.tx = ttext("<em>[4/4]</em>")
				}			

				text.dep = c_dep3.href("("+c_dep3.tostring()+")")

				break

			case 11:

				local covtext = ""
				local name1 = translate(loc3_name_obj)
				local name2 = translate(loc4_name_obj)
				local name3 = translate(loc5_name_obj)
				local good = good_alias.passa

				if (tem_pass[0]==0)
					covtext += ttext(format("<em>[%d]</em> <st>"+translate("Number of convoys in the depot:")+"</st> <em>%d</em><br>", 1, tmp_d3_cnr))

				else
					covtext += ttext(format("<em>[%d]</em> "+translate("Number of convoys in the depot:")+" %d",1 ,tmp_d3_cnr) + " <em>" + translate("OK") + "</em><br>")

				if (tem_pass[1]==0)
					covtext += ttext(format("<em>[%d]</em> <st>"+translate("Must choose a locomotive:")+"</st> <em>%s</em><br>", 2, name1))
				else
					covtext += ttext(format("<em>[%d]</em> "+translate("Must choose a locomotive:")+" %s", 2, name1 + " <em>" + translate("OK") + "</em><br>"))

				if (tem_pass[2]==0)
					covtext += ttext(format("<em>[%d]</em> <st>"+translate("All wagons must be for:")+"</st> <em>%s</em><br>", 3, good))
				else
					covtext += ttext(format("<em>[%d]</em> "+translate("All wagons must be for:")+" %s", 3, good) + " <em>" + translate("OK") + "</em><br>")

				if (tem_pass[3]==0)
					covtext += ttext(format("<em>[%d]</em> <st>"+translate("The number of wagons must be:")+"</st> <em>%d</em> <em>(%s)</em><br>", 4, 6, name2))
				else
					covtext += ttext(format("<em>[%d]</em> "+translate("The number of wagons must be:")+" %d (%s)", 4, 6, name2) + " <em>" + translate("OK") + "</em><br>")

				if (tem_pass[4]==0)
					covtext += ttext(format("<em>[%d]</em> <st>"+translate("The cabin:")+"</st> <em>%d</em> <em>(%s)</em><br>", 5, 1, name3))
				else
					covtext += ttext(format("<em>[%d]</em> "+translate("The cabin:")+" %d (%s)", 5, 1, name3) + " <em>" + translate("OK") + "</em><br>")

				if (pot0==0){
					text = ttextfile("chapter_03/11_1-2.txt")
					text.tx = ttext("<em>[1/2]</em>")
				}
				if (pot0==1 || !correct_cov) {
				    text = ttextfile("chapter_03/11_2-2.txt")
                    text.tx=ttext("<em>[2/2]</em>")
				}
				text.cov = covtext
						
				local tx_list = ""
				local nr = sch_list.len()
				local list = sch_list
				for (local j=0;j<nr;j++){
					local c = coord(list[j].x, list[j].y)
					local tile = my_tile(c)
					local st_halt = tile.get_halt()

					if(tmpsw[j]==0 ){
						tx_list += format("<st>%s %d:</st> %s<br>", translate("Stop"), j+1, c.href(st_halt.get_name()+" ("+c.tostring()+")"))
					}
					else{						
						tx_list += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
					}
				}
				local c = coord(list[0].x, list[0].y)
				text.stnam = "1) "+my_tile(c).get_halt().get_name()+" ("+c.tostring()+")"
				text.list = tx_list
				text.dep = c_dep3.href("("+c_dep3.tostring()+")")
				text.loc3 = name1
				text.loc4 = name2
				text.loc5 = name3
				text.load = loc3_load
				text.wait = get_wait_time_text(loc3_wait)
				text.cnr = dep_cnr3
				text.tile = loc3_tile
				text.wag = sc_wag3_nr

				break
		}
		text.f1 = fac_1.c.href(translate(fac_1.name)+" ("+fac_1.c.tostring()+")")
		text.f2 = fac_2.c.href(translate(fac_2.name)+" ("+fac_2.c.tostring()+")")
		text.f3 = fac_3.c.href(translate(fac_3.name)+" ("+fac_3.c.tostring()+")")
		text.cfar=fac_1.c.href(translate(fac_1.name)+" ("+fac_1.c.tostring()+")")
		text.cmi=fac_2.c.href(translate(fac_2.name)+" ("+fac_2.c.tostring()+")")
		text.cba=fac_3.c.href(translate(fac_3.name)+" ("+fac_3.c.tostring()+")")
		text.cdep=c_dep1.href("("+c_dep1.tostring()+")")
		text.way1=c_dep2.href("("+c_dep2.tostring()+")")

		text.cy1=cy1.name
		text.cy2=cy2.name
		text.cy3=cy3.name
		text.cy4=cy4.name

		text.co1=cy1.c.href("("+cy1.c.tostring()+")")
		text.co2=cy2.c.href("("+cy2.c.tostring()+")")
		text.co3=cy3.c.href("("+cy3.c.tostring()+")")
		text.co4=cy4.c.href("("+cy4.c.tostring()+")")

		text.cbor = ""
		if (r_way.r)
			text.cbor = "<em>" + translate("Ok") + "</em>"
		else
			text.cbor = coord(r_way.c.x, r_way.c.y).href("("+r_way.c.tostring()+")")

		text.tool1 = tool_alias.inspe
		text.tool2 = tool_alias.rail
		text.tool3 = tool_alias.land

		text.good1 = translate(fac_1.good)
		text.good2 = translate(fac_2.good)
		text.good3 = translate(fac_3.good)
		return text

	}
	
	function is_chapter_completed(pl) {
		local percentage=0
		save_pot()
		save_glsw()

		switch (this.step) {
			case 1:
				local next_mark = false
				if(pot0==0 || pot1 == 0){
					local list = fac_2.c_list
					local m_buil = true
					try {
						next_mark = delay_mark_tile_list(list, m_buil)
					}
					catch(ev) {
						return 0
					}
					if(next_mark && pot0 == 1){
						pot1=1
					}
				}
				else if (pot2==0 || pot3==0){
					local list = fac_1.c_list
					local m_buil = true
					try {
						next_mark = delay_mark_tile_list(list, m_buil)
					}
					catch(ev) {
						return 0
					}
					if(next_mark && pot2 == 1){
						pot3=1
					}
				}
				else if (pot3==1 && pot4==0){
					this.next_step()
				}			
				return 5
				break;
			case 2:



				//Primer tramo de rieles
				if (pot0==0){
					local limi = label1_lim
					local tile1 = my_tile(st1_list[0])
					if (!tile1.find_object(mo_way)){
						label_x.create(st1_list[0], player_x(pl), translate("Build Rails form here"))
					}
					else
						tile1.remove_object(player_x(1), mo_label)

					local tile2 = my_tile(limi)
					if (!tile2.find_object(mo_way)){
						label_x.create(limi, player_x(pl), translate("Build Rails form here"))

						//elimina el cuadro label
						local opt = 0
						local del = true
						local text = "X"
						label_bord(bord1_lim.a, bord1_lim.b, opt, del, text)
					}

					if (tile2.find_object(mo_label) && r_way.c.y<=limi.y){
						if (!tile_x(wayend.x, wayend.y, wayend.z).find_object(mo_way))
							label_x.create(wayend, player_x(pl), translate("Build Rails form here"))
						//Creea un cuadro label
						local opt = 0
						local del = false
						local text = "X"
						label_bord(bord1_lim.a, bord1_lim.b, opt, del, text)
						
						tile2.remove_object(player_x(1), mo_label)		
					}					
					local opt = 0
					local coora = coord3d(c_way1.a.x, c_way1.a.y, c_way1.a.z)
					local coorb = coord3d(c_way1.b.x, c_way1.b.y, c_way1.b.z)
					local dir = c_way1.dir
					local obj = false
					local wt = wt_rail

					wayend = coorb
					r_way = get_fullway(coora, coorb, dir, obj)
					if (r_way.r){
						tile_x(coora.x, coora.y, coora.z).find_object(mo_way).unmark()
						tile_x(wayend.x, wayend.y, coorb.z).remove_object(player_x(1), mo_label)
						tile1.remove_object(player_x(1), mo_label)

						//elimina el cuadro label
						local opt = 0
						local del = true
						local text = "X"
						label_bord(bord1_lim.a, bord1_lim.b, opt, del, text)

						pot0=1
					}
				}
				//Para la pendiente recta
				else if (pot0==1 && pot1==0){
					local t = my_tile(slope1.c)
					local slope = t.get_slope()

					public_label(t, translate("Straight slope here!."))

					if (t.z != slope1.c_z){
						return 6
					}
					if (get_corret_slope(slope, slope1.dir)){
						t.remove_object(player_x(1), mo_label)
						pot1=1
					}
				}
				//Para la ladera plana
				else if(pot1==1 && pot2==0){
					local t = my_tile(slope2.c)
					local slope = t.get_slope()
					public_label(t, translate("Flat slope here!."))
					if (get_corret_slope(slope, slope2.dir) && t.z == slope2.c_z){
						t.remove_object(player_x(1), mo_label)
						pot2=1
					}
				}
				//Para el tunel
				else if (pot2==1 && pot3==0){

					local coora = coord3d(c_way2.a.x, c_way2.a.y, c_way2.a.z)
					local coorb = coord3d(c_way2.b.x, c_way2.b.y, c_way2.b.z)
					local dir = c_way2.dir
					local obj = false
					local tunnel = true
					r_way = get_fullway(coora, coorb, dir, obj, tunnel)
					if (r_way.r){
						pot3=1
					}

					local tile1 = my_tile(slope1.c)
					if ((!tile1.find_object(mo_tunnel)))
						label_x.create(slope1.c, player_x(pl), translate("Place a Tunnel here!."))
				
					else {
						tile1.remove_object(player_x(1), mo_label)		
					}
				}
				//Segundo tramo de rieles
				else if (pot3==1 && pot4==0){
					local limi = label2_lim
					local tile1 = my_tile(limi)
					if (r_way.c.y > limi.y){
						local label = tile1.find_object(mo_label)
						if(label)
							label.set_text(translate("Build Rails form here"))
						else
							label_x.create(limi, player_x(pl), translate("Build Rails form here"))
						//Creea un cuadro label
						local opt = 0
						local del = false
						local text = "X"
						label_bord(bord2_lim.a, bord2_lim.b, opt, del, text)
					}
					else {
						local label = tile1.find_object(mo_label)
						if(label)
							label.set_text("")
						//elimina el cuadro label
						local opt = 0
						local del = true
						local text = "X"
						label_bord(bord2_lim.a, bord2_lim.b, opt, del, text)
						if (!tile1.find_object(mo_label))
							label_x.create(st2_list[0], player_x(pl), translate("Build Rails form here"))
					}
						
					local opt = 0
					local coora = coord3d(c_way3.a.x, c_way3.a.y, c_way3.a.z)
					local coorb = coord3d(c_way3.b.x, c_way3.b.y, c_way3.b.z)
					local dir = c_way3.dir
					local obj = false
					wayend = coorb

					r_way = get_fullway(coora, coorb, dir, obj)
					if (r_way.r){
						//elimina el cuadro label
						local opt = 0
						local del = true
						local text = "X"
						label_bord(bord2_lim.a, bord2_lim.b, opt, del, text)

						tile_x(coorb.x, coorb.y, coorb.z).remove_object(player_x(1), mo_label)
						tile1.remove_object(player_x(1), mo_label)
						this.next_step()
					}
				}
				return 10
				break;
			case 3:


				glresult = null
				
				local passa = good_alias.passa
				local mail = good_alias.mail
				
				if (pot1==0){
					//Estaciones de la Fabrica
					local pl_nr = 1 
					local c_list = st2_list
					local st_nr = c_list.len() //Numero de estaciones
					local good = good_alias.goods
					local result = is_stations_building(pl_nr, c_list, st_nr, good)

					if(result){
						pot0=1
					}
				}
				
				if (pot0==1 && pot1==0){
					
					//Estaciones de la Fabrica
					local pl_nr = 1 
					local c_list = st1_list
					local st_nr = c_list.len() //Numero de estaciones
					local good = good_alias.goods
					local result = is_stations_building(pl_nr, c_list, st_nr, good)

					if (result){
						this.next_step()
					}
				}			
				return 15
				break
			case 4:
				local tile = my_tile(c_dep1)
				if(pot0==0){
					local c_list = [my_tile(c_dep1_lim.a), my_tile(c_dep1_lim.b)]
					local m_buil = false
					
					local next_mark = false

					try {
						 next_mark = delay_mark_tile_list(c_list, m_buil)
					}
					catch(ev) {
						return 0
					}				

					if(!tile.find_object(mo_way)){
						label_x.create(c_dep1, player_x(pl), translate("Build Rails form here"))
					}
					else{
						local stop_mark = true
						try {
							next_mark = delay_mark_tile_list(c_list, m_buil, stop_mark)
						}
						catch(ev) {
							return 0
						}
						pot0=1	
					}		
				}

				else if(pot0==1 && pot1==0){
					local label = tile.find_object(mo_label)
					if(!tile.find_object(mo_depot_rail)){
						if(label)
							label.set_text(translate("Build Train Depot here!."))
					}
					else{
						tile.remove_object(player_x(1), mo_label)
						pot1=1
					}				
				}

				else if(pot2==1){
					this.next_step()						
				}
				return 16
				break
			case 5:
				if (!cov_sw)
					return 0



				local wt = wt_rail

				if (current_cov == ch3_cov_lim1.b){
					reached = get_reached_target(fac_2.c, fac_1.good)
					if (reached>= f1_reached){
						pot1=1
					}	
					if (pot1==1 && pot0==0){
						//Marca tiles para evitar construccion de objetos
						local c_list = c_lock
						local siz = c_lock.len()
						local del = false
						local pl_nr = 1
						local text = "X"
		                lock_tile_list(c_list, siz, del, pl_nr, text)

						this.next_step()
						reset_stop_flag()
						reached = 0
					}
				}
				return 30
				break
			case 6:


				//Primer tramo de rieles
				if (pot0==0){

					local limi = label3_lim
					local tile1 = my_tile(st3_list[0])
					if (!tile1.find_object(mo_way)){
						label_x.create(st3_list[0], player_x(pl), translate("Build Rails form here"))
					}
					else
						tile1.remove_object(player_x(1), mo_label)

					local tile2 = my_tile(limi)
					if (!tile2.find_object(mo_way)){
						label_x.create(limi, player_x(pl), translate("Build Rails form here"))

						//elimina el cuadro label
						local opt = 0
						local del = true
						local text = "X"
						label_bord(bord3_lim.a, bord3_lim.b, opt, del, text)
					}
					if (tile_x(r_way.c.x, r_way.c.y, r_way.c.z).find_object(mo_way) && r_way.c.x>=limi.x){

						tile2.remove_object(player_x(1), mo_label)
						if (!tile_x(wayend.x, wayend.y, wayend.z).find_object(mo_way))
							label_x.create(wayend, player_x(pl), translate("Build Rails form here"))
						//Creea un cuadro label
						local opt = 0
						local del = false
						local text = "X"
						label_bord(bord3_lim.a, bord3_lim.b, opt, del, text)
					}

					local opt = 0
					local coora = coord3d(c_way4.a.x, c_way4.a.y, c_way4.a.z)
					local coorb = coord3d(c_way4.b.x, c_way4.b.y, c_way4.b.z)
					local obj = false
					local dir = c_way4.dir

					wayend = coorb

					r_way = get_fullway(coora, coorb, dir, obj)
					if (r_way.r){
						tile_x(coora.x, coora.y, coora.z).find_object(mo_way).unmark()
						tile_x(wayend.x, wayend.y, coorb.z).remove_object(player_x(1), mo_label)

						//elimina el cuadro label
						local opt = 0
						local del = true
						local text = "X"
						label_bord(bord3_lim.a, bord3_lim.b, opt, del, text)

						pot0 = 1
					}
				}
				//Para el puente
				else if (pot0==1 && pot1==0){
					local tile = my_tile(c_brge2.a)
					if ((!tile.find_object(mo_bridge))){
						label_x.create(c_brge2.a, player_x(pl), translate("Build a Bridge here!."))
						//r_way.c = 	coord3d(tile.x, tile.y, tile.z)
					}
					else {
						tile.remove_object(player_x(1), mo_label)

						if (my_tile(c_brge2.b).find_object(mo_bridge)){
							pot1=1
						}				
					}
				}
				//Segundo tramo de rieles
				else if (pot1==1 && pot2==0){
					local limi = label4_lim
					local tile1 = my_tile(limi)
					local tile2 = my_tile(st4_list[0])
					if (r_way.c.y < limi.y){
						local label = tile1.find_object(mo_label)
						if(label)
							label.set_text(translate("Build Rails form here"))
						else
							label_x.create(limi, player_x(pl), translate("Build Rails form here"))
						//Creea un cuadro label
						local opt = 0
						local del = false
						local text = "X"
						label_bord(bord4_lim.a, bord4_lim.b, opt, del, text)
					}
					else {
						local label = tile1.find_object(mo_label)
						if(label)
							label.set_text("")
						//elimina el cuadro label
						local opt = 0
						local del = true
						local text = "X"
						label_bord(bord4_lim.a, bord4_lim.b, opt, del, text)
					}

					if (!tile2.find_object(mo_way))
						label_x.create(st4_list[0], player_x(pl), translate("Build Rails form here"))
					
					local opt = 0
					local coora = coord3d(c_way5.a.x, c_way5.a.y, c_way5.a.z)
					local coorb = coord3d(c_way5.b.x, c_way5.b.y, c_way5.b.z)
					local obj = false
					local dir = c_way5.dir
					wayend = coorb				
					r_way = get_fullway(coora, coorb, dir, obj)
					if (r_way.r){
						tile1.remove_object(player_x(1), mo_label)
						tile2.remove_object(player_x(1), mo_label)
						//elimina el cuadro label
						local opt = 0
						local del = true
						local text = "X"
						label_bord(bord4_lim.a, bord4_lim.b, opt, del, text)

						pot2=1		
					}
				}
				
				//Text label para las estaciones			
				else if (pot2==1 && pot3==0){
					glresult = null
					local passa = good_alias.passa
					local mail = good_alias.mail

					//Estaciones de la Fabrica
					local pl_nr = 1 
					local c_list = st4_list
					local st_nr = c_list.len() //Numero de estaciones
					local good = good_alias.goods
					local result = is_stations_building(pl_nr, c_list, st_nr, good)

					if(result){
						pot3 = 1
					}
				}
				else if (pot3==1 && pot4==0){
					glresult = null
					local passa = good_alias.passa
					local mail = good_alias.mail

					//Estaciones de la Fabrica
					local pl_nr = 1 
					local c_list = st3_list
					local st_nr = c_list.len() //Numero de estaciones
					local good = good_alias.goods
					local result = is_stations_building(pl_nr, c_list, st_nr, good)

					if(result){
						pot4 = 1
					}
				}
				else if (pot4==1 && pot5==0){
					//Elimina las Marcas de tiles
					local c_list = c_lock
					local siz = c_lock.len()
					local del = true
					local pl_nr = 1
					local text = "X"
                    lock_tile_list(c_list, siz, del, pl_nr, text)

					this.next_step()
				}
				return 35
				break
			case 7:
				if (!cov_sw)
					return 0

				local opt = 2
				local wt = gl_wt
				local tile = my_tile(c_dep2)
				if(pot0==0){
					if(!tile.find_object(mo_way)){
						label_x.create(c_dep2, player_x(pl), translate("Build Rails form here"))
					}
					else{
						pot0=1	
					}			
				}

				else if(pot0==1 && pot1==0){
					local label = tile.find_object(mo_label)
					if(!tile.find_object(mo_depot_rail)){
						if(label)
							label.set_text(translate("Build Train Depot here!."))
					}
					else{
						tile.remove_object(player_x(1), mo_label)
						pot1=1	
					}
				}

				else if(current_cov == ch3_cov_lim2.b){
					reached = get_reached_target(fac_3.c, fac_2.good)
					if (reached>=f3_reached){
						pot3=1
					}
					if (pot3==1 && pot4==0){	
						this.next_step()
						reset_stop_flag()
						reached = 0
					}
				}		
				return 40
				break
			case 8:
				//Para la entrada del tunel
				if (pot0==0){
					local t_tunn = my_tile(start_tunn)

					if (!t_tunn.find_object(mo_tunnel))
						label_x.create(start_tunn, player_x(pl), translate("Place a Tunnel here!."))
					else{
						pot0=1
						t_tunn.remove_object(player_x(1), mo_label)						
					}							
				}
				//Para conectar las dos entradas del tunel
				else if (pot0==1 && pot1==0){
					local coora = coord3d(c_tunn1.a.x, c_tunn1.a.y, c_tunn1.a.z)
					local coorb = coord3d(c_tunn1.b.x, c_tunn1.b.y, c_tunn1.b.z)
					local obj = false
					local tunnel = true
					local dir = c_tunn1.dir
					r_way = get_fullway(coora, coorb, dir, obj, tunnel)
					if (r_way.r){
						pot1=1
						return 45
					}

					if(r_way.c.z>end_lvl_z){
						local tile = tile_x(r_way.c.x, r_way.c.y, c_tunn1.a.z)

						local squ = square_x(r_way.c.x, r_way.c.y)
						local z = squ.get_ground_tile().z
						if(z == r_way.c.z)
							return 43

						for(local j=0;(start_lvl_z-j)>end_lvl_z;j++){
							tile.z--
							if(glsw[j] == 0){
								local slope = tile.get_slope()
								if (slope == dir_1.s){ //Decremento para bajar en pendientes
									c_tun_list[j].x = tile.x
									c_tun_list[j].y = tile.y
									c_tun_list[j].z = tile.z
									glsw[j]=1
									local c = c_tun_list[j]
									if( (j+1)<c_tun_list.len()){
										//Se incrementa para ajustar los valores dependiendo del caso							
										c_tun_list[j+1].y = (tile.y - 1)
									}
									break
								}
							}
						}
					}
				}
			
				else if (pot1==1){
					this.next_step()
				}		
				return 45
				break

			case 9:


				if (pot0==0){
		            for(local j=0;j<c_way_list1.len();j++){
						if(glsw[j] == 0){
							local tile_a = my_tile(c_way_lim1[j].a)
							local tile_b = my_tile(c_way_lim1[j].b)
							local tunn = c_way_list1[j].tunn
							if (!tile_a.find_object(mo_label) && !tunn)
								label_x.create(c_way_lim1[j].a, player_x(1), translate("Build Rails form here"))

							if (!tile_b.find_object(mo_label) && !tunn)
								label_x.create(c_way_lim1[j].b, player_x(1), translate("Build Rails form here"))
							
							local coora = coord3d(c_way_list1[j].a.x, c_way_list1[j].a.y, c_way_list1[j].a.z)
							local coorb = coord3d(c_way_list1[j].b.x, c_way_list1[j].b.y, c_way_list1[j].b.z)
							local dir = get_dir_start(coora)
							r_way = get_fullway(coora, coorb, dir, tunn)
							if (r_way.r){
								tile_a.remove_object(player_x(1), mo_label)
								tile_b.remove_object(player_x(1), mo_label)
								glsw[j]=1
								if(j == c_way_lim1.len()-1){
									pot0 = 1
									reset_glsw()
									break
								}
							}
							break
						}
		            }
				}
				else if (pot0==1 && pot1==0){
					local sign_nr = 0
					for(local j=0;j<sign_list.len();j++){
						local c = sign_list[j].c
						local t = tile_x(c.x, c.y, c.z)
						if(sigcoord){
							t.find_object(mo_way).mark()
						}
						if ((!t.find_object(mo_signal) && !t.find_object(mo_roadsign) )){
							label_x.create(c, player_x(1), translate("Place Singnal here!."))
							t.find_object(mo_way).mark()
						}
						else{
							local ribi = way_x(c.x, c.y, c.z).get_dirs_masked()
							t.remove_object(player_x(1), mo_label)			
							if (ribi == sign_list[j].ribi){
								t.find_object(mo_way).unmark()
								sign_nr++
								glsw[j] = 1
								if (sign_nr == sign_list.len()){
									this.next_step()
								}
							}
						}
					}
				}
				return 50
				break

			case 10:
				if (!cov_sw)
					return 0



				if (pot0==0){
		            for(local j=0;j<c_cate_list1.len();j++){
						if(glsw[j] == 0){		
							local coora = coord3d(c_cate_list1[j].a.x, c_cate_list1[j].a.y, c_cate_list1[j].a.z)
							local coorb = coord3d(c_cate_list1[j].b.x, c_cate_list1[j].b.y, c_cate_list1[j].b.z)
							local elect = mo_wayobj
							local dir = c_cate_list1[j].dir
							local tunn = c_cate_list1[j].tunn
							
							r_way = get_fullway(coora, coorb, dir, elect, tunn)
							if (r_way.r){
								glsw[j]=1
								if(j == c_cate_list1.len()-1){
									pot0 = 1
									reset_glsw()
									break
								}
							}
							break				
						}
		            }
				}
				if (pot0==1 && pot1==0){
					local way = my_tile(c_dep3).find_object(mo_way)
					if (way.is_electrified()){
						way.unmark()
						pot1= 1
					}
					else
						way.mark()
				}
				if (pot1==1 && pot2==0){
					local tile = my_tile(c_dep3)
					if (!tile.find_object(mo_depot_rail))
						label_x.create(c_dep3, player_x(pl), translate("Build Train Depot here!."))
					else{
						tile.remove_object(player_x(1), mo_label)
						pot2=1
					}
				}
				if (pot2==1 && pot3==0){
					this.next_step()
				}
				return 97
				break
			
			case 11:



            	local c_dep = this.my_tile(c_dep3)
                set_convoy_schedule(pl,c_dep, gl_wt, line_name1)

				local depot = my_tile(c_dep3).find_object(mo_depot_rail)
				local good_nr = good_desc_x (good_alias.passa).get_catg_index() 	 //Passengers
				local cov = 1
				local veh = 6
				local cab = 1
				local loc_name = loc3_name_obj
				local wag_name = loc4_name_obj
				local cab_name = loc5_name_obj

                tmp_d3_cnr = cov

				local id_start = 7
				local id_end = 11
				local cir_nr = get_convoy_number_exp(sch_list[0], c_dep3, id_start, id_end)
				if (pot0==1){

				    local cov_list = depot.get_convoy_list()
				    local cov_nr = cov_list.len()
                    local all_nr = cov_nr + cir_nr //get_convoy_number(st1, wt_rail)                   
					tmp_d3_cnr = dep_cnr3 - cir_nr //get_convoy_number(st1, wt_rail)
                    cov = tmp_d3_cnr
			    }

				local result = is_convoy_correct_ext(depot,  good_nr, cov, veh, cab, loc_name, wag_name, cab_name)

				if (result.cov)
					tem_pass[0]=1
				else
					tem_pass[0]=0

				if (result.name)
					tem_pass[1]=1
				else
					tem_pass[1]=0

				if (result.good)
					tem_pass[2]=1
				else
					tem_pass[2]=0

				if (result.veh)
					tem_pass[3]=1
				else
					tem_pass[3]=0

				if (result.cab)
					tem_pass[4]=1
				else
					tem_pass[4]=0

				if (tem_pass[0]==1 && tem_pass[1]==1 && tem_pass[2]==1 && tem_pass[3]==1 && tem_pass[4]==1){
                    if (pot0 == 0)
                        pot0=1

					pot1=1
				}
				else{
					pot1=0
				}
					
				if (current_cov == ch3_cov_lim3.b){
					this.next_step()
					reset_stop_flag()
					return 90
				}
				return 90
				break

			case 12:
				this.step=1
				persistent.step=1
				persistent.status.step = 1
				reset_stop_flag()
				return 100
				break
		}
		return percentage
	}
		
	function is_work_allowed_here(pl, tool_id, pos) {
		glpos = coord3d(pos.x, pos.y, pos.z)
		local t = tile_x(pos.x, pos.y, pos.z)
		local ribi = 0
		local wt = 0
		local slope = t.get_slope()
		local way = t.find_object(mo_way)
		local bridge = t.find_object(mo_bridge)
		local label = t.find_object(mo_label)
		local building = t.find_object(mo_building)
		local sign = t.find_object(mo_signal)
		local roadsign = t.find_object(mo_roadsign)
		if (way){
			wt = way.get_waytype()
			if (tool_id!=tool_build_bridge)
				ribi = way.get_dirs()
			if (!t.has_way(wt_rail))
				ribi = 0
		}
		local result = translate("Action not allowed")		// null is equivalent to 'allowed'

		switch (this.step) {
			case 1:
				if (tool_id == 4096){
					if (pot0==0){
						local list = fac_2.c_list
						foreach(t in list){
							if(pos.x == t.x && pos.y == t.y) {
								pot0 = 1
								return null
							}
						}
					}
					else if (pot1==1){
						local list = fac_1.c_list
						foreach(t in list){
							if(pos.x == t.x && pos.y == t.y) {
								pot2 = 1
								return null
							}
						}
					}
				}
				else
					return translate("You must use the inspection tool")+" ("+pos.tostring()+")."
	
				break;
			//Conectando los rieles con la segunda fabrica
			case 2:
				//Primer tramo de rieles
				if (pot0==0){
					local lab_t = my_tile(label1_lim)
					local lab = lab_t.find_object(mo_label)
					if(pos.x > lab_t.x && lab && lab.get_owner().nr == 0){
						if(tool_id==tool_build_way)
							return ""
					}
					if (pos.x>=st1_way_lim.a.x && pos.y>=st1_way_lim.a.y && pos.x<=st1_way_lim.b.x && pos.y<=st1_way_lim.b.y){
						if(tool_id==tool_build_way || tool_id==4113 || tool_id==tool_remover)
							return null						
					}
					if (pos.x>=bord1_lim.a.x && pos.y>=bord1_lim.a.y && pos.x<=bord1_lim.b.x && pos.y<=bord1_lim.b.y){
						if (!way && label && label.get_text()=="X"){
							return translate("Indicates the limits for using construction tools")+" ( "+pos.tostring()+")."	
						}
						return all_control(result, gl_wt, way, ribi, tool_id, pos, r_way.c)
					}
					else if(tool_id==tool_build_way)
							return translate("Connect the Track here")+" ("+r_way.c.tostring()+")."
				}
				//Construye Pediente recta
				if (pot0==1 && pot1==0){ 
					if ((pos.x==slope1.c.x)&&(pos.y==slope1.c.y)){
						if (tool_id==4100){
							return null
						}
						else if ((tool_id==tool_build_tunnel)||(tool_id==tool_build_way))
							return translate("Straight slope here")+" ("+slope1.c.tostring()+")."
					}
				}
				//Construye Ladera plana
				else if ((pot1==1)&&(pot2==0)){
					if((pos.x==slope2.c.x)&&(pos.y==slope2.c.y)){
						if (tool_id==4100){
							if (pos.z < slope2.c_z){
								return null
							}
							else
								return translate("The land is already prepared.")
						}
					}
					else if ((tool_id==tool_build_tunnel)||(tool_id==tool_build_way))
						return translate("You must lift the land with a flat slope first")+" ("+slope2.c.tostring()+")."
				}
				//Construye un Tunel
				else if (pot2==1&&pot3==0){
					if (pos.x>=tun1_lim.a.x && pos.y>=tun1_lim.a.y && pos.x<=tun1_lim.b.x && pos.y<=tun1_lim.b.y){
						if (tool_id==tool_build_tunnel || tool_id==tool_remover)
							return null

						if (my_tile(slope1.c).find_object(mo_tunnel)){
							if (tool_id==tool_build_way&&pos.z==(-1))
								return null
						}
					}
					else return translate("Build a tunnel here")+" ("+slope1.c.tostring()+")."
				}
				//Segundo tramo de rieles
				if (pot3==1&&pot4==0){
					if (pos.x>=st2_way_lim.a.x && pos.y>=st2_way_lim.a.y && pos.x<=st2_way_lim.b.x && pos.y<=st2_way_lim.b.y){
						return all_control(result, gl_wt, way, ribi, tool_id, pos, r_way.c)	
					}
					if (pos.x>=bord2_lim.a.x && pos.y>=bord2_lim.a.y && pos.x<=bord2_lim.b.x && pos.y<=bord2_lim.b.y){
						if (!way && label && label.get_text()=="X"){
							return translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."	
						}
						return all_control(result, gl_wt, way, ribi, tool_id, pos, r_way.c)
					}
					else if(tool_id==tool_build_way)
						return translate("Connect the Track here")+" ("+r_way.c.tostring()+")."
				}
				break;

			case 3:
				if (pot0==0){
					//Estaciones de la Fabrica
					local good = good_alias.goods
					local c_list = st2_list
					local siz = c_list.len()
					return get_stations(pos, tool_id, result, good, c_list, siz)
				}
				
				else if (pot0==1 && pot1==0){
					//Estaciones del Productor
					local good = good_alias.goods
					local c_list = st1_list
					local siz = c_list.len()
					return get_stations(pos, tool_id, result, good, c_list, siz)
				}		
				break
			case 4:
				if(pot0==0){
					if (pos.x>=c_dep1_lim.a.x && pos.y>=c_dep1_lim.a.y && pos.x<=c_dep1_lim.b.x && pos.y<=c_dep1_lim.b.y){	
						if (tool_id==tool_build_way)
							return null
					}
					else return translate("You must build track in")+" ("+c_dep1.tostring()+")."
				}
				else if(pot0==1 && pot1==0){
					if ((pos.x==c_dep1.x)&&(pos.y==c_dep1.y)){
						if (tool_id==tool_build_depot)
							return null						
					}
					else return translate("You must build the train depot in")+" ("+c_dep1.tostring()+")."	
				}
				else if (pot1==1 && pot2==0){
					if ((pos.x==c_dep1.x)&&(pos.y==c_dep1.y)){
						if (tool_id==4096){
							pot2=1
							return null						
						}
						else return translate("You must use the inspection tool")+" ("+c_dep1.tostring()+")."
					}
				}
				break
			case 5:
				//Enrutar vehiculos (estacion nr1)
				if (building && pos.x>=st1_way_lim.a.x && pos.y>=st1_way_lim.a.y && pos.x<=st1_way_lim.b.x && pos.y<=st1_way_lim.b.y){
					if (tool_id==4108){
						if (stop_flag[0]==0){
							stop_flag[0] = 1
							return null
						}
						else
							return translate("Select the other station")+" ("+coord(st2_list[0].x, st2_list[0].y).tostring()+".)"
					}		
				}
				else if (tool_id==4108){
					if (stop_flag[0]==0)
						return format(translate("Select station No.%d"),1)+" ("+coord(st1_list[0].x, st1_list[0].y).tostring()+".)"
				} 
				//Enrutar vehiculos (estacion nr2)
				if (building && pos.x>=st2_way_lim.a.x && pos.y>=st2_way_lim.a.y && pos.x<=st2_way_lim.b.x && pos.y<=st2_way_lim.b.y){
					if (tool_id==4108){
						if (stop_flag[0]==1 && stop_flag[1]==0){
							stop_flag[1] = 1
							return null
						}
						if (stop_flag[0]==0)
							return translate("Select the other station first")+" ("+coord(st1_list[0].x, st1_list[0].y).tostring()+".)"
						else if (stop_flag[0]==1 && stop_flag[1]==1)
							return translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep1.tostring()+".)"	
					}	
				}
				else if (tool_id==4108){
					if (stop_flag[0]==0)
						return translate("Select the other station first")+" ("+coord(st1_list[0].x, st1_list[0].y).tostring()+".)"

					else if (stop_flag[0]==1 && stop_flag[1]==0)
						return format(translate("Select station No.%d"),2)+" ("+coord(st2_list[0].x, st2_list[0].y).tostring()+".)"

					else if (stop_flag[0]==1 && stop_flag[1]==1)
						return translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep1.tostring()+".)"
				}
				break

			//Conectando los rieles con el consumidor final
			case 6:				
				//Primer tramo de rieles
				if (pot0==0){
					local lab_t = my_tile(label3_lim)
					local lab = lab_t.find_object(mo_label)
					if(pos.y > lab_t.y && lab && lab.get_owner().nr == 0){
						if(tool_id==tool_build_way)
							return ""
					}
					if (pos.x>=st3_way_lim.a.x && pos.y>=st3_way_lim.a.y && pos.x<=st3_way_lim.b.x && pos.y<=st3_way_lim.b.y){			
						if(tool_id==tool_build_way || tool_id==4113 || tool_id==tool_remover)
							return null						
					}
					if (pos.x>=bord3_lim.a.x && pos.y>=bord3_lim.a.y && pos.x<=bord3_lim.b.x && pos.y<=bord3_lim.b.y){
						if (label && label.get_text()=="X"){
								return translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."	
						}
						return all_control(result, gl_wt, way, ribi, tool_id, pos, r_way.c)
					}
					else if(tool_id==tool_build_way)
						return translate("Connect the Track here")+" ("+r_way.c.tostring()+")."
				}
				//Construye un puente
				else if (pot0==1 && pot1==0){
					if (pos.x>=c_bway_lim2.a.x && pos.y>=c_bway_lim2.a.y && pos.x<=c_bway_lim2.b.x && pos.y<=c_bway_lim2.b.y){
						if(tool_id==tool_build_way)
							return null
						if(tool_id==tool_build_bridge){
							if(pos.z==brge2_z)
								return null
							else
								return translate("You must build the bridge here")+" ("+c_brge2.a.tostring()+")."
						}	
					}
				}

				//Segundo tramo de rieles
				if (pot1==1&&pot2==0){
					if (pos.x>=st4_way_lim.a.x && pos.y>=st4_way_lim.a.y && pos.x<=st4_way_lim.b.x && pos.y<=st4_way_lim.b.y){
						
							return all_control(result, gl_wt, way, ribi, tool_id, pos, r_way.c)
						
					}
					if (pos.x>=bord4_lim.a.x && pos.y>=bord4_lim.a.y && pos.x<=bord4_lim.b.x && pos.y<=bord4_lim.b.y){
						if (!way && label && label.get_text()=="X"){
							return translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."	
						}
						return all_control(result, gl_wt, way, ribi, tool_id, pos, r_way.c)
					}

					else if(tool_id==tool_build_way)
						return translate("Connect the Track here")+" ("+r_way.c.tostring()+")."					
				}
				//Estaciones de la Fabrica
				else if (pot2==1 && pot3==0){
					local good = good_alias.goods
					local c_list = st4_list
					local siz = c_list.len()
					return get_stations(pos, tool_id, result, good, c_list, siz)
				}
				//Estaciones del Productor	
				else if (pot3==1 && pot4==0){
					local good = good_alias.goods
					local c_list = st3_list
					local siz = c_list.len()
					return get_stations(pos, tool_id, result, good, c_list, siz)
				}
				break
			case 7:
				if (tool_id==4096)
					break

				//Construye rieles y deposito
				if (pos.x>=c_dep2_lim.a.x && pos.y>=c_dep2_lim.a.y && pos.x<=c_dep2_lim.b.x && pos.y<=c_dep2_lim.b.y){
					if (pot0==0){
						if(tool_id==tool_build_way)
							return null
						else
							return translate("You must build track in")+" ("+c_dep2.tostring()+")."
					}
					else if (pot0==1 && pot1==0)
						if(tool_id==tool_build_depot)
							return null
						else
							return result = translate("You must build the train depot in")+" ("+c_dep2.tostring()+")."
				}
				else if (pot0==0)
					return translate("You must build track in")+" ("+c_dep2.tostring()+")."
				else if (pot0==1 && pot1==0)
					return result = translate("You must build the train depot in")+" ("+c_dep2.tostring()+")."

				//Enrutar vehiculos (estacion nr1)
				if (pot1==1 && pot2==0){
					if (building && pos.x>=st3_way_lim.a.x && pos.y>=st3_way_lim.a.y && pos.x<=st3_way_lim.b.x && pos.y<=st3_way_lim.b.y){
						if (tool_id==4108 && building){
							if (stop_flag[0]==0){
								stop_flag[0] = 1
								return null
							}
							else
								return translate("Select the other station")+" ("+coord(st4_list[0].x, st4_list[0].y).tostring()+".)"
						}		
					}
					else if (tool_id==4108){
						if (stop_flag[0]==0)
							return format(translate("Select station No.%d"),1)+" ("+coord(st3_list[0].x, st3_list[0].y).tostring()+".)"
					} 
					//Enrutar vehiculos (estacion nr2)
					if (building && pos.x>=st4_way_lim.a.x && pos.y>=st4_way_lim.a.y && pos.x<=st4_way_lim.b.x && pos.y<=st4_way_lim.b.y){
						if (tool_id==4108 && building){
							if (stop_flag[0]==1 && stop_flag[1]==0){
								stop_flag[1] = 1
								return null
							}
							if (stop_flag[0]==0)
								return translate("Select the other station first")+" ("+coord(st3_list[0].x, st3_list[0].y).tostring()+".)"
							else if (stop_flag[0]==1 && stop_flag[1]==1)
								return translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep1.tostring()+".)"	
						}	
					}
					else if (tool_id==4108){
						if (stop_flag[0]==0)
							return translate("Select the other station first")+" ("+coord(st3_list[0].x, st3_list[0].y).tostring()+".)"

						else if (stop_flag[0]==1 && stop_flag[1]==0)
							return format(translate("Select station No.%d"),2)+" ("+coord(st4_list[0].x, st4_list[0].y).tostring()+".)"

						else if (stop_flag[0]==1 && stop_flag[1]==1)
							return translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep1.tostring()+".)"
					}
				}
				if (pot2==1 && pot3==0){
					return translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep1.tostring()+".)"
				}
				break

			case 8:
				//Construye Entrada del tunel
				if (pot0==0){
					if (tool_id==tool_build_tunnel || tool_id==tool_build_way){
						if (pos.x>=c_tunn1_lim.a.x && pos.y<=c_tunn1_lim.a.y && pos.x<=c_tunn1_lim.b.x && pos.y>=c_tunn1_lim.b.y) {
							return null
						}
						else return translate("Press [Ctrl] to build a tunnel entrance here")+" ("+start_tunn.tostring()+".)"	
					}
				}
				//Conecta los dos extremos del tunel
				else if (pot0==1 && pot1==0){
					local squ_bor = square_x(r_way.c.x, r_way.c.y)
					local z_bor = squ_bor.get_ground_tile().z
					local res = underground_message()
					if(res != null)
						return res
					local max = 1
					local count_tunn = count_tunnel(pos, max)
					if (tool_id==tool_remover){
						if (pos.x>=c_tunn2_lim.a.x && pos.y<=c_tunn2_lim.a.y && pos.x<=c_tunn2_lim.b.x && pos.y>=c_tunn2_lim.b.y){
							//El Tunel ya tiene la altura correcta
							if (r_way.c.z == c_tunn1.b.z) {
								return all_control(result, gl_wt, way, ribi, tool_id, pos, r_way.c)
							}
							if(!count_tunn && slope==0 && way && way.is_marked())
								return null
							if(count_tunn && pos.z!=end_lvl_z)
								return translate("You must use the tool to lower the ground here")+" ("+r_way.c.tostring()+".)" 
						}
					}

					if (tool_id==tool_build_tunnel || tool_id==tool_build_way || tool_id== 4099){
						if (pos.x>=c_tunn2_lim.a.x && pos.y<=c_tunn2_lim.a.y && pos.x<=c_tunn2_lim.b.x && pos.y>=c_tunn2_lim.b.y){
							local squ = square_x(pos.x, pos.y)
							//Ingnora algunas comprobaciones
							local z = squ.get_ground_tile().z
							if( z == pos.z){
								//gui.add_message("pos: "+pos)
								return null
							}
							//El Tunel ya tiene la altura correcta
							if (r_way.c.z == c_tunn1.b.z) {
								return all_control(result, gl_wt, way, ribi, tool_id, pos, r_way.c)
							}
							local under = c_tunn1.b.z
							local dir = dir_1.r
							result = under_way_check(under, dir)


							local start = c_tunn1.a
							if(result != null && r_way.c.x != start.x && r_way.c.y != start.y)
								return result

							local slp_way = tile_x(r_way.c.x, r_way.c.y, r_way.c.z).get_slope()
							if (z_bor == r_way.c.z && pos.z == c_tunn1.a.z && pos.y > r_way.c.y -3 ) { 
								// Check if not have more tunnel 
								local max = 3
								result = tunnel_build_check(start, under,  max, dir)
								if(result == null)
									return all_control(result, gl_wt, way, ribi, tool_id, pos, r_way.c)

								return result
							}
							if(pos.y > r_way.c.y -3){
								if(slp_way == dir_1.s )
									return all_control(result, gl_wt, way, ribi, tool_id, pos, r_way.c)
								else return translate("You must use the tool to lower the ground here")+" ("+r_way.c.tostring()+".)" 
								if (!squ.get_tile_at_height(pos.z))
									return all_control(result, gl_wt, way, ribi, tool_id, pos, r_way.c)
							}
							if(slp_way == 0 ){
								if(pos.z != r_way.c.z)
									return all_control(result, gl_wt, way, ribi, tool_id, pos, r_way.c)
								
								if(pos.z == r_way.c.z)
									return translate("You must lower the ground first")+" ("+r_way.c.tostring()+".)"
							}

							//gui.add_message("z "+under_lv+ " :: "+ pos.y)
							if (under_lv != unde_view && pos.y > r_way.c.y +3) return null

							if(pos.z == r_way.c.z)return ""	
						}
						else return translate("Build a tunnel here")+" ("+r_way.c.tostring()+")."	
					}
					if (tool_id==4100){
						if (pos.x>=c_tunn2_lim.a.x && pos.y<=c_tunn2_lim.a.y && pos.x<=c_tunn2_lim.b.x && pos.y>=c_tunn2_lim.b.y){
							local slp_way = tile_x(r_way.c.x, r_way.c.y, r_way.c.z).get_slope()
							local end_z = c_tunn1.b.z
							if (slp_way == dir_1.s)
								return translate("The slope is ready.")
							else if (pos.z > end_z){
								local dir = dir_1.r
								local under = end_z
								result = under_way_check(under, dir)
								return result
							}
							if (pos.z == end_z)
								return translate("The tunnel is already at the correct level")+" ("+end_z+")."
						}
						else return slope==0? translate("Modify the terrain here")+" ("+r_way.c.tostring()+")." : result
					}
				}

				break
			case 9:
				if (pot0==0){
					result = translate("Connect the Track here")+" ("+r_way.c.tostring()+")."
		            for(local j=0;j<c_way_lim1.len();j++){
						if(glsw[j] == 0){
							if(pos.x>=c_way_lim1[j].a.x && pos.y>=c_way_lim1[j].a.y && pos.x<=c_way_lim1[j].b.x && pos.y<=c_way_lim1[j].b.y){
												   
								if(tool_id == tool_build_way){
								   return null
								}
							   }
						   else if (j== c_way_lim1.len()-1){
								result = translate("You are outside the allowed limits!")+" ("+pos.tostring()+")."
						   	}
							break
						}
					}
					return result
				}
				if (pot0==1 && pot1==0){
					//Elimina las señales
					if (tool_id==tool_remover){
						if (sign || roadsign){
							for(local j=0;j<sign_list.len();j++){
								if (pos.x == sign_list[j].c.x && pos.y==sign_list[j].c.y){
									backward_glsw(j)
									return null
								}
							}
						}
						else
							return translate("Only delete signals.")							
					}
					//Construye señales de paso					
					if (tool_id == 4116){
						if (!sign){
							for(local j=0;j<sign_list.len();j++){
								local tile = tile_x(sign_list[j].c.x, sign_list[j].c.y, sign_list[j].c.z)
								local r
								if (tile.find_object(mo_signal)){
									r = get_signa(tile, j, sign_list[j].ribi)
									if (r == null)
										return translate("The signal does not point in the correct direction")+" ("+sign_list[j].c.tostring()+")."
								}
								else
									result = translate("Place a block signal here")+" ("+sign_list[j].c.tostring()+")."

								if (tile.find_object(mo_roadsign))
									return translate("It must be a block signal!")+" ("+sign_list[j].c.tostring()+")."
							}	
						}
						for(local j=0;j<sign_list.len();j++){
							local tile = tile_x(sign_list[j].c.x, sign_list[j].c.y, sign_list[j].c.z)
							if (tile.find_object(mo_roadsign))
								return translate("It must be a block signal!")+" ("+sign_list[j].c.tostring()+")."
							if ((pos.x == sign_list[j].c.x) && (pos.y == sign_list[j].c.y)){
								return get_signa(t, j, sign_list[j].ribi)
							}
						}
						return result
					}
				}
				break
			case 10:
                //return square_x(pos.x, pos.y).get_climate()

				if (pot0==0){
		            for(local j=0;j<c_cate_lim1.len();j++){
		               if(pos.x>=c_cate_lim1[j].a.x && pos.y>=c_cate_lim1[j].a.y && pos.x<=c_cate_lim1[j].b.x && pos.y<=c_cate_lim1[j].b.y){
		                                   
		                    if(tool_id == 4114){
								return null
		                    }
		               }
		               else if (j== c_cate_lim1.len()-1){
		                    result =  translate("Connect the Track here")+" ("+r_way.c.tostring()+")."
		               }
		            }
					if ((tool_id == 4114)&&(pos.x==c_dep3.x)&&(pos.y==c_dep3.y)) return null
				}
				else if (pot0==1 && pot1==0){
					if (pos.x>=c_dep3_lim.a.x && pos.y>=c_dep3_lim.a.y && pos.x<=c_dep3_lim.b.x && pos.y<=c_dep3_lim.b.y){
						if (tool_id==4114){
							return null
						}					
							
					}
		            result = translate("Connect the Track here")+" ("+c_dep3.tostring()+")."
				}
				else if (pot1==1 && pot2==0){
					if ((pos.x==c_dep3.x)&&(pos.y==c_dep3.y)){
						if (tool_id==tool_build_depot){
							return null
						}					
					}
					result = translate("You must build the train depot in")+" ("+c_dep3.tostring()+")."
				}
				break

			case 11:

				if (tool_id==4108){
					for(local j=0;j<st_lim_a.len();j++){
                        if(!tem_pass[1] || !tem_pass[3] || !tem_pass[3] || !tem_pass[4])
                            return translate("Incorrect vehicle configuration, check vehicle status.")	
						result = format(translate("Select station No.%d"),j+1)+" ("+st_lim_a[j].a.tostring()+".)"
						if(tmpsw[j]==0){
		                    if((pos.x>=st_lim_a[j].a.x)&&(pos.y>=st_lim_a[j].a.y)&&(pos.x<=st_lim_a[j].b.x)&&(pos.y<=st_lim_a[j].b.y)){
								local c_list = sch_list //Lista de todas las estaciones
								local c_dep = c_dep3 //Coordeadas del deposito 
								local siz = c_list.len()//Numero de paradas 
								result = translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep.tostring()+")."
								return is_stop_allowed_ex(result, siz, c_list, pos, gl_wt)					
							}
							else
								return result
						}
						if ((j+1) == st_lim_a.len())
							return translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+c_dep3.tostring()+")."
					}
					return result
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
		local nr =  schedule.entries.len()
		switch (this.step) {
			case 5:
				local selc = 0
				local load = loc1_load
				local time = loc1_wait
				local c_list = [st1_list[0], st2_list[0]]
				local siz = c_list.len()
				return set_schedule_list(result, pl, schedule, nr, selc, load, time, c_list, siz)
			break

			case 7:
				local selc = 0
				local load = loc2_load
				local time = loc2_wait
				local c_list = [st3_list[0], st4_list[0]]
				local siz = c_list.len()
				return set_schedule_list(result, pl, schedule, nr, selc, load, time, c_list, siz)
			break

			case 11:
				local selc = 0
				local load = loc3_load
				local time = loc3_wait
				local c_list = sch_list
				local siz = c_list.len()
				local line = true
				result = set_schedule_list(result, pl, schedule, nr, selc, load, time, c_list, siz, line)
				if(result == null){
					local line_name = line_name1
					update_convoy_schedule(pl, gl_wt, line_name, schedule)
				}
				return result
			break
		}
		return result = translate("Action not allowed")
	}

	function is_convoy_allowed(pl, convoy, depot)
	{
		local result = translate("It is not allowed to start vehicles.")
		switch (this.step) {
			case 5:
				local wt = gl_wt
				if ((depot.x != c_dep1.x)||(depot.y != c_dep1.y))
					return 0
				local cov = 1
				local veh = 6
				local good_list = [good_desc_x(fac_1.good).get_catg_index()] //
				local name = loc1_name_obj
				local st_tile = st1_list.len() // 3
				local is_st_tile = true
				result = is_convoy_correct(depot,cov,veh,good_list,name, st_tile, is_st_tile)

				if (result!=null){
					backward_pot(0)
					local good = translate(fac_1.good)
					return train_result_message(result, translate(name), good, veh, cov, st_tile)
				}

				if (current_cov>ch3_cov_lim1.a && current_cov<ch3_cov_lim1.b){
					local selc = 0
					local load = loc1_load
					local time = loc1_wait
					local c_list = [st1_list[0], st2_list[0]]
					local siz = c_list.len()
					return set_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
				}
			break

			case 7:
				local wt = gl_wt
				if ((depot.x != c_dep2.x)||(depot.y != c_dep2.y))
					return translate("You must select the deposit located in")+" ("+c_dep2.tostring()+")."	
				local cov = 1
				local veh = 6
				local good_list = [good_desc_x(fac_2.good).get_catg_index()]
				local name = loc2_name_obj
				local st_tile = st3_list.len() // 3
				local is_st_tile = true
				result = is_convoy_correct(depot,cov,veh,good_list,name, st_tile, is_st_tile)

				if (result!=null){
					local good = translate(fac_3.good)
					return train_result_message(result, translate(name), good, veh, cov, st_tile)
				}
				if (current_cov>ch3_cov_lim2.a && current_cov<ch3_cov_lim2.b){
					local selc = 0
					local load = loc2_load
					local time = loc2_wait
					local c_list = [st3_list[0], st4_list[0]]
					local siz = c_list.len()
					return set_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
				}
			break

			case 11:
				local wt = gl_wt
				if ((depot.x != c_dep3.x)||(depot.y != c_dep3.y))
					return translate("You must select the deposit located in")+" ("+c_dep3.tostring()+")."	
				local cov = dep_cnr3
				local veh = 8
				local good_list = [good_desc_x(good_alias.passa).get_catg_index()] //Passengers
				local name = loc3_name_obj
				local st_tile = loc3_tile
				local is_st_tile = true

				//Para arracar varios vehiculos
				local id_start = ch3_cov_lim3.a
				local id_end = ch3_cov_lim3.b
				local cir_nr = get_convoy_number_exp(sch_list[0], depot, id_start, id_end)
				local cov_list = depot.get_convoy_list()
				cov -= cir_nr
				result = is_convoy_correct(depot, cov, veh, good_list, name, st_tile, is_st_tile)

				if (result!=null){
					local good = translate(good_alias.passa)
					return train_result_message(result, translate(name), good, veh, cov, st_tile)
				}

			if (current_cov>ch3_cov_lim3.a && current_cov<ch3_cov_lim3.b){
					local selc = 0
					local load = loc3_load
					local time = loc3_wait
					local c_list = sch_list
					local siz = c_list.len()
					return set_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
				}
			break

		}
		return result = translate("It is not allowed to start vehicles.")
	}

	function script_text()
	{
		local player = player_x(0)
		local way = tile_x(r_way.c.x, r_way.c.y, r_way.c.z).find_object(mo_way)
		if(way) way.unmark()
		
		switch (this.step) {
			case 1:
				if(pot0==0){
					pot0=1
				}
				if (pot2==0){
					pot2=1
				}
				return null
				break;
			case 2:
				//Primer tramo de rieles
				if (pot0==0){

					//Station tramo ----------------------------------------------------------------------
					local t_start = my_tile(st1_way_lim.b)
					local t_end = my_tile(label1_lim)

					t_start.remove_object(player_x(1), mo_label)
					t_end.remove_object(player_x(1), mo_label)

					local t = command_x(tool_build_way)			
					local err = t.work(player, t_start, t_end, sc_way_name)

					//Outside tramo ----------------------------------------------------------------------
					t_start = my_tile(label1_lim)
					t_end = my_tile(coord(c_way1.b.x, c_way1.b.y))
					t = command_x(tool_build_way)			
					err = t.work(player, t_start, t_end, sc_way_name)

					//elimina el cuadro label
					local opt = 0
					local del = true
					local text = "X"
					label_bord(bord1_lim.a, bord1_lim.b, opt, del, text)
				}
				//Para las pendientes / terreno
				local t_slope1 = my_tile(slope1.c)
				local t_slope2 = my_tile(slope2.c)
				if (pot2==0){

					if (t_slope1.find_object(mo_label))
						t_slope1.remove_object(player_x(1), mo_label)

					if (t_slope2.find_object(mo_label))
						t_slope2.remove_object(player_x(1), mo_label)


					command_x.set_slope(player_x(1), t_slope1, 72)
					if(t_slope2.z <= (t_slope1.z+1))
						command_x.set_slope(player_x(1), t_slope2, slope.all_up_slope)					
				}
				//Para el tunel
				if (pot3==0){
					local t_start = my_tile(c_way2.a)
					t_start.remove_object(player_x(1), mo_label)

					local t = command_x(tool_build_tunnel)
					try {
						t.work(player, t_start, sc_tunn_name)
					}
					catch(ev) {
						return null
					}
				}
				//Segundo tramo de rieles
				if (pot4==0){
					//Outside tramo ----------------------------------------------------------------------
					local t_start = my_tile(coord(c_way3.a.x, c_way3.a.y))
					local t_end = my_tile(label2_lim)
					local t = command_x(tool_build_way)			
					local err = t.work(player, t_start, t_end, sc_way_name)

					//Station tramo ----------------------------------------------------------------------
					t_start = my_tile(label2_lim)
					t_end = my_tile(st2_way_lim.a)

					t_start.remove_object(player_x(1), mo_label)
					t_end.remove_object(player_x(1), mo_label)

					t = command_x(tool_build_way)			
					err = t.work(player, t_start, t_end, sc_way_name)

				}
				return null
				break;
			case 3:

				if (pot0==0){
					//Estaciones de la Fabrica
					for(local j=0;j<st2_list.len();j++){
						local tile = my_tile(st2_list[j])
						tile.find_object(mo_way).unmark()
						if (tile.get_halt()==null){
							if (tile.find_object(mo_label))
								tile.remove_object(player_x(1), mo_label)
							local tool = command_x(tool_build_station)			
							local err = tool.work(player, tile, sc_station_name)
						}
					}
				}
				
				if (pot1==0){
					//Estaciones del Productor
					for(local j=0;j<st1_list.len();j++){
						local tile = my_tile(st1_list[j])
						tile.find_object(mo_way).unmark()
						if (tile.get_halt()==null){
							if (tile.find_object(mo_label))
								tile.remove_object(player_x(1), mo_label)
							local tool = command_x(tool_build_station)			
							local err = tool.work(player, tile, sc_station_name)
						}
					}
				}			
				return null
				break
			case 4:

				if(pot0==0){
					local t_start = my_tile(c_dep1_lim.a)
					local t_end = my_tile(c_dep1_lim.b)
					t_start.remove_object(player_x(1), mo_label)
					local t = command_x(tool_build_way)			
					local err = t.work(player, t_start, t_end, sc_way_name)
				}

				if(pot1==0){
					local tile = my_tile(c_dep1)
					tile.remove_object(player_x(1), mo_label)
					local t = command_x(tool_build_depot)
					local err = t.work(player, tile, sc_dep_name)
				}
				if(pot2==0){
					pot2=1
				}

				return null
				break
			case 5:
				local wt = wt_rail
				if (current_cov>ch3_cov_lim1.a && current_cov<ch3_cov_lim1.b){
					local c_depot = my_tile(c_dep1)
					comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito

					local sched = schedule_x(wt, [])
					sched.entries.append(schedule_entry_x(my_tile(st1_list[0]), loc1_load, loc1_wait))
					sched.entries.append(schedule_entry_x(my_tile(st2_list[0]), 0, 0))
					local c_line = comm_get_line(player, gl_wt, sched)

					local good_nr = 0 //Passengers
					local name = loc1_name_obj
					local wag_name = sc_veh1_name
					local wag_nr = sc_wag1_nr //5
					local wag = true
					local cov_nr = 0  //Max convoys nr in depot
					if (!comm_set_convoy(cov_nr, c_depot, name)){
						return 0
					}
					for (local count = 0;count<wag_nr;count++){
						if (!comm_set_convoy(cov_nr, c_depot, wag_name, wag))
							return 0
					}

					local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
					local conv = depot.get_convoy_list()
					conv[0].set_line(player, c_line)
					comm_start_convoy(player, conv[0], depot)

					pot1=1
				}
				return null
				break
			case 6:
				//Primer tramo de rieles
				if (pot0==0){

					//Station tramo ----------------------------------------------------------------------
					local t_start = my_tile(st3_way_lim.a)
					local t_end = my_tile(label3_lim)

					t_start.remove_object(player_x(1), mo_label)
					t_end.remove_object(player_x(1), mo_label)

					local t = command_x(tool_build_way)			
					local err = t.work(player, t_start, t_end, sc_way_name)

					//Outside tramo ----------------------------------------------------------------------
					t_start = my_tile(label3_lim)
					t_end = my_tile(coord(c_way4.b.x, c_way4.b.y))
					t = command_x(tool_build_way)			
					err = t.work(player, t_start, t_end, sc_way_name)

					//elimina el cuadro label
					local opt = 0
					local del = true
					local text = "X"
					label_bord(bord3_lim.a, bord3_lim.b, opt, del, text)
				}
				//Para el puente
				if (pot1==0){
					local t_start = my_tile(c_brge2.a)
					local t_end = my_tile(c_brge2.b)

					t_start.remove_object(player_x(1), mo_label)

					local t = command_x(tool_build_bridge)
					t.set_flags(2)		
					local err = t.work(player, t_start, t_end, sc_bridge_name)
				}
				//Segundo tramo de rieles
				if (pot2==0){
					//Outside tramo ----------------------------------------------------------------------
					local t_start = my_tile(coord(c_way5.a.x, c_way5.a.y))
					local t_end = my_tile(label4_lim)
					local t = command_x(tool_build_way)			
					local err = t.work(player, t_start, t_end, sc_way_name)

					//Station tramo ----------------------------------------------------------------------
					t_start = my_tile(label4_lim)
					t_end = my_tile(st4_way_lim.b)

					t_start.remove_object(player_x(1), mo_label)
					t_end.remove_object(player_x(1), mo_label)

					t = command_x(tool_build_way)			
					err = t.work(player, t_start, t_end, sc_way_name)
				}
				if (pot2==1){
					glresult = null
					local passa = good_alias.passa
					local mail = good_alias.mail
					//Estaciones de la Fabrica
					if (pot3==0){
						for(local j=0;j<st4_list.len();j++){
							local tile = my_tile(st4_list[j])
							tile.find_object(mo_way).unmark()
							if (tile.get_halt()==null){
								if (tile.find_object(mo_label))
									tile.remove_object(player_x(1), mo_label)
								local tool = command_x(tool_build_station)			
								local err = tool.work(player, my_tile(st4_list[j]), sc_station_name)
							}
						}
					}
					//Estaciones del Productor
					if (pot4==0){
						for(local j=0;j<st3_list.len();j++){
							local tile = my_tile(st3_list[j])
							tile.find_object(mo_way).unmark()
							if (tile.get_halt()==null){
								if (tile.find_object(mo_label))
									tile.remove_object(player_x(1), mo_label)
								local tool = command_x(tool_build_station)			
								local err = tool.work(player, my_tile(st3_list[j]), sc_station_name)
							}
						}
					}
				}
				return null
				break
			case 7:
				if (!correct_cov)
					return 0

				local opt = 2
				local wt = wt_rail

				if(pot0==0){
					local t_start = my_tile(c_dep2_lim.b)
					t_start.remove_object(player_x(1), mo_label)
					local t_end = my_tile(c_dep2_lim.a)
					local t = command_x(tool_build_way)			
					local err = t.work(player, t_start, t_end, sc_way_name)
				}

				if(pot1==0){
					local t2 = command_x(tool_build_depot)
					local err2 = t2.work(player, my_tile(c_dep2), sc_dep_name)
				}
				if(pot2==0){
					local wt = wt_rail
					if (current_cov>ch3_cov_lim2.a && current_cov<ch3_cov_lim2.b){
						local c_depot = my_tile(c_dep2)
						comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito

						local sched = schedule_x(wt, [])
						sched.entries.append(schedule_entry_x(my_tile(st3_list[0]), loc2_load, loc2_wait))
						sched.entries.append(schedule_entry_x(my_tile(st4_list[0]), 0, 0))
						local c_line = comm_get_line(player, gl_wt, sched)

						local name = loc2_name_obj
						local wag_name = sc_veh2_name
						local wag_nr = 	sc_wag2_nr //5
						local wag = true
						local cov_nr = 0  //Max convoys nr in depot
						if (!comm_set_convoy(cov_nr, c_depot, name))
							return 0
						for (local count = 0;count<wag_nr;count++){
							if (!comm_set_convoy(cov_nr, c_depot, wag_name, wag))
								return 0
						}

						local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
						local conv = depot.get_convoy_list()
						conv[0].set_line(player, c_line)
						comm_start_convoy(player, conv[0], depot)

						pot3=1
					}
				}
				return null
				break

			case 8:
				if (pot0==0){
					local t_tunn = my_tile(start_tunn)
					t_tunn.remove_object(player_x(1), mo_label)						
					local t = command_x(tool_build_tunnel)
					t.set_flags(2)
					try {
						t.work(player, t_tunn, sc_tunn_name)
					}
					catch(ev) {
						return null
					}
				}
				if (pot1==0){
					local t_rem = command_x(tool_remover)
					local t_tun = command_x(tool_build_tunnel)
					local c_list =	c_tun_list
					local t_start = my_tile(start_tunn)
					for(local j = 0; j<(c_list.len()-1);j++){
						local t = tile_x(c_list[j].x, c_list[j].y, (t_start.z-j))
						local way = t.find_object(mo_way)
						local ribi = way? way.get_dirs() : 0
						if(ribi && ribi !=4 ){
							local siz = 5
							local opt = 4 //Decrementa y
							local t = tile_x(t.x, t.y, t.z)
							clean_track_segment(t, siz, opt)
						}
						t_tun.work(player, t_start, t, sc_tunn_name)
						command_x.set_slope(player, t, slope.all_down_slope)
					}
					local c_start = c_tunn1.a 
					local c_end = c_tunn1.b 

					t_tun.work(player, c_start, c_end, sc_tunn_name)

				}					
				return null
				break

			case 9:
				if (pot0==0){
					local t = command_x(tool_build_way)
					t.set_flags(2)
					local list = c_way_list1
		            for(local j=0;j<c_way_lim1.len();j++){
						if(glsw[j] == 0){
							local tile_a = tile_x(list[j].a.x, list[j].a.y, list[j].a.z)
							local tile_b = tile_x(list[j].b.x, list[j].b.y, list[j].b.z)

							tile_a.find_object(mo_way).unmark()
							tile_b.find_object(mo_way).unmark()

							tile_a.remove_object(player_x(1), mo_label)
							tile_b.remove_object(player_x(1), mo_label)

							if(list[j].tunn) {
								t = command_x(tool_build_tunnel)
								t.work(player, tile_a, tile_b, sc_way_name)
							}
							else {
								t.set_flags(2)			
								t.work(player, tile_a, tile_b, sc_way_name)
							}							
						}
		            }
				}
				if (pot1==0){
					for(local j=0;j<sign_list.len();j++){
						local tile = tile_x(sign_list[j].c.x, sign_list[j].c.y, sign_list[j].c.z)
						local way = tile.find_object(mo_way)
						local rsign = tile.find_object(mo_roadsign)
						local sign = tile.find_object(mo_signal)
						if (sign) {
							tile.remove_object(player_x(1), mo_signal)
						}
						if (rsign){
							tile.remove_object(player_x(1), mo_roadsign)
						}

						local t = command_x(tool_build_roadsign)
						while(true){
							local err = t.work(player, tile, sc_sign_name)
							local ribi = way.get_dirs_masked()
							if (ribi == sign_list[j].ribi)
								break
						}
					}
				}
				return null
				break

			case 10:
				if (!cov_sw)
					return 0
				if (r_way.c != 0){
					local tile = tile_x(r_way.c.x, r_way.c.y, r_way.c.z)
					local way = tile.find_object(mo_way)
					way.unmark()
					tile.remove_object(player_x(1), mo_label)
				}
				if (pot0==0){
		            for(local j=0;j<c_cate_list1.len();j++){
						if(glsw[j] == 0){		
							local coora = c_cate_list1[j].a
							local coorb = c_cate_list1[j].b
							local t = command_x(tool_build_wayobj)		
							local err = t.work(player, coora, coorb, sc_caten_name)
						}
		            }
				}
				if (pot1==0){
					local way = my_tile(c_dep3).find_object(mo_way)
					way.unmark()
					local t = command_x(tool_build_wayobj)		
					local err = t.work(player, my_tile(c_dep3), my_tile(c_dep3), sc_caten_name)

				}
				if (pot2==0){
					local tile = my_tile(c_dep3)
					tile.remove_object(player_x(1), mo_label) //Elimina texto label
					local t = command_x(tool_build_depot)
					local err = t.work(player, tile, sc_dep_name)
				}
				return null
				break
			
			case 11:
				local c_depot = my_tile(c_dep3)
				comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito
				local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)


				if (current_cov>ch3_cov_lim3.a && current_cov<ch3_cov_lim3.b){
					//Set schedule for all convoys-------------------------------------------------------------
					local sched = schedule_x(gl_wt, [])
					local c_list = sch_list
					local c2d = "coord"
					for(local j=0;j<sch_list.len();j++){
						local c = c_list[j]
						local type = typeof(c)
						local t = type == c2d ? my_tile(c) : tile_x(c.x, c.y, c.z)
						if (j==0)
							sched.entries.append(schedule_entry_x(t, loc3_load, loc3_wait))
						else
							sched.entries.append(schedule_entry_x(t, 0, 0))
					}
					local c_line = comm_get_line(player, gl_wt, sched)

					local cov_nr = dep_cnr3
					local name = loc3_name_obj
					local wag_name = loc4_name_obj
					local cab_name = loc5_name_obj
					local wag_nr = sc_wag3_nr
					local wag = true
					for (local j = 0; j<cov_nr;j++){
						if (!comm_set_convoy(j, c_depot, name))
							return 0
						for (local count = 0;count<wag_nr;count++){
							if (!comm_set_convoy(j, c_depot, wag_name, wag))
								return 0
						}
						if (!comm_set_convoy(j, c_depot, cab_name, wag))
							return 0
						local conv = depot.get_convoy_list()
						conv[j].set_line(player, c_line)
					}
					local convoy = false
					local all = true
					comm_start_convoy(player, convoy, depot, all)	
				}
				return null
				break
		}

		return null
	}
	
	function set_all_rules(pl) {
		local forbid =	[	4129,tool_build_way,tool_build_bridge,tool_build_tunnel,tool_build_station,
							tool_remove_way,tool_build_depot,tool_build_roadsign,tool_build_wayobj
						]
		foreach(wt in all_waytypes)
			if (wt != wt_rail){
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt )
			}
		if (this.step!=2 && this.step!=8){
			local forbid = [tool_setslope]
			foreach (tool_id in forbid)
			rules.forbid_tool(pl, tool_id )
		}
			
		local forbid =	[	4142,4134,4135,tool_lower_land,tool_raise_land,tool_restoreslope, tool_add_city,
							tool_make_stop_public,4137,tool_build_transformer,4107,4102,4127,4131
						]
		foreach (tool_id in forbid)
			rules.forbid_tool(pl, tool_id )

		switch (this.step) {
			case 1:
				local forbid=	[	4129,tool_build_way,tool_build_bridge,tool_build_tunnel,tool_build_station,
									tool_remove_way,tool_build_depot,tool_build_roadsign,tool_build_wayobj
								]
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt_rail)

				local forbid = [tool_build_station,tool_remover]
				foreach (tool_id in forbid)
					rules.forbid_tool(pl, tool_id )	
				break

			case 2:
				local forbid = [4129,tool_build_station,tool_build_depot,tool_build_roadsign,tool_build_wayobj]
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt_rail )

				local forbid = [tool_build_station]
				foreach (tool_id in forbid)
					rules.forbid_tool(pl, tool_id )				
				break

			case 3:
				local forbid =	[	4129,tool_build_way,tool_remove_way,tool_build_roadsign,tool_build_bridge,
									tool_build_tunnel,tool_build_depot,tool_build_roadsign,tool_build_wayobj
								]
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt_rail )
				break

			case 4:
				local forbid =	[	4129,tool_build_bridge,tool_build_tunnel,tool_build_station,
									tool_remove_way,tool_build_roadsign,tool_build_wayobj
								]
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt_rail )
				break

			case 5:
				local forbid =	[	4129,tool_build_way,tool_build_bridge,tool_build_tunnel,tool_build_depot,
									tool_build_station,tool_remove_way,tool_build_roadsign,tool_build_wayobj
								]
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt_rail )

				local forbid = [tool_build_station,tool_remover]
				foreach (tool_id in forbid)
					rules.forbid_tool(pl, tool_id )	
				break

			case 6:
				local forbid = [4129,tool_build_tunnel,tool_build_depot,tool_build_roadsign,tool_build_wayobj]
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt_rail )
				break

			case 7:
				local forbid = [tool_build_bridge,tool_build_tunnel,tool_build_roadsign]
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt_rail )
				break

			case 8:
				local forbid =	[	4129,tool_build_roadsign,tool_build_station,
									tool_build_depot,tool_build_roadsign,tool_build_wayobj
								]
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt_rail )

				local forbid = [tool_build_station,tool_build_bridge,tool_build_way]
				foreach (tool_id in forbid)
					rules.forbid_tool(pl, tool_id )		
				break

			case 9:
				local forbid = [tool_build_bridge,tool_build_tunnel,tool_build_wayobj,tool_build_station]
					foreach (tool_id in forbid)
						rules.forbid_way_tool(pl, tool_id, wt_rail )
				break

			case 10:
				local forbid =	[	tool_build_way,tool_build_roadsign,tool_build_bridge,
									tool_build_tunnel,tool_build_station,4113,4129
								]
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt_rail )

				local forbid = [tool_build_station]
				foreach (tool_id in forbid)
					rules.forbid_tool(pl, tool_id )	
				break

			case 11:
				local forbid =	[	tool_build_way,tool_build_roadsign,tool_build_bridge,tool_build_wayobj,
									tool_build_tunnel,tool_build_station,tool_remover,tool_build_depot,4113,4129
								]
				foreach (tool_id in forbid)
					rules.forbid_way_tool(pl, tool_id, wt_rail )


				foreach (tool_id in forbid)
					rules.forbid_tool(pl, tool_id )	
				break			
		}
	}
	function is_stations_building(pl, c_list, st_nr, good)
	{
		local sw = true
		for(local j=0;j<st_nr;j++){
			local tile = my_tile(c_list[j])  //tile_x(c_list[j].x, c_list[j].y, 0)
			local halt = tile.get_halt()
			local build = tile.find_object(mo_building)
			local way = tile.find_object(mo_way)
			if (halt){
				local sw = false
				local st_desc = build.get_desc()
				local st_list = building_desc_x.get_available_stations(st_desc.get_type(), st_desc.get_waytype(), good_desc_x(good))
							
				foreach(st in st_list){
					if (st.get_name() == st_desc.get_name())
						sw = true
				}
				glsw[j] = 1
				//count1=j
				tile.unmark()
				way.unmark()
				tile.remove_object(player_x(1), mo_label)
				if (sw){

					if(j+1 == st_nr) return true
				}
			}
			else if (sw){
				glsw[j] = 0
				tile.mark()
				way.mark()
				if(j!=0)
					label_x.create(c_list[j], player_x(pl), format(translate("Build station No.%d here!."),j+1))
				sw = false
			}
			else {
				tile.unmark()
				way.unmark()
				tile.remove_object(player_x(1), mo_label)
			}
		}
		return false
	}
    function get_stations(pos, tool_id, result, good, c_list, siz)
	{
		for(local j=0;j<siz;j++){
			local tile = my_tile(c_list[j])  //tile_x(c_list[j].x, c_list[j].y, 0)
			local halt = tile.get_halt()
			local build = tile.find_object(mo_building)
			local way = tile.find_object(mo_way)
			if(build){
				local st_desc = build.get_desc()
				local st_list = building_desc_x.get_available_stations(st_desc.get_type(), st_desc.get_waytype(), good_desc_x(good))
				local sw = false	
				foreach(st in st_list){
					if (st.get_name() == st_desc.get_name()){
						sw = true
						break
					}
				}
				if(!sw){
					if(tool_id == tool_remover){
						if((pos.x==c_list[j].x)&&(pos.y==c_list[j].y)) return null
					}
					return format(translate("Station No.%d must accept goods"), j+1)+" ("+coord(c_list[j].x, c_list[j].y).tostring()+")."
				}
			}
			if((pos.x==c_list[j].x)&&(pos.y==c_list[j].y)){
				if (tool_id == tool_build_station){
					if(build) return translate("There is already a station.")
					if(glsw[j] == 0 && way.is_marked()){
						way.unmark()
						tile.unmark()
						return null
					}
				}
			}
			else if(!build){
				if (tool_id == tool_build_station)
					return format(translate("Station No.%d here"),j+1)+" ("+coord(c_list[j].x, c_list[j].y).tostring()+")."
			}
		}
		return result
	}
	function train_result_message(nr, name, good, veh, cov, st_t)
	{
		switch (nr) {
			//case 0:
				//return format(translate("You must first buy a locomotive [%s]."),name)
			//	break

			case 0:
				return format(translate("Must choose a locomotive [%s]."),name)
				break

			case 1:
				return format(translate("The number of convoys must be [%d]."),cov)
				break

			case 2:
				return format(translate("The number of convoys must be [%d], press the [Sell] button."),cov)
				break

			case 3:
				return format(translate("All wagons must be for [%s]."),good)
				break

			case 4:
				return format(translate("The number of wagons must be [%d]."),veh-1)
				break

			case 5:
				return  format(translate("The train may not be longer than [%d] tiles."),st_t)
				break

			case 6:
				return  format(translate("The train cannot be shorter than [%d] tiles."),st_t)
				break

			default :
				return translate("The convoy is not correct.")
				break
		}
	}
}        // END of class

// END OF FILE
