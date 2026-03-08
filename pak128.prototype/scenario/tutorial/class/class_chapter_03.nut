/** @file class_chapter_03.nut
  * @brief Rail transport for goods and passengers
  */

/**
  * @brief class_chapter_03.nut
  * Rail transport for goods and passengers
  *
  * Can NOT be used in network game !
  *
  */
class tutorial.chapter_03 extends basic_chapter
{
  chapter_name  = ch3_name
  chapter_coord = coord_chapter_3
  startcash     = 50000000

  gl_wt = wt_rail
  gl_st = st_flat
  gl_tool = 0

  //Step 5 =====================================================================================
  ch3_cov_lim1 = {a = 0, b = 0}

  //Step 7 =====================================================================================
  ch3_cov_lim2 = {a = 0, b = 0}

  //Step 11 =====================================================================================
  ch3_cov_lim3 = {a = 0, b = 0}


  cy1 = {name = ""}
  cy2 = {name = ""}
  cy3 = {name = ""}
  cy4 = {name = ""}
  cy5 = {name = ""}

  //Step 5 =====================================================================================
  loc1_name_obj = get_veh_ch3(1)
  loc1_tile = calc_station_lenght(get_veh_ch3(1), get_veh_ch3(4), set_train_lenght(1))
  loc1_load = 100
  loc1_wait = 0
  f1_reached = set_transportet_goods(1)

  //Step 7 =====================================================================================
  loc2_name_obj = get_veh_ch3(2)
  loc2_tile = calc_station_lenght(get_veh_ch3(2), get_veh_ch3(5), set_train_lenght(2))
  loc2_load = 100
  loc2_wait = 0
  f3_reached = set_transportet_goods(2)


  dir_1 = {s = 28, r = 2 }    //Direccion de la slope y Way ribi

  //Step 11 =====================================================================================
  loc3_name_obj = get_veh_ch3(3)
  loc3_tile = calc_station_lenght(get_veh_ch3(3), get_veh_ch3(6), set_train_lenght(3))
  loc3_load = set_loading_capacity(4)
  loc3_wait = set_waiting_time(4)

  line1_name = "ch3_l1"

  dep_cnr3 = null //auto started

  //Script
  //----------------------------------------------------------------------------------
  sc_way_name = get_obj_ch3(1)
  sc_tunn_name = get_obj_ch3(5)
  sc_bridge_name = get_obj_ch3(2)
  sc_station_name = get_obj_ch3(3)
  sc_dep_name = null
  sc_veh1_name = get_veh_ch3(4)
  sc_veh2_name = get_veh_ch3(5)
  sc_wag3_name = get_veh_ch3(6)
  sc_sign_name = get_obj_ch3(6)
  sc_caten_name = get_obj_ch3(7)
  // different wg lenght
  // todo write func calc_train_lenght - actual not work
  //sc_wag1_nr = calc_train_lenght(get_veh_ch3(1), get_veh_ch3(4), 3)
  sc_wag1_nr = set_train_lenght(1)
  sc_wag2_nr = set_train_lenght(2)
  sc_wag3_nr = set_train_lenght(3)
  //------------------------------------------------------------------------------------

  //fab_list = null
  line2_name = "ch3_l2"
  line3_name = "ch3_l3"

  function start_chapter(){  //Inicia solo una vez por capitulo

    if ( pak_name == "pak128" ) {
      dir_1.s = 56
    }

    local lim_idx = cv_list[(persistent.chapter - 2)].idx
    ch3_cov_lim1 = {a = cv_lim[lim_idx].a, b = cv_lim[lim_idx].b}
    ch3_cov_lim2 = {a = cv_lim[lim_idx+1].a, b = cv_lim[lim_idx+1].b}
    ch3_cov_lim3 = {a = cv_lim[lim_idx+2].a, b = cv_lim[lim_idx+2].b}

    dep_cnr3 = get_dep_cov_nr(ch3_cov_lim3.a,ch3_cov_lim3.b)

    /// set depot name
    sc_dep_name = find_object("depot", wt_rail).get_name()

    cy1.name = get_city_name(city1_tow)
    cy2.name = get_city_name(city3_tow)
    cy3.name = get_city_name(city4_tow)
    cy4.name = get_city_name(city5_tow)
    cy5.name = get_city_name(city6_tow)

    local fab_list = [
          factory_data.rawget("1"),
          factory_data.rawget("2"),
          factory_data.rawget("3")
        ]

    line1_name = get_good_data(1, 3) + " " + fab_list[0].name + " - " + fab_list[1].name
    line2_name = get_good_data(2, 3) + " " + fab_list[1].name + " - " + fab_list[2].name
    line3_name = "Passanger Train"

  }

  function set_goal_text(text){

    local fac_1 = factory_data.rawget("1")
    local fac_2 = factory_data.rawget("2")
    local fac_3 = factory_data.rawget("3")

    if ( translate_objects_list.rawin("inspec") ) {
      if ( translate_objects_list.inspec != translate("Abfrage") ) {
        gui.add_message("change language")
        translate_objects()
      }
    } else {
      gui.add_message("error language object key")
    }

    switch (this.step) {
      case 1:
        if (pot[0]==0){
          text = ttextfile("chapter_03/01_1-2.txt")
          text.tx = ttext("<em>[1/2]</em>")
        }
        else {
          text = ttextfile("chapter_03/01_2-2.txt")
          text.tx = ttext("<em>[2/2]</em>")
        }
        break
      case 2:
        local c1 = way2_fac1_fac2[0].href("("+way2_fac1_fac2[0].tostring()+")")
        local c2 = way2_fac1_fac2[2].href("("+way2_fac1_fac2[2].tostring()+")")
        local c3 = way2_fac1_fac2[3].href("("+way2_fac1_fac2[3].tostring()+")")
        local c4 = way2_fac1_fac2[5].href("("+way2_fac1_fac2[5].tostring()+")")

        if (pot[0]==0){
          local c = way2_fac1_fac2[1]
          local c_label = c.href("("+c.tostring()+")")
          local way = tile_x(c.x, c.y, c.z).find_object(mo_way)
          if(!way) c2 = c_label

          text = ttextfile("chapter_03/02_1-3.txt")
          text.tx = ttext("<em>[1/3]</em>")
        }
        else if (pot[1]==0){
          text = ttextfile("chapter_03/02_2-3.txt")
          text.tx = ttext("<em>[2/3]</em>")
        }
        else if (pot[2]==0){
          local c = way2_fac1_fac2[5]
          local c_label = c.href("("+c.tostring()+")")
          local way = tile_x(c.x, c.y, c.z).find_object(mo_way)
          if(!way) c4 = c_label

          text = ttextfile("chapter_03/02_3-3.txt")
          text.tx = ttext("<em>[3/3]</em>")
        }
        text.br = bridge2_coords.b.href("("+bridge2_coords.b.tostring()+")")
        text.w1 = c1
        text.w2 = c2
        text.w3 = c3
        text.w4 = c4

        if (r_way.r)
          text.cbor = "<em>" + translate("Ok") + "</em>"
        else
          text.cbor = coord(r_way.c.x, r_way.c.y).href("("+coord3d_to_string(r_way.c)+")")

        break
      case 3:
        if (pot[0]==0){
          text = ttextfile("chapter_03/03_1-2.txt")
          text.tx = ttext("<em>[1/2]</em>")
        }
        else if (pot[0]==1&&pot[1]==0){
          text = ttextfile("chapter_03/03_2-2.txt")
          text.tx = ttext("<em>[2/2]</em>")
        }
        text.tile = loc1_tile
        break
      case 4:
        if (pot[0]==0){
          text = ttextfile("chapter_03/04_1-3.txt")
          text.tx=ttext("<em>[1/3]</em>")
        }
        else if (pot[0]==1&&pot[1]==0){
          text = ttextfile("chapter_03/04_2-3.txt")
          text.tx=ttext("<em>[2/3]</em>")
        }
        else if (pot[1]==1){
          text = ttextfile("chapter_03/04_3-3.txt")
          text.tx=ttext("<em>[3/3]</em>")
        }
        text.w1 = ch3_rail_depot1.b.href("("+ch3_rail_depot1.b.tostring()+")")
        text.w2 = ch3_rail_depot1.a.href("("+ch3_rail_depot1.a.tostring()+")")
        text.dep = ch3_rail_depot1.b.href("("+ch3_rail_depot1.b.tostring()+")")
        break
      case 5:
        text.reached = reached
        text.t_reach = f1_reached + " " + get_good_data(1, 1)
        text.loc1 = translate(loc1_name_obj)
        text.wag = sc_wag1_nr
        text.tile = loc1_tile
        text.load = loc1_load
        local tile = my_tile(way2_fac1_fac2[0])
        text.stnam1 = tile.href(""+tile.get_halt().get_name())
        tile = my_tile(way2_fac1_fac2[way2_fac1_fac2.len()-1])
        text.stnam2 = tile.href(""+tile.get_halt().get_name())
        text.wait = get_wait_time_text(loc1_wait)
        break
      case 6:
        local c1 = way2_fac2_fac3[0].href("("+way2_fac2_fac3[0].tostring()+")")
        local c2 = way2_fac2_fac3[2].href("("+way2_fac2_fac3[2].tostring()+")")
        local c3 = way2_fac2_fac3[3].href("("+way2_fac2_fac3[3].tostring()+")")
        local c4 = way2_fac2_fac3[5].href("("+way2_fac2_fac3[5].tostring()+")")

        if (pot[0]==0){
          local c = way2_fac2_fac3[1]
          local c_label = c.href("("+c.tostring()+")")
          local way = tile_x(c.x, c.y, c.z).find_object(mo_way)
          if(!way) c2 = c_label

          text = ttextfile("chapter_03/06_1-5.txt")
          text.tx=ttext("<em>[1/5]</em>")
        }
        else if (pot[1]==0){
          text = ttextfile("chapter_03/06_2-5.txt")
          text.tx=ttext("<em>[2/5]</em>")
        }
        else if (pot[2]==0){
          local c = way2_fac2_fac3[4]
          local c_label = c.href("("+c.tostring()+")")
          local way = tile_x(c.x, c.y, c.z).find_object(mo_way)
          if(!way) c4 = c_label

          text = ttextfile("chapter_03/06_3-5.txt")
          text.tx=ttext("<em>[3/5]</em>")
        }
        else if (pot[3]==0){
          text = ttextfile("chapter_03/06_4-5.txt")
          text.tx=ttext("<em>[4/5]</em>")
        }
        else if (pot[4]==0){
          text = ttextfile("chapter_03/06_5-5.txt")
          text.tx = ttext("<em>[5/5]</em>")
        }
        text.tu = way2_fac2_fac3[2].href("("+way2_fac2_fac3[2].tostring()+")")
        text.w1 = c1
        text.w2 = c2
        text.w3 = c3
        text.w4 = c4
        text.tile = loc2_tile
        break
      case 7:
        text.reached = reached
        text.t_reach = f3_reached
        text.loc2 = translate(loc2_name_obj)
        text.wag = sc_wag2_nr
        text.tile = loc2_tile
        text.load = loc2_load
        local tile = my_tile(way2_fac2_fac3[0])
        text.stnam1 = tile.href(""+tile.get_halt().get_name())
        tile = my_tile(way2_fac2_fac3[way2_fac2_fac3.len()-1])
        text.stnam2 = tile.href(""+tile.get_halt().get_name())
        text.wait = get_wait_time_text(loc2_wait)
        text.w1 = ch3_rail_depot2.a.href("("+ch3_rail_depot2.a.tostring()+")")
        text.w2 = ch3_rail_depot2.b.href("("+ch3_rail_depot2.b.tostring()+")")
        break
      case 8:

        if(pot[0]==0){
          text = ttextfile("chapter_03/08_1-5.txt")
          text.tx = ttext("<em>[1/5]</em>")
          text.w1 = c_way3_lim.b.href("("+c_way3_lim.b.tostring()+")")
          text.w2 = c_way3_lim.a.href("("+c_way3_lim.a.tostring()+")")
        }
        else if(pot[1]==0){
          text = ttextfile("chapter_03/08_2-5.txt")
          text.tx = ttext("<em>[2/5]</em>")
          text.br = bridge3_coords.a.href("("+bridge3_coords.a.tostring()+")")
        }
        else if (pot[2]==0){
          text = ttextfile("chapter_03/08_3-5.txt")
          text.tx = ttext("<em>[3/5]</em>")
          text.t1 = "<a href=\"("+ way3_tun_coord[0].x+","+ way3_tun_coord[0].y+")\">("+ way3_tun_coord[0].tostring()+")</a>"
        }
        else if(pot[3]==0){
          local slope = tile_x(r_way.c.x, r_way.c.y, r_way.c.z).get_slope()
          if(r_way.c.z<way3_tun_list[way3_tun_list.len()-1].z){
            text = ttextfile("chapter_03/08_4-5.txt")
            text.tx = ttext("<em>[4/5]</em>")
            local tx_list = ""

            local c_bord = coord(r_way.c.x, r_way.c.y)
            for(local j=0; j < way3_tun_list.len(); j++){
              local c = slope==0?c_bord:coord(way3_tun_list[j].x, way3_tun_list[j].y)
              local c_z = way3_tun_list[j].z
              local layer_lvl = way3_tun_list[j].z
              if (glsw[j]==0){
                c = coord3d(c.x, c.y, c_z)
                local link = c.href("("+c.tostring()+")")
                local layer = translate("Layer level")+" = <st>"+(way3_tun_list[j].z)+"</st>"
                tx_list += ttext("--> <st>" + format("[%d]</st> %s %s<br>", j+1, link, layer))
                text.lev = way3_tun_list[0].z
                text.tunn = link
                break
              }
              else {
                c = coord3d(c.x, c.y, c_z)
                local link = c.href("("+c.tostring()+")")
                local tx_ok = translate("OK")
                local tx_coord = "("+coord(way3_tun_list[j].x, way3_tun_list[j].y).tostring()+","+c_z+")"
                local layer = translate("Layer level")+" = "+(way3_tun_list[j].z)+""
                tx_list += ttext("<em>"+format("<em>[%d]</em> %s", j+1, tx_coord+" "+layer+" <em>"+tx_ok+"</em><br>"))
                text.lev = way3_tun_list[0].z
                text.tunn = link
              }
            }
            text.mx_lvl = way3_tun_list[way3_tun_list.len()-1].z
            text.list = tx_list
          }
          else{
            text = ttextfile("chapter_03/08_5-5.txt")
            text.tx = ttext("<em>[5/5]</em>")
            text.lev = way3_tun_list[way3_tun_list.len()-1].z
            text.t1 = "<a href=\"("+ way3_tun_coord[0].x+","+ way3_tun_coord[0].y+")\">("+ way3_tun_coord[0].tostring()+")</a>"
            text.t2 = "<a href=\"("+ way3_tun_coord[way3_tun_coord.len()-1].x+","+ way3_tun_coord[way3_tun_coord.len()-1].y+")\">("+ way3_tun_coord[way3_tun_coord.len()-1].tostring()+")</a>"
          }
        }
        text.plus = key_alias.plus_s
        text.minus = key_alias.minus_s
        break

      case 9:

        if (pot[0]==0){
          local way_list = ""
          text = ttextfile("chapter_03/09_1-2.txt")
          text.tx = ttext("<em>[1/2]</em>")
          local w_nr = 0
          for(local j=0;j<way3_cy1_cy6.len();j++){
            local c_a = way3_cy1_cy6[j].a
            local c_b = way3_cy1_cy6[j].b
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
          text.w2 = way3_cy1_cy6[w_nr].a.href("("+way3_cy1_cy6[w_nr].a.tostring()+")")
          text.w1 = way3_cy1_cy6[w_nr].b.href("("+way3_cy1_cy6[w_nr].b.tostring()+")")
        }

        else if (pot[1]==0){
          text = ttextfile("chapter_03/09_2-2.txt")
          text.tx = ttext("<em>[2/2]</em>")
          local sigtxt = ""
          local list = way3_sign_list
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
        if (pot[0]==0){
            if (glsw[1]==0){
            text = ttextfile("chapter_03/10_1-4.txt")
            text.tx = ttext("<em>[1/4]</em>")
          }
            else {
            text = ttextfile("chapter_03/10_2-4.txt")
            text.tx = ttext("<em>[2/4]</em>")
          }
        }
        else if (pot[1]==0){
          text = ttextfile("chapter_03/10_3-4.txt")
          text.tx = ttext("<em>[3/4]</em>")
        }
        else if (pot[2]==0){
          text = ttextfile("chapter_03/10_4-4.txt")
          text.tx = ttext("<em>[4/4]</em>")
        }

        text.dep = ch3_rail_depot3.b.href("("+ch3_rail_depot3.b.tostring()+")")

        break

      case 11:

        local tx_list = ""
        local nr = ch3_rail_stations.len()
        local list = ch3_rail_stations

        local mark_st = 0
        for ( local j = 0; j < nr; j++ ){
          local c = coord(list[j].x, list[j].y)
          local tile = my_tile(c)
          local st_halt = tile.get_halt()

          local st_list = check_rail_station(list[mark_st], 1)
          if ( j == mark_st ) {
            delay_mark_tile(st_list)
          }

          if( tmpsw[j] == 0 ){
            tx_list += format("<st>%s %d:</st> %s<br>", translate("Stop"), j+1, c.href(st_halt.get_name()+" ("+c.tostring()+")"))
          }
          else{
            tx_list += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
            delay_mark_tile(st_list, true)
            mark_st++
          }
        }
        local c = coord(list[get_waiting_halt(4)].x, list[get_waiting_halt(4)].y)
        text.stnam = (get_waiting_halt(4)+1) + ") " + my_tile(c).get_halt().get_name() + " ("+c.tostring()+")"
        text.list = tx_list
        text.dep = ch3_rail_depot3.b.href("("+ch3_rail_depot3.b.tostring()+")")
        text.loc3 = translate(loc3_name_obj)
        text.load = loc3_load
        text.wait = get_wait_time_text(loc3_wait)
        text.cnr = dep_cnr3
        text.tile = loc3_tile
        text.wag = sc_wag3_nr

        break
    }

    if ( this.step >= 1 && this.step <= 4 ) {
      local stext = ttextfile("chapter_03/step_1-4_hinfo.txt")
      stext.good1 = get_good_data(1, 3)
      stext.good2 = get_good_data(2, 3)
      stext.f1 = fac_1.c.href(fac_1.name+" ("+fac_1.c.tostring()+")")
      stext.f2 = fac_2.c.href(fac_2.name+" ("+fac_2.c.tostring()+")")
      text.step_hinfo = stext
    }
    if ( this.step >= 8 && this.step <= 10 ) {
      local stext = ttextfile("chapter_03/step_8-10_hinfo.txt")
      stext.cy1=cy1.name
      stext.cy2=cy2.name
      stext.cy3=cy3.name
      stext.cy4=cy4.name
      stext.cy5=cy5.name

      stext.co1=city1_tow.href("("+city1_tow.tostring()+")")
      stext.co2=city3_tow.href("("+city3_tow.tostring()+")")
      stext.co3=city4_tow.href("("+city4_tow.tostring()+")")
      stext.co4=city5_tow.href("("+city5_tow.tostring()+")")
      stext.co5=city6_tow.href("("+city6_tow.tostring()+")")
      text.step_hinfo = stext
    }

    text.f1 = fac_1.c.href(fac_1.name+" ("+fac_1.c.tostring()+")")
    text.f2 = fac_2.c.href(fac_2.name+" ("+fac_2.c.tostring()+")")
    text.f3 = fac_3.c.href(fac_3.name+" ("+fac_3.c.tostring()+")")

    text.cdep=ch3_rail_depot1.b.href("("+ch3_rail_depot1.b.tostring()+")")
    text.way1=ch3_rail_depot2.a.href("("+ch3_rail_depot2.a.tostring()+")")

    text.cy1=cy1.name
    text.cy2=cy2.name
    text.cy3=cy3.name
    text.cy4=cy4.name
    text.cy5=cy5.name

    text.co1=city1_tow.href("("+city1_tow.tostring()+")")
    text.co2=city3_tow.href("("+city3_tow.tostring()+")")
    text.co3=city4_tow.href("("+city4_tow.tostring()+")")
    text.co4=city5_tow.href("("+city5_tow.tostring()+")")
    text.co5=city6_tow.href("("+city6_tow.tostring()+")")
    text.cbor = ""
    if (r_way.r)
      text.cbor = "<em>" + translate("Ok") + "</em>"
    else
      text.cbor = coord(r_way.c.x, r_way.c.y).href("("+coord3d_to_string(r_way.c)+")")

    text.tool1 = translate_objects_list.inspec
    text.tool2 = translate_objects_list.tools_rail
    text.tool3 = translate_objects_list.tools_slope
    // good data
    text.good1 = get_good_data(1, 3)
    text.g1_metric = get_good_data(1, 1)
    text.good2 = get_good_data(2, 3)
    text.g2_metric =get_good_data(2, 1)
    // prod data
    local g_in = read_prod_data(fac_2.c, 1, "in")
    text.prod_in   = integer_to_string(g_in[0])
    text.g1_factor = g_in[2]
    text.g1_consum = integer_to_string(g_in[1])
    local g_out = read_prod_data(fac_2.c, 2, "out")
    text.prod_out  = integer_to_string(g_out[0])
    text.g2_factor = g_out[2]
    text.g2_prod   = integer_to_string(g_out[1])

    return text

  }

  function is_chapter_completed(pl) {
    save_pot()
    save_glsw()

    persistent.ch_max_steps = 11
    local chapter_step = persistent.step
    persistent.ch_max_sub_steps = 0 // count all sub steps
    persistent.ch_sub_step = 0  // actual sub step

    local fac_1 =  factory_data.rawget("1")
    local fac_2 =  factory_data.rawget("2")
    local fac_3 =  factory_data.rawget("3")

    switch (this.step) {
      case 1:
        persistent.ch_max_sub_steps = 2
        local next_mark = false
        if (pot[0]==0 || pot[1] == 0) {
          local list = fac_2.c_list
          try {
            next_mark = delay_mark_tile(list)
          }
          catch(ev) {
            return 0
          }
          if(next_mark && pot[0] == 1) {
            pot[1]=1
          }
        }
        else if (pot[2]==0 || pot[3]==0) {
          local list = fac_1.c_list
          try {
            next_mark = delay_mark_tile(list)
          }
          catch(ev) {
            return 0
          }
          if(next_mark && pot[2] == 1) {
            pot[3]=1
          }
          persistent.ch_sub_step = 1
        }
        else if (pot[3]==1 && pot[4]==0) {
          this.next_step()
        }
        //return 5
        break;
      case 2:
        persistent.ch_max_sub_steps = 3
        //Primer tramo de rieles
        if (pot[0]==0){
          local limi = my_tile(way2_fac1_fac2[1])
          local tile1 = my_tile(way2_fac1_fac2[0])
          if (!tile1.find_object(mo_way)){
            label_x.create(way2_fac1_fac2[0], pl_unown, translate("Build Rails form here"))
          }
          else
            tile1.remove_object(player_x(1), mo_label)

          local tile2 = my_tile(limi)
          if (!tile2.find_object(mo_way)){
            label_x.create(limi, pl_unown, translate("Build Rails form here"))

            //elimina el cuadro label
            /*local opt = 0
            local del = true
            local text = "X"
            label_bord(bord1_lim.a, bord1_lim.b, opt, del, text)*/
          }


          if (tile2.find_object(mo_label) && r_way.c.x<=limi.x) {
            if (!tile_x(wayend.x, wayend.y, wayend.z).find_object(mo_way)) {
              label_x.create(wayend, pl_unown, translate("Build Rails form here"))

            }
            //Creea un cuadro label

            local test_way = test_select_way(tile1, tile2, wt_rail)
            if (test_way) {
              local opt = 0
              local del = false
              local text = "X"
              label_bord(limit_ch3_rail_line_1a.a, limit_ch3_rail_line_1a.b, opt, del, text)

              tile2.remove_object(player_x(1), mo_label)

            }
          }


          local opt = 0
          local coora = tile_x(way2_fac1_fac2[0].x, way2_fac1_fac2[0].y, way2_fac1_fac2[0].z)
          local coorb = tile_x(way2_fac1_fac2[2].x, way2_fac1_fac2[2].y, way2_fac1_fac2[2].z)
          //gui.add_message("get_fullway_dir "+get_fullway_dir(way2_fac1_fac2[0], way2_fac1_fac2[1]))
          local dir = get_fullway_dir(way2_fac1_fac2[0], way2_fac1_fac2[1])
          local obj = false
          local wt = wt_rail

          wayend = coorb
          r_way = get_fullway(coora, coorb, dir, obj)
          if (r_way.r) {
            tile_x(coora.x, coora.y, coora.z).find_object(mo_way).unmark()
            tile_x(coorb.x, coorb.y, coorb.z).remove_object(player_x(1), mo_label)
            tile1.remove_object(player_x(1), mo_label)

            //elimina el cuadro label
            local opt = 0
            local del = true
            local text = "X"
            label_bord(limit_ch3_rail_line_1a.a, limit_ch3_rail_line_1a.b, opt, del, text)

            pot[0]=1
            wayend=0
          }
        }
        //Para el puente
        else if (pot[0]==1&&pot[1]==0) {
          persistent.ch_sub_step = 1  // sub step finish
          local tile = my_tile(bridge2_coords.a)
          if ((!tile.find_object(mo_bridge))){
            label_x.create(tile, pl_unown, translate("Build a Bridge here!."))
            label_x.create(my_tile(bridge2_coords.b), pl_unown, translate("Build a Bridge here!."))
            r_way.c =   coord3d(tile.x, tile.y, tile.z)
          }
          else {
            tile.remove_object(player_x(1), mo_label)
            my_tile(bridge2_coords.b).remove_object(player_x(1), mo_label)

            if (my_tile(bridge2_coords.a).find_object(mo_bridge)){
              pot[1]=1
            }
          }
        }
        //Segundo tramo de rieles
        else if (pot[1]==1 && pot[2]==0){
          persistent.ch_sub_step = 2  // sub step finish
          local limi = my_tile(coord(way2_fac1_fac2[4].x, way2_fac1_fac2[4].y))
          local tile1 = limi
          if (r_way.c.y > limi.y){
            label_x.create(limi, pl_unown, translate("Build Rails form here"))
            //Creea un cuadro label
            local opt = 0
            local del = false
            local text = "X"
            label_bord(limit_ch3_rail_line_1b.a, limit_ch3_rail_line_1b.b, opt, del, text)
          }
          else {
            tile1.remove_object(player_x(1), mo_label)
            //elimina el cuadro label
            local opt = 0
            local del = true
            local text = "X"
            label_bord(limit_ch3_rail_line_1b.a, limit_ch3_rail_line_1b.b, opt, del, text)
            if (!tile1.find_object(mo_label))
              label_x.create(way2_fac1_fac2[5], pl_unown, translate("Build Rails form here"))
          }

          local opt = 0
          local coora = my_tile(way2_fac1_fac2[3])
          local coorb = my_tile(way2_fac1_fac2[5])
          local dir = get_fullway_dir(way2_fac1_fac2[0], way2_fac1_fac2[1])//c_way3.dir
          local obj = false
          wayend = coorb

          r_way = get_fullway(coora, coorb, dir, obj)
          if (r_way.r){

            //elimina el cuadro label
            local opt = 0
            local del = true
            local text = "X"
            label_bord(limit_ch3_rail_line_1b.a, limit_ch3_rail_line_1b.b, opt, del, text)

            tile_x(coorb.x, coorb.y, coorb.z).remove_object(player_x(1), mo_label)
            tile1.remove_object(player_x(1), mo_label)
            this.next_step()
          }
        }
        //return 10
        break;
      case 3:
        glresult = null

        persistent.ch_max_sub_steps = 2

        local passa = good_alias.passa
        local mail = good_alias.mail

        if (pot[1]==0){
          //Estaciones de la Fabrica
          local pl_nr = 1
          local c_list = station_tiles(way2_fac1_fac2[5], way2_fac1_fac2[4], loc1_tile)
          local st_nr = c_list.len() //Numero de estaciones
          local good = good_alias.goods
          local result = is_stations_building(pl_nr, c_list, st_nr, good)

          if(result){
            pot[0]=1
          }
        }

        if (pot[0]==1 && pot[1]==0){
          persistent.ch_sub_step = 1  // sub step finish

          //Estaciones de la Fabrica
          local pl_nr = 1
          local c_list = station_tiles(way2_fac1_fac2[0], way2_fac1_fac2[1], loc1_tile)
          local st_nr = c_list.len() //Numero de estaciones
          local good = good_alias.goods
          local result = is_stations_building(pl_nr, c_list, st_nr, good)

          if (result){
            this.next_step()
          }
        }
        //return 15
        break
      case 4:
        persistent.ch_max_sub_steps = 3
        local tile = my_tile(ch3_rail_depot1.b)
        if(pot[0]==0){
          local c_list = [my_tile(ch3_rail_depot1.b), my_tile(ch3_rail_depot1.a)]
          local next_mark = true
          try {
             next_mark = delay_mark_tile(c_list)
          }
          catch(ev) {
            return 0
          }
          if(!tile.find_object(mo_way)){
            label_x.create(tile, pl_unown, translate("Build Rails form here"))
          }
          else{
            local stop_mark = true
            try {
               next_mark = delay_mark_tile(c_list, stop_mark)
            }
            catch(ev) {
              return 0
            }
            pot[0]=1
          }
        }

        else if(pot[0]==1 && pot[1]==0){
          persistent.ch_sub_step = 1  // sub step finish
          local label = tile.find_object(mo_label)
          if(!tile.find_object(mo_depot_rail)){
            label.set_text(translate("Build Train Depot here!."))
          }
          else{
            tile.remove_object(player_x(1), mo_label)
            pot[1]=1
          }
        }

        else if ( pot[0]==1 && pot[1]==1 && pot[2]==0 ) {
          persistent.ch_sub_step = 2  // sub step finish
        }

        else if(pot[2]==1){
          this.next_step()
        }
        //return 16
        break
      case 5:
        if (!correct_cov)
          return 0

        local wt = wt_rail

        if (current_cov == ch3_cov_lim1.b){
          reached = get_reached_target(fac_2.c, good_alias.wood )
          if (reached>= f1_reached){
            pot[1]=1
          }
        }

        if (pot[1]==1 && pot[0]==0){
          //Marca tiles para evitar construccion de objetos
          /*local c_list = c_lock
          local siz = c_lock.len()
          local del = false
          local pl_nr = 1
          local text = "X"
                    lock_tile_list(c_list, siz, del, pl_nr, text)*/

          this.next_step()
          reset_stop_flag()
          reached = 0
        }
        //return 30
        break
      case 6:
        persistent.ch_max_sub_steps = 5
        //Primer tramo de rieles
        if (pot[0]==0){

          local limi = way2_fac2_fac3[1]
          local tile1 = my_tile(way2_fac2_fac3[0])
          if (!tile1.find_object(mo_way)){
            label_x.create(way2_fac2_fac3[0], pl_unown, translate("Build Rails form here"))
          }
          else
            tile1.remove_object(player_x(1), mo_label)

          local tile2 = my_tile(limi)
          if (!tile2.find_object(mo_way)){
            label_x.create(limi, pl_unown, translate("Build Rails form here"))

            //elimina el cuadro label
            local opt = 0
            local del = true
            local text = "X"
            label_bord(limit_ch3_rail_line_2a.a, limit_ch3_rail_line_2a.b, opt, del, text)
          }
          if (tile_x(r_way.c.x, r_way.c.y, r_way.c.z).find_object(mo_way) && r_way.c.y>=limi.y){

            tile2.remove_object(player_x(1), mo_label)
            if (!tile_x(wayend.x, wayend.y, wayend.z).find_object(mo_way))
              label_x.create(wayend, pl_unown, translate("Build Rails form here"))
            //Creea un cuadro label
            local opt = 0
            local del = false
            local text = "X"
            label_bord(limit_ch3_rail_line_2a.a, limit_ch3_rail_line_2a.b, opt, del, text)
          }

          local opt = 0
          local coora = coord3d(way2_fac2_fac3[0].x, way2_fac2_fac3[0].y, way2_fac2_fac3[0].z)
          local coorb = coord3d(way2_fac2_fac3[2].x, way2_fac2_fac3[2].y, way2_fac2_fac3[2].z)
          local obj = false
          local dir = get_fullway_dir(way2_fac2_fac3[0], way2_fac2_fac3[1])  // 3

          wayend = coorb

          r_way = get_fullway(coora, coorb, dir, obj)
          if (r_way.r){
            tile_x(coora.x, coora.y, coora.z).find_object(mo_way).unmark()
            tile_x(wayend.x, wayend.y, coorb.z).remove_object(player_x(1), mo_label)

            //elimina el cuadro label
            local opt = 0
            local del = true
            local text = "X"
            label_bord(limit_ch3_rail_line_2a.a, limit_ch3_rail_line_2a.b, opt, del, text)

            pot[0] = 1
            wayend = 0
          }
        }
        //Para el tunel
        else if (pot[0]==1 && pot[1]==0){
          persistent.ch_sub_step = 1  // sub step finish
          local tile = my_tile(way2_fac2_fac3[2])
          if ((!tile.find_object(mo_tunnel))){
            label_x.create(way2_fac2_fac3[2], pl_unown, translate("Place a Tunnel here!."))
            r_way.c =   coord3d(tile.x, tile.y, tile.z)
          }
          else {
            tile.remove_object(player_x(1), mo_label)

            if (my_tile(way2_fac2_fac3[3]).find_object(mo_tunnel)){
            }
          }
          local opt = 0
          local coora = coord3d(way2_fac2_fac3[2].x, way2_fac2_fac3[2].y, way2_fac2_fac3[2].z)
          local coorb = coord3d(way2_fac2_fac3[3].x, way2_fac2_fac3[3].y, way2_fac2_fac3[3].z)
          local obj = false
          local tunnel = true
          local dir = get_fullway_dir(way2_fac2_fac3[2], way2_fac2_fac3[3]) // 5
          wayend = coorb
          r_way = get_fullway(coora, coorb, dir, obj, tunnel)
          if (r_way.r){
            pot[1]=1
            wayend = 0
          }
        }
        //Segundo tramo de rieles
        else if (pot[1]==1 && pot[2]==0){
          persistent.ch_sub_step = 2  // sub step finish
          local limi = way2_fac2_fac3[4]
          local tile1 = my_tile(limi)
          local tile2 = my_tile(way2_fac2_fac3[5])
          if (r_way.c.y < limi.y){
            label_x.create(limi, pl_unown, translate("Build Rails form here"))
            //Creea un cuadro label
            local opt = 0
            local del = false
            local text = "X"
            label_bord(limit_ch3_rail_line_2b.a, limit_ch3_rail_line_2b.b, opt, del, text)
          }
          else {
            tile1.remove_object(player_x(1), mo_label)
            //elimina el cuadro label
            local opt = 0
            local del = true
            local text = "X"
            label_bord(limit_ch3_rail_line_2b.a, limit_ch3_rail_line_2b.b, opt, del, text)

            if (!tile2.find_object(mo_way))
              label_x.create(way2_fac2_fac3[5], pl_unown, translate("Build Rails form here"))
          }
          local opt = 0
          local coora = coord3d(way2_fac2_fac3[3].x, way2_fac2_fac3[3].y, way2_fac2_fac3[3].z)
          local coorb = coord3d(way2_fac2_fac3[5].x, way2_fac2_fac3[5].y, way2_fac2_fac3[5].z)
          local obj = false
          local dir = get_fullway_dir(way2_fac2_fac3[2], way2_fac2_fac3[3])
          wayend = coorb
          r_way = get_fullway(coora, coorb, dir, obj)
          if (r_way.r){
            tile1.remove_object(player_x(1), mo_label)
            tile2.remove_object(player_x(1), mo_label)
            //elimina el cuadro label
            local opt = 0
            local del = true
            local text = "X"
            label_bord(limit_ch3_rail_line_2b.a, limit_ch3_rail_line_2b.b, opt, del, text)

            pot[2]=1
            wayend = 0
          }
        }

        //Text label para las estaciones
        else if (pot[2]==1 && pot[3]==0){
          persistent.ch_sub_step = 3  // sub step finish
          glresult = null
          local passa = good_alias.passa
          local mail = good_alias.mail

          //Estaciones de la Fabrica
          local pl_nr = 1
          local c_list = station_tiles(way2_fac2_fac3[5], way2_fac2_fac3[4], loc2_tile)
          local st_nr = c_list.len() //Numero de estaciones
          local good = good_alias.goods
          local result = is_stations_building(pl_nr, c_list, st_nr, good)

          if(result){
            pot[3] = 1
          }
        }
        else if (pot[3]==1 && pot[4]==0){
          persistent.ch_sub_step = 4  // sub step finish
          glresult = null
          local passa = good_alias.passa
          local mail = good_alias.mail

          //Estaciones de la Fabrica
          local pl_nr = 1
          local c_list = station_tiles(way2_fac2_fac3[0], way2_fac2_fac3[1], loc2_tile)
          local st_nr = c_list.len() //Numero de estaciones
          local good = good_alias.goods
          local result = is_stations_building(pl_nr, c_list, st_nr, good)

          if(result){
            pot[4] = 1
          }
        }
        else if (pot[4]==1 && pot[5]==0){
          //Elimina las Marcas de tiles
          /*local c_list = c_lock
          local siz = c_lock.len()
          local del = true
          local pl_nr = 1
          local text = "X"
          lock_tile_list(c_list, siz, del, pl_nr, text)*/

          this.next_step()
        }
        //return 35
        break
      case 7:
        if (!correct_cov)
          return 0

        local opt = 2
        local wt = gl_wt
        local tile = my_tile(ch3_rail_depot2.a)
        if(pot[0]==0){
          local c_list = [my_tile(ch3_rail_depot2.b), my_tile(ch3_rail_depot2.a)]
          local next_mark = true
          try {
             next_mark = delay_mark_tile(c_list)
          }
          catch(ev) {
            return 0
          }
          if(!tile.find_object(mo_way)){
            label_x.create(tile, pl_unown, translate("Build Rails form here"))
          }
          else{
            local stop_mark = true
            try {
               next_mark = delay_mark_tile(c_list, stop_mark)
            }
            catch(ev) {
              return 0
            }
            pot[0]=1
          }
        }

        else if(pot[0]==1 && pot[1]==0){
          local label = tile.find_object(mo_label)
          if(!tile.find_object(mo_depot_rail)){
            label.set_text(translate("Build Train Depot here!."))
          }
          else{
            tile.remove_object(player_x(1), mo_label)
            pot[1]=1
          }
        }

        else if(current_cov == ch3_cov_lim2.b){
          reached = get_reached_target(fac_3.c, good_alias.plan)
          if (reached>=f3_reached){
            pot[3]=1
          }
        }

        if (pot[3]==1 && pot[4]==0){
          this.next_step()
          reset_stop_flag()
          reached = 0
        }

        //return 40
        break
      case 8:
        persistent.ch_max_sub_steps = 5
        //Para el tramo de via
        if (pot[0]==0){
          local coora = coord3d(way3_cy1_cy3.a.x, way3_cy1_cy3.a.y, way3_cy1_cy3.a.z)
          local coorb = coord3d(way3_cy1_cy3.b.x, way3_cy1_cy3.b.y, way3_cy1_cy3.b.z)
          local obj = false
          local tunnel = false
          local dir = get_dir_start(coora)
          r_way = get_fullway(coora, coorb, dir, obj, tunnel)
          if (r_way.r){
            pot[0]=1
            //return 45
          }
        }
        //Para el puente
        else if (pot[0]==1 && pot[1]==0){
          persistent.ch_sub_step = 1  // sub step finish
          local tile = my_tile(bridge3_coords.a)
          if ((!tile.find_object(mo_bridge))){
            label_x.create(bridge3_coords.a, pl_unown, translate("Build a Bridge here!."))
            label_x.create(my_tile(bridge3_coords.b), pl_unown, translate("Build a Bridge here!."))
            r_way.c =   coord3d(tile.x, tile.y, tile.z)
          }
          else {
            tile.remove_object(player_x(1), mo_label)
            my_tile(bridge3_coords.b).remove_object(player_x(1), mo_label)

            if (my_tile(bridge3_coords.b).find_object(mo_bridge)){
              pot[1]=1
            }
          }
        }
        //Para la entrada del tunel
        else if (pot[1]==1 && pot[2]==0){
          persistent.ch_sub_step = 2  // sub step finish
          local t_tunn = my_tile(way3_tun_coord[0])

          if (!t_tunn.find_object(mo_tunnel)){
            local label_t =  my_tile(way3_tun_coord[0])
            local lab = label_t.find_object(mo_label)
            if(lab){
              if(label_t.is_marked()){
                if(gl_tool == tool_build_tunnel){
                  lab.set_text(translate("Press [Ctrl] to build a tunnel entrance here")+".")
                }
                else{
                  lab.set_text(translate("Place a Tunnel here!."))
                }
              }
              else{
                gl_tool = 0
                lab.set_text(translate("Place a Tunnel here!."))
              }
            }
            else{
              label_x.create(way3_tun_coord[0], pl_unown, translate("Place a Tunnel here!."))
            }
          }
          else{
            pot[2]=1
            t_tunn.remove_object(player_x(1), mo_label)
          }
        }
        //Para conectar las dos entradas del tunel
        else if (pot[2]==1 && pot[3]==0){
          persistent.ch_sub_step = 3  // sub step finish
          local coora = coord3d(way3_tun_coord[0].x, way3_tun_coord[0].y, way3_tun_coord[0].z)
          local coorb = coord3d(way3_tun_coord[2].x, way3_tun_coord[2].y, way3_tun_coord[2].z)
          local obj = false
          local tunnel = true
          local dir = get_dir_start(coora)
          r_way = get_fullway(coora, coorb, dir, obj, tunnel)
          //gui.add_message("plus "+r_way.p)
          if (r_way.r){
            pot[3]=1
            //return 45
          }

          if(r_way.c.z<way3_tun_list[way3_tun_list.len()-1].z){
            local squ = square_x(r_way.c.x, r_way.c.y)
            local z = squ.get_ground_tile().z
            if(z == r_way.c.z) {
              persistent.ch_sub_step = 4  // sub step finish
              //return 43
              break
            }

            local tile = tile_x(r_way.c.x, r_way.c.y, way3_tun_coord[0].z)
            //gui.add_message("t::"+tile.x+","+tile.y+","+tile.z+" sl "+slope)
            for(local j=0;(j+way3_tun_list[0].z)<way3_tun_list[way3_tun_list.len()-1].z;j++){

              if(glsw[j] == 0){

                local slope = tile.get_slope()
                if (slope== dir_1.s /*28*/){
                  way3_tun_list[j].x = tile.x
                  way3_tun_list[j].y = tile.y
                  way3_tun_list[j].z = tile.z
                  glsw[j]=1
                  local c = way3_tun_list[j]
                  if( (j+1)<way3_tun_list.len()){
                    //Se incrementa para ajustar los valores dependiendo del caso
                    way3_tun_list[j+1].x = (tile.x - 1)
                  }
                  break
                }
              }
              tile.z++
            }
          }
        }
        else if (pot[3]==1){
          this.next_step()
        }
        //return 45
        break

      case 9:
        persistent.ch_max_sub_steps = 2
        //Para las vias
        if (pot[0]==0){
          for(local j=0;j<way3_cy1_cy6.len();j++){
            if(glsw[j] == 0){
              local tile_a = my_tile(way3_cy1_cy6[j].a)
              local tile_b = my_tile(way3_cy1_cy6[j].b)

              if (!tile_a.find_object(mo_label))
                label_x.create(way3_cy1_cy6[j].a, pl_unown, translate("Build Rails form here"))

              if (!tile_b.find_object(mo_label))
                label_x.create(way3_cy1_cy6[j].b, pl_unown, translate("Build Rails form here"))

              local coora = coord3d(way3_cy1_cy6[j].a.x, way3_cy1_cy6[j].a.y, way3_cy1_cy6[j].a.z)
              local coorb = coord3d(way3_cy1_cy6[j].b.x, way3_cy1_cy6[j].b.y, way3_cy1_cy6[j].b.z)
              local obj = false
              local dir = get_dir_start(coora)
              r_way = get_fullway(coora, coorb, dir, obj)
              if (r_way.r){
                tile_a.remove_object(player_x(1), mo_label)
                tile_b.remove_object(player_x(1), mo_label)
                glsw[j]=1
                if(j == way3_cy1_cy6.len()-1){
                  pot[0] = 1
                  reset_glsw()
                  r_way.c = 0
                  break
                }
              }
              break
            }
          }
        }
        //Para las señales de paso
        else if (pot[0]==1 && pot[1]==0){
          persistent.ch_sub_step = 1  // sub step finish
          local sign_nr = 0
          for(local j=0;j<way3_sign_list.len();j++){
            local t = tile_x(way3_sign_list[j].c.x, way3_sign_list[j].c.y, way3_sign_list[j].c.z)
            if(sigcoord){
              t.find_object(mo_way).mark()
            }
            if ((!t.find_object(mo_signal) && !t.find_object(mo_roadsign) )){
              label_x.create(way3_sign_list[j].c, pl_unown, translate("Place Singnal here!."))
              t.find_object(mo_way).mark()
            }
            else{
              local ribi = way_x(way3_sign_list[j].c.x, way3_sign_list[j].c.y, way3_sign_list[j].c.z).get_dirs_masked()
              t.remove_object(player_x(1), mo_label)
              if (ribi == way3_sign_list[j].ribi){
                t.find_object(mo_way).unmark()
                sign_nr++
                glsw[j] = 1
                if (sign_nr == way3_sign_list.len()){
                  this.next_step()
                }
              }
            }
          }
        }
        //return 50
        break

      case 10:
        persistent.ch_max_sub_steps = 4
        if (!correct_cov)
          return 0

        if (pot[0]==0){
          for(local j=0;j<way3_cate_list1.len();j++){
            if(glsw[j] == 0){
              local coora = coord3d(way3_cate_list1[j].a.x, way3_cate_list1[j].a.y, way3_cate_list1[j].a.z)
              local coorb = coord3d(way3_cate_list1[j].b.x, way3_cate_list1[j].b.y, way3_cate_list1[j].b.z)
              local elect = mo_wayobj
              local dir = way3_cate_list1[j].dir
              local tunn = way3_cate_list1[j].tunn

              r_way = get_fullway(coora, coorb, dir, elect, tunn)
              if (r_way.r){
                glsw[j]=1
                if(j == way3_cate_list1.len()-1){
                  pot[0] = 1
                  reset_glsw()
                  break
                }
              }
              break
            }
          }
        }
        if (pot[0]==1 && pot[1]==0){
          persistent.ch_sub_step = 1  // sub step finish
          local tile = my_tile(ch3_rail_depot3.b)
          local way = tile.find_object(mo_way)
          if (way.is_electrified()){
            tile.remove_object(player_x(1), mo_label)
            way.unmark()
            pot[1]= 1
          }
          else{
            label_x.create(ch3_rail_depot3.b, pl_unown, translate("Here"))
            way.mark()
          }
        }
        if (pot[1]==1 && pot[2]==0){
          persistent.ch_sub_step = 2  // sub step finish
          local tile = my_tile(ch3_rail_depot3.b)
          if (!tile.find_object(mo_depot_rail))
            label_x.create(ch3_rail_depot3.b, pl_unown, translate("Build Train Depot here!."))
          else{
            tile.remove_object(player_x(1), mo_label)
            pot[2]=1
          }
        }
        if (pot[2]==1 && pot[3]==0){
          this.next_step()
        }
        //return 97
        break

      case 11:
        local c_dep = this.my_tile(ch3_rail_depot3.b)
        set_convoy_schedule(pl, c_dep, gl_wt, line3_name)

        if (current_cov == ch3_cov_lim3.b){
          this.next_step()
          reset_stop_flag()
          //return 90
        }
        //return 90
        break

      case 12:
          //gui.add_message("12!!!!!"+step+"")
        //this.step=1
        persistent.step = 1
        persistent.status.step = 1
        reset_stop_flag()
        //return 100
        break
    }
    local percentage = chapter_percentage(persistent.ch_max_steps, chapter_step, persistent.ch_max_sub_steps, persistent.ch_sub_step)
    return percentage
  }

  function is_work_allowed_here(pl, tool_id, name, pos, tool) {
    gl_tool = tool_id
    //glpos = coord3d(pos.x, pos.y, pos.z)
    //local t = tile_x(pos.x, pos.y, pos.z)
    local label = tile_x(pos.x, pos.y, pos.z).find_object(mo_label)
    //local ribi = 0
    local wt = 0
    //local slope = t.get_slope()
    //local way = t.find_object(mo_way)
    //local bridge = t.find_object(mo_bridge)
    //local building = t.find_object(mo_building)
    //local sign = t.find_object(mo_signal)
    //local roadsign = t.find_object(mo_roadsign)
    /*if (way){
      wt = way.get_waytype()
      if (tool_id!=tool_build_bridge)
        ribi = way.get_dirs()
      if (!t.has_way(wt_rail))
        ribi = 0
    }

    local s_step = []
    if ( s_step.find(this.step) ) {

    }*/

    local fac_1 =  factory_data.rawget("1")
    local fac_2 =  factory_data.rawget("2")
    local fac_3 =  factory_data.rawget("3")

    local result = get_message(2) //translate("Action not allowed")    // null is equivalent to 'allowed'

    switch (this.step) {
      case 1:
        if ( tool_id == 4096 ) {
          if ( pot[0] == 0 ) {
            if ( search_tile_in_tiles(fac_2.c_list, pos) ) {
              pot[0] = 1
              return null
            }
          }
          else if ( pot[1] == 1 ) {
            if ( search_tile_in_tiles(fac_1.c_list, pos) ) {
              pot[2] = 1
              return null
            }
          }
        }
        else
          return get_tile_message(9, pos) //translate("You must use the inspection tool")+" ("+pos.tostring()+")."
        break;
      //Conectando los rieles con la segunda fabrica
      case 2:
        if ( tool_id == 4096 ) return null

        //Primer tramo de rieles
        if ( pot[0] == 0 ) {
          local lab_t = my_tile(way2_fac1_fac2[1])
          local lab = lab_t.find_object(mo_label)
          if ( pos.x < lab_t.x && lab && lab.get_owner().nr == 0 ) {
            if ( tool_id == tool_build_way )
              return ""
          }
          if ( pos.x >= way2_fac1_fac2[1].x && pos.y >= way2_fac1_fac2[1].y && pos.x <= way2_fac1_fac2[0].x && pos.y <= way2_fac1_fac2[0].y ) {
            if( tool_id==tool_build_way || tool_id==tool_remove_way || tool_id==tool_remover ) {
              /*local way_desc =  way_desc_x.get_available_ways(gl_wt, gl_st)
              foreach ( desc in way_desc ) {
                if( desc.get_name() == name ) {
                  return null
                }
              }*/
              // check selected way
              local s = check_select_way(name, gl_wt)
              if ( s != null ) { return s } else { return null }
            }
          }
          if (pos.x>=limit_ch3_rail_line_1a.a.x && pos.y>=limit_ch3_rail_line_1a.a.y && pos.x<=limit_ch3_rail_line_1a.b.x && pos.y<=limit_ch3_rail_line_1a.b.y){
            if ( label && label.get_text() == "X" ) {
              return get_tile_message(5, pos) //translate("Indicates the limits for using construction tools")+" ( "+coord3d_to_string(pos)+")."
            }
            return all_control(result, gl_wt, gl_st, tool_id, pos, r_way.c, name)
          }
          else if(tool_id==tool_build_way)
            return get_tile_message(11, r_way.c) //translate("Connect the Track here")+" ("+coord3d_to_string(r_way.c)+")."
        }
        //Construye un puente
        if (pot[0]==1 && pot[1]==0){
          if (pos.x>=bridge2_coords.b.x-1 && pos.y>=bridge2_coords.b.y-1 && pos.x<=bridge2_coords.a.x+1 && pos.y<=bridge2_coords.a.y+1){
            if(tool_id==tool_build_way || tool_id==tool_build_bridge)
              return null
          }
          else
            return translate("You must build the bridge here")+" ("+coord3d_to_string(bridge2_coords.a)+")."
        }
        //Segundo tramo de rieles
        if (pot[1]==1&&pot[2]==0){
          if (pos.x>=way2_fac1_fac2[5].x && pos.y>=way2_fac1_fac2[5].y && pos.x<=way2_fac1_fac2[4].x && pos.y<=way2_fac1_fac2[4].y){
            if(tool_id==tool_build_bridge)
              return result
            return all_control(result, gl_wt, gl_st, tool_id, pos, r_way.c, name)
          }
          if (pos.x>=limit_ch3_rail_line_1b.a.x && pos.y>=limit_ch3_rail_line_1b.a.y && pos.x<=limit_ch3_rail_line_1b.b.x && pos.y<=limit_ch3_rail_line_1b.b.y){
            if ( label && label.get_text() == "X" ) {
              return get_tile_message(5, pos) //translate("Indicates the limits for using construction tools")+" ("+coord3d_to_string(pos)+")."
            }
            return all_control(result, gl_wt, gl_st, tool_id, pos, r_way.c, name)
          }
          else if(tool_id==tool_build_way)
            return get_tile_message(11, r_way.c) //translate("Connect the Track here")+" ("+coord3d_to_string(r_way.c)+")."
        }
        break;

      case 3:
        if (pot[0]==0){
          //Estaciones de la Fabrica
          // check selected halt accept goods
          local s = check_select_station(name, wt_rail, good_alias.goods)
          if ( s != null ) return s

          local c_list = station_tiles(way2_fac1_fac2[5], way2_fac1_fac2[4], loc1_tile)
          return get_stations(pos, tool_id, result, good_alias.goods, c_list)
        }

        else if (pot[0]==1 && pot[1]==0){
          //Estaciones del Productor
          // check selected halt accept goods
          local s = check_select_station(name, wt_rail, good_alias.goods)
          if ( s != null ) return s

          local c_list = station_tiles(way2_fac1_fac2[0], way2_fac1_fac2[1], loc1_tile)
          return get_stations(pos, tool_id, result, good_alias.goods, c_list)
        }
        break
      case 4:
        if(pot[0]==0){
          if (pos.x>=ch3_rail_depot1.a.x && pos.y>=ch3_rail_depot1.a.y && pos.x<=ch3_rail_depot1.b.x && pos.y<=ch3_rail_depot1.b.y){
            if (tool_id==tool_build_way)
              return null
          }
          else return translate("You must build track in")+" ("+ch3_rail_depot1.b.tostring()+")."
        }
        else if(pot[0]==1 && pot[1]==0){
          if ((pos.x==ch3_rail_depot1.b.x)&&(pos.y==ch3_rail_depot1.b.y)){
            if (tool_id==tool_build_depot)
              return null
          }
          else return get_tile_message(12, ch3_rail_depot1.b) //translate("You must build the train depot in")+" ("+ch3_rail_depot1.b.tostring()+")."
        }
        else if (pot[1]==1 && pot[2]==0){
          if ((pos.x==ch3_rail_depot1.b.x)&&(pos.y==ch3_rail_depot1.b.y)){
            if (tool_id==4096){
              pot[2]=1
              return null
            }
            else return get_tile_message(9, ch3_rail_depot1.b) //translate("You must use the inspection tool")+" ("+ch3_rail_depot1.b.tostring()+")."
          }
        }
        break
      case 5:
        //Enrutar vehiculos (estacion nr1)
        local t = tile_x(pos.x, pos.y, pos.z)
        local building = t.find_object(mo_building)
        local st_check = check_rail_station(my_tile(way2_fac1_fac2[0]), 0, pos)
        if (building && st_check){
        //if (building && pos.x>=way2_fac1_fac2[1].x && pos.y>=way2_fac1_fac2[1].y && pos.x<=way2_fac1_fac2[0].x && pos.y<=way2_fac1_fac2[0].y){
          if (tool_id==4108){
            if (stop_flag[0]==0){
              stop_flag[0] = 1
              return null
            }
            else
              return translate("Select the other station")+" ("+coord(way2_fac1_fac2[5].x, way2_fac1_fac2[5].y).tostring()+".)"
          }
        }
        else if (tool_id==4108){
          if (stop_flag[0]==0)
            return format(translate("Select station No.%d"),1)+" ("+coord(way2_fac1_fac2[0].x, way2_fac1_fac2[0].y).tostring()+".)"
        }
        //Enrutar vehiculos (estacion nr2)
        local st_check = check_rail_station(my_tile(way2_fac1_fac2[way2_fac1_fac2.len()-1]), 0, pos)
        if (building && st_check){
        //if (building && pos.x>=way2_fac1_fac2[way2_fac1_fac2.len()-1].x && pos.y>=way2_fac1_fac2[way2_fac1_fac2.len()-1].y && pos.x<=way2_fac1_fac2[way2_fac1_fac2.len()-2].x && pos.y<=way2_fac1_fac2[way2_fac1_fac2.len()-2].y){
          if (tool_id==4108){
            if (stop_flag[0]==1 && stop_flag[1]==0){
              stop_flag[1] = 1
              return null
            }
            if (stop_flag[0]==0)
              return translate("Select the other station first")+" ("+coord(way2_fac1_fac2[0].x, way2_fac1_fac2[0].y).tostring()+".)"
            else if (stop_flag[0]==1 && stop_flag[1]==1)
              return get_tile_message(3, ch3_rail_depot1.a) //translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+ch3_rail_depot1.a.tostring()+".)"
          }
        }
        else if (tool_id==4108){
          if (stop_flag[0]==0)
            return translate("Select the other station first")+" ("+coord(way2_fac1_fac2[0].x, way2_fac1_fac2[0].y).tostring()+".)"

          else if (stop_flag[0]==1 && stop_flag[1]==0)
            return format(translate("Select station No.%d"),2)+" ("+coord(way2_fac1_fac2[5].x, way2_fac1_fac2[5].y).tostring()+".)"

          else if (stop_flag[0]==1 && stop_flag[1]==1)
            return get_tile_message(3, ch3_rail_depot1.a) //translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+ch3_rail_depot1.a.tostring()+".)"
        }
        break

      //Conectando los rieles con el consumidor final
      case 6:
        //Primer tramo de rieles
        if (pot[0]==0){
          local lab_t = my_tile(way2_fac2_fac3[1])
          local lab = lab_t.find_object(mo_label)
          if(pos.y > lab_t.y && lab && lab.get_owner().nr == 0){
            if(tool_id==tool_build_way)
              return ""
          }
          if (pos.x>=way2_fac2_fac3[0].x && pos.y>=way2_fac2_fac3[0].y && pos.x<=way2_fac2_fac3[1].x && pos.y<=way2_fac2_fac3[1].y){
            if(tool_id==tool_build_way || tool_id==tool_remove_way || tool_id==tool_remover){
              /*local way_desc =  way_desc_x.get_available_ways(gl_wt, gl_st)
              foreach(desc in way_desc){
                if(desc.get_name() == name){
                  return null
                }
              }*/
              // check selected way
              local s = check_select_way(name, gl_wt)
              if ( s != null ) { return s } else { return null }
            }
          }
          if (pos.x>=limit_ch3_rail_line_2a.a.x && pos.y>=limit_ch3_rail_line_2a.a.y && pos.x<=limit_ch3_rail_line_2a.b.x && pos.y<=limit_ch3_rail_line_2a.b.y){
            if (label && label.get_text()=="X"){
              return get_tile_message(5, pos) //translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."
            }
            return all_control(result, gl_wt, gl_st, tool_id, pos, r_way.c, name)
          }
          else if(tool_id==tool_build_way)
            return get_tile_message(11, r_way.c) //translate("Connect the Track here")+" ("+r_way.c.tostring()+")."
        }
        //Construye un tunel
        else if (pot[0]==1 && pot[1]==0){
          if (pos.x>=way2_fac2_fac3[2].x && pos.y>=way2_fac2_fac3[2].y && pos.x<=way2_fac2_fac3[3].x && pos.y<=way2_fac2_fac3[3].y){
            if(tool_id==tool_build_way || tool_id==tool_build_tunnel){
              return null
            }
          }
        }

        //Segundo tramo de rieles
        if (pot[1]==1&&pot[2]==0){
          if (pos.x>=way2_fac2_fac3[4].x && pos.y>=way2_fac2_fac3[4].y && pos.x<=way2_fac2_fac3[5].x && pos.y<=way2_fac2_fac3[5].y){
            if(tool_id==tool_build_bridge)
              return result
            return all_control(result, gl_wt, gl_st, tool_id, pos, r_way.c, name)
          }
          if (pos.x>=limit_ch3_rail_line_2b.a.x && pos.y>=limit_ch3_rail_line_2b.a.y && pos.x<=limit_ch3_rail_line_2b.b.x && pos.y<=limit_ch3_rail_line_2b.b.y){
            if ( label && label.get_text()=="X"){
              return get_tile_message(5, pos) //translate("Indicates the limits for using construction tools")+" ("+coord3d_to_string(pos)+")."
            }
            return all_control(result, gl_wt, gl_st, tool_id, pos, r_way.c, name)
          }

          else if(tool_id==tool_build_way)
            return get_tile_message(11, r_way.c) //translate("Connect the Track here")+" ("+coord3d_to_string(r_way.c)+")."
        }
        //Estaciones de la Fabrica
        else if (pot[2]==1 && pot[3]==0){
          // check selected halt accept goods
          local s = check_select_station(name, wt_rail, good_alias.goods)
          if ( s != null ) return s

          local c_list = station_tiles(way2_fac2_fac3[5], way2_fac2_fac3[4], loc2_tile)
          return get_stations(pos, tool_id, result, good_alias.goods, c_list)
        }
        //Estaciones del Productor
        else if (pot[3]==1 && pot[4]==0){
          // check selected halt accept goods
          local s = check_select_station(name, wt_rail, good_alias.goods)
          if ( s != null ) return s

          local c_list = station_tiles(way2_fac2_fac3[0], way2_fac2_fac3[1], loc2_tile)
          return get_stations(pos, tool_id, result, good_alias.goods, c_list)
        }
        break
      case 7:
        if (tool_id==4096)
          break

        //Construye rieles y deposito
        if (pos.x>=ch3_rail_depot2.a.x && pos.y>=ch3_rail_depot2.a.y && pos.x<=ch3_rail_depot2.b.x && pos.y<=ch3_rail_depot2.b.y){
          if (pot[0]==0){
            if(tool_id==tool_build_way)
              return null
            else
              return translate("You must build track in")+" ("+coord3d_to_string(ch3_rail_depot2.a)+")."
          }
          else if (pot[0]==1 && pot[1]==0)
            if(tool_id==tool_build_depot)
              return null
            else
              return get_tile_message(12, ch3_rail_depot2.a) //translate("You must build the train depot in")+" ("+ch3_rail_depot2.a.tostring()+")."
        }
        else if (pot[0]==0)
          return translate("You must build track in")+" ("+ch3_rail_depot2.a.tostring()+")."
        else if (pot[0]==1 && pot[1]==0)
          return result = get_tile_message(12, ch3_rail_depot2.a) //translate("You must build the train depot in")+" ("+ch3_rail_depot2.a.tostring()+")."

        local t = tile_x(pos.x, pos.y, pos.z)
        local building = t.find_object(mo_building)

        //Enrutar vehiculos (estacion nr1)
        if (pot[1]==1 && pot[2]==0){
          if (building && pos.x>=way2_fac2_fac3[0].x && pos.y>=way2_fac2_fac3[0].y && pos.x<=way2_fac2_fac3[1].x && pos.y<=way2_fac2_fac3[1].y){
            if (tool_id==4108 && building){
              if (stop_flag[0]==0){
                stop_flag[0] = 1
                return null
              }
              else
                return translate("Select the other station")+" ("+coord(way2_fac2_fac3[5].x, way2_fac2_fac3[5].y).tostring()+".)"
            }
          }
          else if (tool_id==4108){
            if (stop_flag[0]==0)
              return format(translate("Select station No.%d"),1)+" ("+coord(way2_fac2_fac3[0].x, way2_fac2_fac3[0].y).tostring()+".)"
          }
          //Enrutar vehiculos (estacion nr2)
          if (building && pos.x>=way2_fac2_fac3[4].x && pos.y>=way2_fac2_fac3[4].y && pos.x<=way2_fac2_fac3[5].x && pos.y<=way2_fac2_fac3[5].y){
            if (tool_id==4108 && building){
              if (stop_flag[0]==1 && stop_flag[1]==0){
                stop_flag[1] = 1
                return null
              }
              if (stop_flag[0]==0)
                return translate("Select the other station first")+" ("+coord(way2_fac2_fac3[0].x, way2_fac2_fac3[0].y).tostring()+".)"
              else if (stop_flag[0]==1 && stop_flag[1]==1)
                return get_tile_message(3, ch3_rail_depot1.a) //translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+ch3_rail_depot1.a.tostring()+".)"
            }
          }
          else if (tool_id==4108){
            if (stop_flag[0]==0)
              return translate("Select the other station first")+" ("+coord(way2_fac2_fac3[0].x, way2_fac2_fac3[0].y).tostring()+".)"

            else if (stop_flag[0]==1 && stop_flag[1]==0)
              return format(translate("Select station No.%d"),2)+" ("+coord(way2_fac2_fac3[5].x, way2_fac2_fac3[5].y).tostring()+".)"

            else if (stop_flag[0]==1 && stop_flag[1]==1)
              return get_tile_message(3, ch3_rail_depot1.a) //translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+ch3_rail_depot1.a.tostring()+".)"
          }
        }
        if (pot[2]==1 && pot[3]==0){
          return get_tile_message(3, ch3_rail_depot1.a) //translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+ch3_rail_depot1.a.tostring()+".)"
        }
        break

      case 8:
        local t = tile_x(pos.x, pos.y, pos.z)
        local slope = t.get_slope()
        local way = t.find_object(mo_way)
        //Construye tramo de via para el tunel
        if (pot[0]==0){
          if (pos.x>=c_way3_lim.a.x && pos.y<=c_way3_lim.a.y && pos.x<=c_way3_lim.b.x && pos.y>=c_way3_lim.b.y){
            if (tool_id==tool_build_way || tool_id == tool_build_bridge || tool_id == tool_build_tunnel){
              return all_control(result, gl_wt, gl_st, tool_id, pos, r_way.c, name)
            }
          }
          else return  get_tile_message(11, r_way.c) //translate("Connect the Track here")+" ("+coord3d_to_string(r_way.c)+")."
        }
        //Construye un puente
        else if (pot[0]==1 && pot[1]==0){
          if (pos.x>=c_bridge3_limit.a.x && pos.y>=c_bridge3_limit.a.y && pos.x<=c_bridge3_limit.b.x && pos.y<=c_bridge3_limit.b.y){
            if(tool_id==tool_build_way || tool_id==tool_build_bridge){
              return null
            }
          }
          else
            return translate("You must build the bridge here")+" ("+bridge3_coords.a.tostring()+")."
        }
        //Construye Entrada del tunel
        else if (pot[1]==1 && pot[2]==0){
          if (tool_id==tool_build_way){
            if(t.find_object(mo_bridge))
              return null
          }
          if (tool_id==tool_build_tunnel){
            //if (pos.x==c_tun_lock.x && pos.y==c_tun_lock.y)
              //return translate("Press [Ctrl] to build a tunnel entrance here")+" ("+start_tunn.tostring()+".)"

            if (pos.x == way3_tun_coord[0].x && pos.y == way3_tun_coord[0].y)
              return null

            if (pos.x == way3_tun_coord[1].x && pos.y == way3_tun_coord[1].y)
              return null
          }
        }
        //Conecta los dos extremos del tunel
        else if (pot[2]==1 && pot[3]==0){
          if (r_way.c==0) return ""
          local squ_bor = square_x(r_way.c.x, r_way.c.y)
          local z_bor = squ_bor.get_ground_tile().z
          local slp_way = tile_x(r_way.c.x, r_way.c.y, r_way.c.z).get_slope()
          local plus = r_way.p//slp_way==dir_1.s && z_bor!=r_way.c.z?1:0 //compensacion de altura en pendientes
          local res = underground_message(plus)

          if(res != null)
            return res

          local max = 1
          local count_tunn = count_tunnel(pos, max)
          if (tool_id==tool_remover){
            if (pos.x>=c_way3_tun_limit.a.x && pos.y<=c_way3_tun_limit.a.y && pos.x<=c_way3_tun_limit.b.x && pos.y>=c_way3_tun_limit.b.y){
              //El Tunel ya tiene la altura correcta
              if (r_way.c.z+plus == way3_tun_coord[2].z) {
                return all_control(result, gl_wt, gl_st, tool_id, pos, r_way.c, name, plus)
              }
              if(!count_tunn && slope==0 && way && way.is_marked())
                return null
              if(count_tunn && pos.z!=way3_tun_list[way3_tun_list.len()-1].z) return translate("You must use the tool to raise the ground here")+" ("+r_way.c.tostring()+".)"
            }
          }

          if (tool_id==tool_build_tunnel || tool_id==tool_build_way || tool_id== 4099){
            if (pos.x>=c_way3_tun_limit.a.x && pos.y<=c_way3_tun_limit.a.y && pos.x<=c_way3_tun_limit.b.x && pos.y>=c_way3_tun_limit.b.y){
              //El Tunel ya tiene la altura correcta
              if (r_way.c.z+plus == way3_tun_coord[2].z) {
                //gui.add_message("Z: "+r_way.c.z+plus)
                return all_control(result, gl_wt, gl_st, tool_id, pos, r_way.c, name, plus)
              }
              local dir = dir_1.r
              local t_r_way = my_tile(r_way.c)
              local tunn_r_way = t_r_way.find_object(mo_tunnel)
              if(tunn_r_way){
                //Se comprueba el primer tramo despues de la entrada del tunel----------------------------------
                local under = way3_tun_coord[0].z
                result = under_way_check(under, dir)
                if(result != null){
                  return result
                }
                local start = way3_tun_coord[0]
                local max = 3
                local new_max = tunnel_get_max(start, pos, max, dir)
                if(new_max < max){
                  result = tunnel_build_check(start, pos, under,  max, dir)
                  if(result == null){
                    return all_control(result, gl_wt, gl_st, tool_id, pos, r_way.c, name, plus)
                  }
                }
                else{
                  return ""
                }
               //--------------------------------------------------------------------------------------------------
              }
              //Entonces se comprueba ahora desde las pendientes
              else{
                local slp_way = tile_x(r_way.c.x, r_way.c.y, r_way.c.z).get_slope()
                //Si es distinto a flat
                if(slp_way != 0){
                  local start = r_way.c
                  local max = 2
                   local new_max = tunnel_get_max(start, pos, max, dir)
                  //return new_max
                  if(new_max < max){
                    return all_control(result, gl_wt, gl_st, tool_id, pos, r_way.c, name, plus)
                  }
                }
                else{
                  return translate("You must upper the ground first")+" ("+r_way.c.tostring()+".)"
                }
              }
            }
            else return translate("Build a tunnel here")+" ("+r_way.c.tostring()+")."
          }
          //Tunel Con pendientes ---------------------------------------------------------------------------------------
          if (tool_id == tool_setslope){
            if (pos.x>=c_way3_tun_limit.a.x && pos.y<=c_way3_tun_limit.a.y && pos.x<=c_way3_tun_limit.b.x && pos.y>=c_way3_tun_limit.b.y){
              local slp_way = tile_x(r_way.c.x, r_way.c.y, r_way.c.z).get_slope()
              local end_z = way3_tun_coord[2].z
              if (slp_way == dir_1.s)
                return translate("The slope is ready.")
              else if (pos.z < end_z){
                local dir = dir_1.r
                local under = end_z
                result = under_way_check(under, dir)
                if(result == null){
                  if(name == t_name.up){
                    return null
                  }
                  else if(name == t_name.down){
                    return get_message(2) //translate("Action not allowed")
                  }
                  return translate("Only up and down movement in the underground!")
                }
                return result
              }
              if (pos.z == end_z)
                return translate("The tunnel is already at the correct level")+" ("+end_z+")."
            }
            else{
              return get_message(2) //translate("Action not allowed")
            }
            if(slope==0) return translate("Modify the terrain here")+" ("+r_way.c.tostring()+")."
          }
          //--------------------------------------------------------------------------------------------------------------------------
        }
        break
      case 9:
        local t = tile_x(pos.x, pos.y, pos.z)
        local sign = t.find_object(mo_signal)
        local roadsign = t.find_object(mo_roadsign)

        if (pot[0]==0){
          result = r_way.c != 0? get_tile_message(11, r_way.c) /*translate("Connect the Track here")+" ("+coord3d_to_string(r_way.c)+")."*/ : result
          for(local j=0;j<way3_cy1_cy6.len();j++){
            if(glsw[j] == 0){
              local limit_t = []
              if ( way3_cy1_cy6[j].a.x > way3_cy1_cy6[j].b.x || way3_cy1_cy6[j].a.y > way3_cy1_cy6[j].b.y ) {
                limit_t.append(way3_cy1_cy6[j].b)
                limit_t.append(way3_cy1_cy6[j].a)
              } else {
                limit_t.append(way3_cy1_cy6[j].a)
                limit_t.append(way3_cy1_cy6[j].b)
              }

              if(pos.x>=limit_t[0].x && pos.y>=limit_t[0].y && pos.x<=limit_t[1].x && pos.y<=limit_t[1].y) {

                if(tool_id == tool_build_way){
                   return null
                }
              }
              else if (j == way3_cy1_cy6.len()-1){
                result = get_tile_message(13, pos) //translate("You are outside the allowed limits!")+" ("+pos.tostring()+")."
              }
              break
            }
          }
          return result
        }
        if (pot[0]==1 && pot[1]==0){
          //Elimina las señales
          if (tool_id==tool_remover){
            if (sign || roadsign){
              for(local j=0;j<way3_sign_list.len();j++){
                if (pos.x == way3_sign_list[j].c.x && pos.y==way3_sign_list[j].c.y){
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
              for(local j=0;j<way3_sign_list.len();j++){
                local tile = tile_x(way3_sign_list[j].c.x, way3_sign_list[j].c.y, way3_sign_list[j].c.z)
                local r
                if (tile.find_object(mo_signal)){
                  r = get_signa(tile, j, way3_sign_list[j].ribi)
                  if (r == null)
                    return translate("The signal does not point in the correct direction")+" ("+way3_sign_list[j].c.tostring()+")."
                }
                else
                  result = translate("Place a block signal here")+" ("+way3_sign_list[j].c.tostring()+")."

                if (tile.find_object(mo_roadsign))
                  return translate("It must be a block signal!")+" ("+way3_sign_list[j].c.tostring()+")."
              }
            }
            for(local j=0;j<way3_sign_list.len();j++){
              local tile = tile_x(way3_sign_list[j].c.x, way3_sign_list[j].c.y, way3_sign_list[j].c.z)
              if (tile.find_object(mo_roadsign))
                return translate("It must be a block signal!")+" ("+way3_sign_list[j].c.tostring()+")."
              if ((pos.x == way3_sign_list[j].c.x) && (pos.y == way3_sign_list[j].c.y)){
                return get_signa(t, j, way3_sign_list[j].ribi)
              }
            }
            return result
          }
        }
        break
      case 10:
                //return square_x(pos.x, pos.y).get_climate()

        if (pot[0]==0){
          for(local j=0;j<way3_cate_list1.len();j++){
            local limit_t = []
            if ( way3_cate_list1[j].a.x > way3_cate_list1[j].b.x || way3_cate_list1[j].a.y > way3_cate_list1[j].b.y ) {
              limit_t.append(way3_cate_list1[j].b)
              limit_t.append(way3_cate_list1[j].a)
            } else {
              limit_t.append(way3_cate_list1[j].a)
              limit_t.append(way3_cate_list1[j].b)
            }

            if(pos.x>=limit_t[0].x && pos.y>=limit_t[0].y && pos.x<=limit_t[1].x && pos.y<=limit_t[1].y) {
              if(tool_id == 4114){
                return null
              }
            }
            else if (j== way3_cate_list1.len()-1){
              result = get_tile_message(11, r_way.c) //translate("Connect the Track here")+" ("+r_way.c.tostring()+")."
            }
          }
          if ((tool_id == 4114)&&(pos.x==ch3_rail_depot3.b.x)&&(pos.y==ch3_rail_depot3.b.y)) return null
        }
        else if (pot[0]==1 && pot[1]==0){
          local limit_t = []
          if ( ch3_rail_depot3.a.x > ch3_rail_depot3.b.x || ch3_rail_depot3.a.y > ch3_rail_depot3.b.y ) {
            limit_t.append(ch3_rail_depot3.b)
            limit_t.append(ch3_rail_depot3.a)
          } else {
            limit_t.append(ch3_rail_depot3.a)
            limit_t.append(ch3_rail_depot3.b)
          }

          if(pos.x>=limit_t[0].x && pos.y>=limit_t[0].y && pos.x<=limit_t[1].x && pos.y<=limit_t[1].y) {
            if (tool_id==4114){
              return null
            }

          }
          result = get_tile_message(11, r_way.c) //translate("Connect the Track here")+" ("+ch3_rail_depot3.a.tostring()+")."
        }
        else if (pot[1]==1 && pot[2]==0){
          if ((pos.x==ch3_rail_depot3.b.x)&&(pos.y==ch3_rail_depot3.b.y)){
            if (tool_id==tool_build_depot){
              return null
            }
          }
          result = get_tile_message(12, ch3_rail_depot3.b) //translate("You must build the train depot in")+" ("+ch3_rail_depot3.b.tostring()+")."
        }
        break

      case 11:

        if (tool_id==4108){
          //gui.add_message(""+st_lim_a.len()+"")

          for ( local j = 0; j < ch3_rail_stations.len(); j++ ) {
            result = format(translate("Select station No.%d"),j+1)+" ("+ch3_rail_stations[j].tostring()+".)"
            if(tmpsw[j]==0){
              local check = check_rail_station(ch3_rail_stations[j], 0, pos)
              if( check ){
                return is_stop_allowed_ex(ch3_rail_depot3.b, ch3_rail_stations, pos, gl_wt)
              }
              else
                return result
            }
            if ((j+1) == ch3_rail_stations.len())
              return get_tile_message(3, ch3_rail_depot3.b) //translate("The route is complete, now you may dispatch the vehicle from the depot")+" ("+ch3_rail_depot3.b.tostring()+")."
          }
          return result
        }

        break
    }
    if (tool_id == 4096){
      if (label && label.get_text()=="X")
        return get_tile_message(5, pos) //translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."
      else if (label)
        return translate("Text label")+" ("+pos.tostring()+")."
      result = null // Always allow query tool
    }
    if (label && label.get_text()=="X")
      return get_tile_message(5, pos) //translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."

    return result
  }

  function is_schedule_allowed(pl, schedule) {
    local result=null // null is equivalent to 'allowed'
    local fac_1 =  factory_data.rawget("1")
    local fac_2 =  factory_data.rawget("2")
    local fac_3 =  factory_data.rawget("3")

    switch (this.step) {
      case 5:
        local selc = 0
        local load = loc1_load
        local time = loc1_wait
        local c_list = [way2_fac1_fac2[0], way2_fac1_fac2[5]]
        result =  compare_schedule(result, pl, schedule, selc, load, time, c_list, false)
        if(result != null)
          reset_stop_flag()
        return result
      break

      case 7:
        local selc = 0
        local load = loc2_load
        local time = loc2_wait
        local c_list = [way2_fac2_fac3[0], way2_fac2_fac3[way2_fac2_fac3.len()-1]]
        result =  compare_schedule(result, pl, schedule, selc, load, time, c_list, false)
        if(result != null)
          reset_stop_flag()
        return result
      break

      case 11:
        local selc = get_waiting_halt(4)
        local load = loc3_load
        local time = loc3_wait
        local c_list = ch3_rail_stations
        result =  compare_schedule(result, pl, schedule, selc, load, time, c_list, true)
        if(result == null){
          local line_name = line3_name
          update_convoy_schedule(pl, gl_wt, line_name, schedule)
        }
        return result
      break
    }
    return get_message(2) //translate("Action not allowed")
  }

  function is_convoy_allowed(pl, convoy, depot)
  {
    local result = get_message(3) //translate("It is not allowed to start vehicles.")
    switch (this.step) {
      case 5:
        local wt = gl_wt
        if ((depot.x != ch3_rail_depot1.b.x)||(depot.y != ch3_rail_depot1.b.y))
          return get_tile_message(10, depot) //"Depot coordinate is incorrect (" + coord3d_to_string(depot) + ")."
        local cov = 1
        local veh = set_train_lenght(1) + 1
        local good_list = [good_desc_x(good_alias.wood).get_catg_index()] //Wood
        local name = loc1_name_obj
        local st_tile = loc1_tile // 3
        local is_st_tile = true
        result = is_convoy_correct(depot, cov, veh, good_list, name, st_tile, is_st_tile)
        //gui.add_message("is_convoy_allowed result " + result)

        if (result!=null){
          backward_pot(0)
          local good = translate_objects_list.good_wood
          return train_result_message(result, translate(name), good, veh, cov, st_tile)
        }

        //gui.add_message("is_convoy_allowed current_cov " + current_cov)
        //gui.add_message("is_convoy_allowed ch3_cov_lim1.a " + ch3_cov_lim1.a)
        //gui.add_message("is_convoy_allowed ch3_cov_lim1.b " + ch3_cov_lim1.b)
        if (current_cov>ch3_cov_lim1.a && current_cov<ch3_cov_lim1.b){
          local selc = 0
          local load = loc1_load
          local time = loc1_wait
          local c_list = [way2_fac1_fac2[0], way2_fac1_fac2[5]]
          local siz = c_list.len()

          local check_schedule = compare_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
          //gui.add_message("is_convoy_allowed check_schedule " + check_schedule)

          return check_schedule
        }
      break

      case 7:
        local wt = gl_wt
        if ((depot.x != ch3_rail_depot2.a.x)||(depot.y != ch3_rail_depot2.a.y))
          return get_tile_message(15, ch3_rail_depot2.a) //translate("You must select the deposit located in")+" ("+ch3_rail_depot2.a.tostring()+")."
        local cov = 1
        local veh = set_train_lenght(2) + 1
        local good_list = [good_desc_x(good_alias.plan).get_catg_index()]
        local name = loc2_name_obj
        local st_tile = loc2_tile // 3
        local is_st_tile = true
        result = is_convoy_correct(depot, cov, veh, good_list, name, st_tile, is_st_tile)

        if (result!=null){
          local good = translate_objects_list.good_plan
          return train_result_message(result, translate(name), good, veh, cov, st_tile)
        }
        if (current_cov>ch3_cov_lim2.a && current_cov<ch3_cov_lim2.b){
          local selc = 0
          local load = loc2_load
          local time = loc2_wait
          local c_list = [way2_fac2_fac3[0], way2_fac2_fac3[5]]
          local siz = c_list.len()
          return compare_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
        }
      break

      case 11:
      if (current_cov>ch3_cov_lim3.a && current_cov<ch3_cov_lim3.b){
        if ((depot.x != ch3_rail_depot3.b.x)||(depot.y != ch3_rail_depot3.b.y))
          return get_tile_message(15, ch3_rail_depot3.b) //translate("You must select the deposit located in")+" ("+ch3_rail_depot3.b.tostring()+")."
        local cov = dep_cnr3
        local veh = set_train_lenght(3) + 1
        local good_list = [good_desc_x (good_alias.passa).get_catg_index()]    //Passengers
        local name = loc3_name_obj
        local st_tile = loc3_tile
        local is_st_tile = true

        //Para arracar varios vehiculos
        local id_start = ch3_cov_lim3.a
        local id_end = ch3_cov_lim3.b
        local c_list = ch3_rail_stations
        local cir_nr = get_convoy_number_exp(c_list[0], depot, id_start, id_end)
        local cov_list = depot.get_convoy_list()
        cov -= cir_nr

        result = is_convoy_correct(depot, cov, veh, good_list, name, st_tile, is_st_tile)
        if (result!=null){
          reset_tmpsw()
          local good = translate(good_alias.passa)
          return train_result_message(result, translate(name), good, veh, cov, st_tile)
        }

        local selc = get_waiting_halt(4)
        local load = loc3_load
        local time = loc3_wait
        local siz = c_list.len()

        result = compare_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
        if(result == null)
          reset_tmpsw()
        return result
      }
      break

    }
    return get_message(3) //translate("It is not allowed to start vehicles.")
  }

  function script_text()
  {
    local way = tile_x(r_way.c.x, r_way.c.y, r_way.c.z).find_object(mo_way)
    if(way) way.unmark()

    local player = player_x(0)
    switch (this.step) {
      case 1:
        if(pot[0]==0){
          pot[0]=1
        }
        if (pot[2]==0){
          pot[2]=1
        }
        return null
        break;
      case 2:
        //Primer tramo de rieles
        if (pot[0]==0){
          //Station tramo ----------------------------------------------------------------------
          local t_start = my_tile(coord(way2_fac1_fac2[0].x, way2_fac1_fac2[0].y))
          local t_end = my_tile(coord(way2_fac1_fac2[1].x, way2_fac1_fac2[1].y))

          t_start.remove_object(player_x(1), mo_label)
          t_end.remove_object(player_x(1), mo_label)

          local t = command_x(tool_build_way)
          local err = t.work(player, t_start, t_end, sc_way_name)

          //Outside tramo ----------------------------------------------------------------------
          t_start = my_tile(coord(way2_fac1_fac2[1].x, way2_fac1_fac2[1].y))
          t_end = my_tile(coord(way2_fac1_fac2[2].x, way2_fac1_fac2[2].y))
          t = command_x(tool_build_way)
          err = t.work(player, t_start, t_end, sc_way_name)

          //elimina el cuadro label
          local opt = 0
          local del = true
          local text = "X"
          label_bord(limit_ch3_rail_line_1a.a, limit_ch3_rail_line_1a.b, opt, del, text)
        }
        //Para el puente
        if (pot[1]==0){
          local t_start = my_tile(bridge2_coords.a)
          local t_end = my_tile(bridge2_coords.b)
          if ( !t_start.find_object(mo_bridge) ) {
            t_start.remove_object(player_x(1), mo_label)
            local t = command_x(tool_build_bridge)
            local err = t.work(player, t_start, t_end, sc_bridge_name)
          }
        }
        //Segundo tramo de rieles
        if (pot[4]==0){
          //Outside tramo ----------------------------------------------------------------------
          local t_start = my_tile(coord(way2_fac1_fac2[3].x, way2_fac1_fac2[3].y))
          local t_end = my_tile(coord(way2_fac1_fac2[4].x, way2_fac1_fac2[4].y))
          local t = command_x(tool_build_way)
          local err = t.work(player, t_start, t_end, sc_way_name)

          //Station tramo ----------------------------------------------------------------------
          t_start = my_tile(way2_fac1_fac2[4])
          t_end = my_tile(way2_fac1_fac2[5])

          t_start.remove_object(player_x(1), mo_label)
          t_end.remove_object(player_x(1), mo_label)

          t = command_x(tool_build_way)
          err = t.work(player, t_start, t_end, sc_way_name)

        }
        return null
        break;
      case 3:

        if (pot[0]==0){
          //Estaciones de la Fabrica
          local st_list = station_tiles(way2_fac1_fac2[5], way2_fac1_fac2[4], loc1_tile)
          for(local j=0;j<st_list.len();j++){
            local tile = my_tile(st_list[j])
            tile.find_object(mo_way).unmark()
            if (tile.get_halt()==null){
              if (tile.find_object(mo_label))
                tile.remove_object(player_x(0), mo_label)
              local tool = command_x(tool_build_station)
              local err = tool.work(player, tile, sc_station_name)
            }
          }
        }

        if (pot[1]==0){
          //Estaciones del Productor
          local st_list = station_tiles(way2_fac1_fac2[0], way2_fac1_fac2[1], loc1_tile)
          for(local j=0;j<st_list.len();j++){
            local tile = my_tile(st_list[j])
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
        if(pot[0]==0){
          local t_start = my_tile(ch3_rail_depot1.a)
          local t_end = my_tile(ch3_rail_depot1.b)
          t_start.unmark()
          t_end.unmark()
          t_start.remove_object(player_x(1), mo_label)
          local t = command_x(tool_build_way)
          local err = t.work(player, t_start, t_end, sc_way_name)
        }

        if(pot[1]==0){
          local t = my_tile(ch3_rail_depot1.b)
          t.remove_object(player_x(1), mo_label)
          local tool = command_x(tool_build_depot)
          tool.work(player, t, sc_dep_name)
        }

        if(pot[1]==1 && pot[2]==0){
          pot[2]=1
        }

        return null
        break
      case 5:
        local wt = wt_rail
        if (current_cov>ch3_cov_lim1.a && current_cov<ch3_cov_lim1.b){
          local c_depot = my_tile(ch3_rail_depot1.b)
          comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito

          local sched = schedule_x(wt, [])
          sched.entries.append(schedule_entry_x(my_tile(way2_fac1_fac2[0]), loc1_load, loc1_wait))
          sched.entries.append(schedule_entry_x(my_tile(way2_fac1_fac2[5]), 0, 0))
          local c_line = comm_get_line(player, gl_wt, sched, line1_name)

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

          pot[1]=1
        }


        return null
        break
      case 6:
        //Primer tramo de rieles
        if (pot[0]==0){

          local t_start = my_tile(way2_fac2_fac3[0])
          local t_end = my_tile(way2_fac2_fac3[1])

          t_start.remove_object(player_x(1), mo_label)
          t_end.remove_object(player_x(1), mo_label)

          local t = command_x(tool_build_way)
          local err = t.work(player, t_start, t_end, sc_way_name)

          t_start = my_tile(way2_fac2_fac3[1])
          t_end = my_tile(coord(way2_fac2_fac3[2].x, way2_fac2_fac3[2].y))
          t = command_x(tool_build_way)
          err = t.work(player, t_start, t_end, sc_way_name)

          //elimina el cuadro label
          local opt = 0
          local del = true
          local text = "X"
          label_bord(limit_ch3_rail_line_2a.a, limit_ch3_rail_line_2a.b, opt, del, text)
        }
        //Para el Tunel
        if (pot[1]==0){
          local t_start = my_tile(way2_fac2_fac3[2])
          // check tile slope ramp ( pak128 )
          if ( t_start.get_slope() == 0 ) {
            if ( way2_fac2_fac3[2].x < way2_fac2_fac3[3].x ) {
              t_start.x += 1
            } else if ( way2_fac2_fac3[2].x > way2_fac2_fac3[3].x ) {
              t_start.x -= 1
            } else if ( way2_fac2_fac3[2].y < way2_fac2_fac3[3].y ) {
              t_start.x += 1
            } else if ( way2_fac2_fac3[2].y > way2_fac2_fac3[3].y ) {
              t_start.x -= 1
            }
          }
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
        if (pot[2]==0){
          //Outside tramo ----------------------------------------------------------------------
          local t_start = my_tile(coord(way2_fac2_fac3[3].x, way2_fac2_fac3[3].y))
          local t_end = my_tile(way2_fac2_fac3[4])
          local t = command_x(tool_build_way)
          local err = t.work(player, t_start, t_end, sc_way_name)

          //Station tramo ----------------------------------------------------------------------
          t_start = my_tile(way2_fac2_fac3[4])
          t_end = my_tile(way2_fac2_fac3[5])

          t_start.remove_object(player_x(1), mo_label)
          t_end.remove_object(player_x(1), mo_label)

          t = command_x(tool_build_way)
          err = t.work(player, t_start, t_end, sc_way_name)
        }
        glresult = null
        local passa = good_alias.passa
        local mail = good_alias.mail
        //Estaciones de la Fabrica
        if (pot[3]==0){
          //Station tramo ----------------------------------------------------------------------
          local st_list = station_tiles(way2_fac2_fac3[5], way2_fac2_fac3[4], loc2_tile)
          for(local j=0;j<st_list.len();j++){
            local tile = my_tile(st_list[j])
            tile.find_object(mo_way).unmark()
            if (tile.get_halt()==null){
              if (tile.find_object(mo_label))
                tile.remove_object(player_x(0), mo_label)
              local tool = command_x(tool_build_station)
              local err = tool.work(player, tile, sc_station_name)
            }
          }

          /*for(local j=0;j<st4_list.len();j++){
            local tile = my_tile(st4_list[j])
            tile.find_object(mo_way).unmark()
            if (tile.get_halt()==null){
              if (tile.find_object(mo_label))
                tile.remove_object(player_x(1), mo_label)
              local tool = command_x(tool_build_station)
              local err = tool.work(player, my_tile(st4_list[j]), sc_station_name)
            }
          }*/
        }
        //Estaciones del Productor
        if (pot[4]==0){
          //Outside tramo ----------------------------------------------------------------------
          local st_list = station_tiles(way2_fac2_fac3[0], way2_fac2_fac3[1], loc2_tile)
          for(local j=0;j<st_list.len();j++){
            local tile = my_tile(st_list[j])
            tile.find_object(mo_way).unmark()
            if (tile.get_halt()==null){
              if (tile.find_object(mo_label))
                tile.remove_object(player_x(0), mo_label)
              local tool = command_x(tool_build_station)
              local err = tool.work(player, tile, sc_station_name)
            }
          }

          /*for(local j=0;j<st3_list.len();j++){
            local tile = my_tile(st3_list[j])
            tile.find_object(mo_way).unmark()
            if (tile.get_halt()==null){
              if (tile.find_object(mo_label))
                tile.remove_object(player_x(1), mo_label)
              local tool = command_x(tool_build_station)
              local err = tool.work(player, my_tile(st3_list[j]), sc_station_name)
            }
          }*/
        }
        return null
        break
      case 7:
        if (!correct_cov)
          return 0

        local opt = 2
        local wt = wt_rail

        if(pot[0]==0){
          local t_start = my_tile(ch3_rail_depot2.b)
          local t_end = my_tile(ch3_rail_depot2.a)
          local t = command_x(tool_build_way)
          t.work(player, t_start, t_end, sc_way_name)
        }

        if(pot[0]==1 && pot[1]==0){
          local t = command_x(tool_build_depot)
          t.work(player, my_tile(ch3_rail_depot2.a), sc_dep_name)
        }

        if(pot[1]==1 && pot[2]==0){
          local wt = wt_rail
          if (current_cov>ch3_cov_lim2.a && current_cov<ch3_cov_lim2.b){
            local c_depot = my_tile(ch3_rail_depot2.a)
            comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito

            local name = loc2_name_obj
            local sched = schedule_x(wt, [])
            sched.entries.append(schedule_entry_x(my_tile(way2_fac2_fac3[0]), loc2_load, loc2_wait))
            sched.entries.append(schedule_entry_x(my_tile(way2_fac2_fac3[5]), 0, 0))
            local c_line = comm_get_line(player, gl_wt, sched, line2_name)

            local name = loc2_name_obj
            local wag_name = sc_veh2_name
            local wag_nr =  sc_wag2_nr //5
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

            pot[3]=1
          }
        }

        return null
        break

      case 8:
        if (pot[0]==0){
          local coora = coord3d(way3_cy1_cy3.a.x, way3_cy1_cy3.a.y, way3_cy1_cy3.a.z)
          local coorb = coord3d(way3_cy1_cy3.b.x, way3_cy1_cy3.b.y, way3_cy1_cy3.b.z)
          local t = command_x(tool_build_way)
          t.set_flags(2)
          local err = t.work(player, coora, coorb, sc_way_name)
          pot[0]=1
        }
        if (pot[0]==1 && pot[1]==0){
          local t_start = my_tile(bridge3_coords.a)
          local t_end = my_tile(bridge3_coords.b)
          if ( !t_start.find_object(mo_bridge) ) {
            t_start.unmark()
            t_end.unmark()
            t_start.remove_object(player_x(1), mo_label)
            local t = command_x(tool_build_bridge)
            local err = t.work(player, t_start, t_end, sc_bridge_name)
          }
          pot[1]=1
        }
        if (pot[1]==1 && pot[2]==0){
          local t_tunn = my_tile(way3_tun_coord[0])
          t_tunn.remove_object(player_x(1), mo_label)
          local t = command_x(tool_build_tunnel)
          t.set_flags(2)
          t.work(player, t_tunn, sc_tunn_name)
          pot[2]=1
              /*
               *  FIX built tunnel end of bridge pak128
               */
              if ( pak_name == "pak128" ) {
                local tile_t = my_tile(way3_tun_coord[0])
                local tile_b = tile_x( tile_t.x+1, tile_t.y, tile_t.z-2 )
                //local tile_w = tile_x( c_tunn2.a.x+4, c_tunn2.a.y, c_tunn2.a.z-1 )

                  //gui.add_message("tile_t.find_object(mo_tunnel) " + tile_t.find_object(mo_tunnel))
                  //gui.add_message("tile_b.find_object(mo_bridge) " + tile_b.find_object(mo_bridge))
                  //gui.add_message("tile_w.find_object(mo_way) " + tile_w.find_object(mo_way))
                local way = tile_t.find_object(mo_way)
                local ribi = way? way.get_dirs() : 0


                if ( ribi == 0 && tile_t.find_object(mo_tunnel) && tile_b.find_object(mo_bridge) ) {
                  //local way_obj = tile_w.find_object(mo_way)
                  local tool = command_x(tool_build_way)
                  local err = tool.work(player_x(0), tile_t, tile_b, sc_way_name)
                }

              }
        }
        if (pot[2]==1 && pot[3]==0){
          local siz = (way3_tun_coord[0].x)-(way3_tun_list[0].x)
          local opt = 1 //Incrementa x
          local t = tile_x(way3_tun_list[0].x, way3_tun_list[0].y, way3_tun_list[0].z)
          clean_track_segment(t, siz, opt)
          local t_tun = command_x(tool_build_tunnel)
          local c_start = way3_tun_coord[0]
          local c_end = coord3d(way3_tun_list[0].x, way3_tun_list[0].y, way3_tun_list[0].z)
          t_tun.work(player, c_start, c_end, sc_tunn_name)
          pot[3] = 1

        }
        if (pot[3]==1 && pot[4]==0){
          local t_tun = command_x(tool_build_tunnel)
          local c_list =  way3_tun_list
          local t_start = my_tile(way3_tun_coord[0])
          for(local j = 0; j<(c_list.len()-1);j++){
            local c = coord3d(c_list[j].x, c_list[j].y, (t_start.z+j))
            t_tun.work(player, t_start, c, sc_tunn_name)
            if(!square_x(c.x, c.y).get_tile_at_height(c.z)){
              c.z--
              command_x.set_slope(player, c, slope.all_up_slope)
              c.z++
            }
            command_x.set_slope(player, c, slope.all_up_slope)
          }
          t_tun.work(player, way3_tun_coord[0] , way3_tun_coord[2], sc_tunn_name)
        }

        return null
        break

      case 9:
        if (pot[0]==0){
                for(local j=0;j<way3_cy1_cy6.len();j++){
            if(glsw[j] == 0){
              local tile_a = my_tile(way3_cy1_cy6[j].a)
              local tile_b = my_tile(way3_cy1_cy6[j].b)

              tile_a.find_object(mo_way).unmark()
              tile_b.find_object(mo_way).unmark()

              tile_a.remove_object(player_x(1), mo_label)
              tile_b.remove_object(player_x(1), mo_label)

              local coora = coord3d(way3_cy1_cy6[j].a.x, way3_cy1_cy6[j].a.y, way3_cy1_cy6[j].a.z)
              local coorb = coord3d(way3_cy1_cy6[j].b.x, way3_cy1_cy6[j].b.y, way3_cy1_cy6[j].b.z)
              local t = command_x(tool_build_way)
              t.set_flags(2)
              local err = t.work(player, coora, coorb, sc_way_name)

              if(j == way3_cy1_cy6.len()-1){
                pot[0] = 1
                reset_glsw()
                break
              }
            }
                }
        }
        if (pot[0]==1 && pot[1]==0){
          for(local j=0;j<way3_sign_list.len();j++){
            local tile = tile_x(way3_sign_list[j].c.x, way3_sign_list[j].c.y, way3_sign_list[j].c.z)
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
              local err = t.work(player, my_tile(coord(way3_sign_list[j].c.x, way3_sign_list[j].c.y)), sc_sign_name)
              local ribi = way.get_dirs_masked()
              if (ribi == way3_sign_list[j].ribi)
                break
            }
          }
        }
        return null
        break

      case 10:
        if (!correct_cov)
          return 0
        if (r_way.c != 0){
          local tile = tile_x(r_way.c.x, r_way.c.y, r_way.c.z)
          local way = tile.find_object(mo_way)
          if(way) way.unmark()
          tile.remove_object(player_x(1), mo_label)
        }
        if (pot[0]==0){
                for(local j=0;j<way3_cate_list1.len();j++){
            if(glsw[j] == 0){
              local coora = way3_cate_list1[j].a
              local coorb = way3_cate_list1[j].b
              local t = command_x(tool_build_wayobj)
              local err = t.work(player, coora, coorb, sc_caten_name)
            }
                }
        }
        if (pot[1]==0){
          local way = my_tile(ch3_rail_depot3.a).find_object(mo_way)
          way.unmark()
          local t = command_x(tool_build_wayobj)
          local err = t.work(player, my_tile(ch3_rail_depot3.a), my_tile(ch3_rail_depot3.b), sc_caten_name)

        }
        if (pot[2]==0){
          local tile = my_tile(ch3_rail_depot3.b)
          tile.remove_object(player_x(1), mo_label) //Elimina texto label
          local t = command_x(tool_build_depot)
          local err = t.work(player, tile, sc_dep_name)
        }
        return null
        break

      case 11:
        local wt = wt_rail
        local c_depot = my_tile(ch3_rail_depot3.b)
        comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito

        local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)

        if (current_cov>ch3_cov_lim3.a && current_cov<ch3_cov_lim3.b){
          //Set Schedule
          local sched = schedule_x(gl_wt, [])
          local c_list = ch3_rail_stations
          local sch_siz = c_list.len()
          local load = loc3_load
          local time = loc3_wait
          for(local j=0;j<sch_siz;j++){
            if (j==get_waiting_halt(4))
              sched.entries.append(schedule_entry_x(my_tile(c_list[j]), load, time))
            else
              sched.entries.append(schedule_entry_x(my_tile(c_list[j]), 0, 0))
          }
          local c_line = comm_get_line(player, gl_wt, sched, line3_name)

          // Set and run convoys
          local good_nr = 0 //Passengers
          local name = loc3_name_obj
          local cov_nr = dep_cnr3  //Max convoys nr in depot
          local wag_name = sc_wag3_name
          local wag_nr = sc_wag3_nr
          local wag = true
          for (local j = 0; j<cov_nr;j++){
            if (!comm_set_convoy(cov_nr, c_depot, name))
              return 0
            for (local count = 0;count<wag_nr;count++){
              if (!comm_set_convoy(j, c_depot, wag_name, wag))
                return 0
            }
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

  function is_tool_active(pl, tool_id, wt) {
    local result = false
    switch (this.step) {
      case 1:
        local t_list = []
        local wt_list = [gl_wt]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 2:
        local t_list = [tool_build_way, tool_build_bridge, tool_remove_way]
        local wt_list = [gl_wt]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 3:
        local t_list = [tool_build_station]
        local wt_list = [gl_wt]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 4:
        local t_list = [-tool_remover, tool_build_way, tool_build_depot]
        local wt_list = [gl_wt]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 5://Schedule
        local t_list = [-tool_remover, -t_icon.rail]
        local wt_list = [gl_wt]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 6:
        local t_list = [tool_build_way, tool_remove_way, tool_build_tunnel, tool_remover, tool_build_station]
        local wt_list = [gl_wt]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 7:
        local t_list = [tool_build_way, tool_build_depot]
        local wt_list = [gl_wt]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 8:
        local t_list = [tool_build_way, tool_build_bridge, tool_remove_way, tool_build_tunnel]
        local wt_list = [gl_wt]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 9:
        local t_list = [-t_icon.slope, -tool_setslope, tool_build_way, tool_build_roadsign]
        local wt_list = [gl_wt]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 10:
        local t_list = [-t_icon.slope, -tool_setslope, -tool_remover, tool_build_depot, tool_build_wayobj]
        local wt_list = [gl_wt]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 11://Schedule
        local t_list = [-t_icon.slope, -tool_setslope, -tool_remover, -t_icon.rail]
        local wt_list = [gl_wt]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

    }
    return result
  }


  function is_tool_allowed(pl, tool_id, wt){

    local result = true
    local t_list = [-t_icon.tram, 0] // 0 = all tools allowed
    local wt_list = [gl_wt]
    local res = update_tools(t_list, tool_id, wt_list, wt)
    return res.result
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
        //if(j!=0 )
          label_x.create(c_list[j], pl_unown, format(translate("Build station No.%d here!."),j+1))
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

  /**
    *
    */
  function get_stations(pos, tool_id, result, good, c_list)
  {
    for( local j = 0; j < c_list.len(); j++ ) {
      local tile = my_tile(c_list[j])  //tile_x(c_list[j].x, c_list[j].y, 0)
      local halt = tile.get_halt()
      local build = tile.find_object(mo_building)
      local way = tile.find_object(mo_way)
      if ( build ) {
        local st_desc = build.get_desc()
        local st_list = building_desc_x.get_available_stations(st_desc.get_type(), st_desc.get_waytype(), good_desc_x(good))
        local sw = false
        foreach ( st in st_list ) {
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

  /**
    *
    */
  function train_result_message(nr, name, good, veh, cov, st_t)
  {
    switch (nr) {
      //case 0:
        //return format(translate("You must first buy a locomotive [%s]."),name)
      //  break

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

