/** @file class_chapter_06.nut
  * @brief Air travel with bus connections
  */

/**
  * @brief class_chapter_06.nut
  * Air travel with bus connections
  *
  * Can NOT be used in network game !
  *
  */
class tutorial.chapter_06 extends basic_chapter
{
  chapter_name  = ch6_name
  chapter_coord = coord_chapter_6
  startcash     = 500000            // pl=0 startcash; 0=no reset

  gl_wt = wt_air

  //Step 2 =====================================================================================
  ch6_cov_lim1 = {a = 0, b = 0}

  //Step 3 =====================================================================================
  ch6_cov_lim2 = {a = 0, b = 0}

  //Step 4 =====================================================================================
  ch6_cov_lim3 = {a = 0, b = 0}

  c_way = coord(0,0)

  cty1 = {name = ""}
  cty2 = {name = ""}

  cty1_lim = {a = null, b = null}
  cty2_lim = {a = null, b = null}

  sch_cov_correct = false

  // Step 1 =====================================================================================
  // Pista de aterrizaje --------------------------
  c1_track = {a = coord(112,174), b = coord(112,178), dir = 4}
  c1_start = coord(112,174)
  c1_is_way = null
  obj1_way_name = get_obj_ch6(1)

  // Pista de maniobras --------------------------
  c2_track = {a = coord(112,176), b = coord(114,176), dir = 2}
  c2_start = coord(112,176)
  c2_is_way = null
  obj2_way_name = get_obj_ch6(2)

  // Step 2 =====================================================================================
  d1_cnr = null //auto started
  plane1_obj = get_veh_ch6(1)
  line1_name = "ch6_l1"

  // Step 3 =====================================================================================
  //c_dep2 = coord(115,185)
  d2_cnr = null //auto started
  veh1_obj = get_veh_ch6(2)
  line2_name = "ch6_l2"

  // Step 4 =====================================================================================
  d3_cnr = null //auto started
  veh2_obj = get_veh_ch6(3)
  line3_name = "ch6_l3"

  //Script
  //----------------------------------------------------------------------------------

  sc_sta1 = get_obj_ch6(3)
  sc_sta2 = get_obj_ch6(4)
  sc_dep1 = null
  sc_dep2 = null


  function start_chapter()  //Inicia solo una vez por capitulo
  {

    local lim_idx = cv_list[(persistent.chapter - 2)].idx
    ch6_cov_lim1 = {a = cv_lim[lim_idx].a, b = cv_lim[lim_idx].b}
    ch6_cov_lim2 = {a = cv_lim[lim_idx+1].a, b = cv_lim[lim_idx+1].b}
    ch6_cov_lim3 = {a = cv_lim[lim_idx+2].a, b = cv_lim[lim_idx+2].b}

    /// set air depot name
    sc_dep1 = find_object("depot", wt_air).get_name()
    /// set road depot name
    sc_dep2 = find_object("depot", wt_road).get_name()

    d1_cnr = get_dep_cov_nr(ch6_cov_lim1.a,ch6_cov_lim1.b)
    d2_cnr = get_dep_cov_nr(ch6_cov_lim2.a,ch6_cov_lim2.b)
    d3_cnr = get_dep_cov_nr(ch6_cov_lim3.a,ch6_cov_lim3.b)

    cty1.name = get_city_name(city1_tow)
    cty2.name = get_city_name(city7_tow)

    line1_name = "Air " + cty1.name + " - " + cty2.name
    line2_name = "City " + cty1.name + " - Airport"
    line3_name = "City " + cty2.name + " - Airport"
/*
    //Schedule list form current convoy
    if(this.step == 2){
      local c_dep = this.my_tile(city1_road_depot)
      local c_list = city1_halt_1
      start_sch_tmpsw(pl, c_dep, c_list)
    }
    else if(this.step == 3){
      local c_dep = this.my_tile(city1_road_depot)
      local c_list = city1_halt_2
      start_sch_tmpsw(pl, c_dep, c_list)
    }
    else if(this.step == 4){
      local c_dep = this.my_tile(city1_road_depot)
      local c_list = city2_halt_1
      start_sch_tmpsw(pl, c_dep, c_list)
    }*/
  }

  function set_goal_text(text){
    switch (this.step) {
      case 1:
        text.c1_a = "<a href=\"("+c1_track.a.x+","+c1_track.a.y+")\">("+c1_track.a.tostring()+")</a>"
        text.c1_b = "<a href=\"("+c1_track.b.x+","+c1_track.b.y+")\">("+c1_track.b.tostring()+")</a>"
        text.c2_a = "<a href=\"("+c2_track.a.x+","+c2_track.a.y+")\">("+c2_track.a.tostring()+")</a>"
        text.c2_b = "<a href=\"("+c2_track.b.x+","+c2_track.b.y+")\">("+c2_track.b.tostring()+")</a>"

        text.st1 = "<a href=\"("+city1_city7_air[0].x+","+city1_city7_air[0].y+")\">("+city1_city7_air[0].tostring()+")</a>"
        text.st2 = "<a href=\"("+city1_halt_airport_extension[0].x+","+city1_halt_airport_extension[0].y+")\">("+city1_halt_airport_extension[0].tostring()+")</a>"

        break

      case 2:
        local list_tx = ""
        local c_list = city1_city7_air
        local siz = c_list.len()
        for (local j=0;j<siz;j++){
          local c = coord(c_list[j].x, c_list[j].y)
          local tile = my_tile(c)
          local st_halt = tile.get_halt()
          if(sch_cov_correct){
            list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
            continue
          }
          if(tmpsw[j]==0 ){
            list_tx += format("<st>%s %d:</st> %s<br>", translate("Stop"), j+1, c.href(st_halt.get_name()+" ("+c.tostring()+")"))
          }
          else{
            list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
          }
        }
        local c = coord(c_list[get_waiting_halt(6)].x, c_list[get_waiting_halt(6)].y)
        text.stnam = (get_waiting_halt(6)+1) + ") " + my_tile(c).get_halt().get_name()+" ("+c.tostring()+")"
        text.list = list_tx
        text.plane = translate(plane1_obj)
        text.load = set_loading_capacity(5)
        text.wait = get_wait_time_text(set_waiting_time(8))
        text.cnr = d1_cnr


        break

      case 3:
        local list_tx = ""
        local c_list = city1_halt_airport
        local siz = c_list.len()
        for (local j=0;j<siz;j++){
          local c = coord(c_list[j].x, c_list[j].y)
          local tile = my_tile(c)
          local st_halt = tile.get_halt()

          if ( check_halt_wt(tile, wt_air) != null ) {
            // airport bus halt
            text.sch1 = "<a href=\"("+tile.x+","+tile.y+")\"> "+st_halt.get_name()+" ("+tile.x+","+tile.y+")</a>"
          }

          if(sch_cov_correct){
            list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
            continue
          }
          if(tmpsw[j]==0 ){
            list_tx += format("<st>%s %d:</st> %s<br>", translate("Stop"), j+1, c.href(st_halt.get_name()+" ("+c.tostring()+")"))
          }
          else{
            list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
          }
        }

        local c = coord(c_list[get_waiting_halt(7)].x, c_list[get_waiting_halt(7)].y)
        text.stnam = (get_waiting_halt(7)+1) + ") " + my_tile(c).get_halt().get_name()+" ("+c.tostring()+")"
        text.stx = list_tx
        text.dep2 = "<a href=\"("+city1_road_depot.x+","+city1_road_depot.y+")\"> ("+city1_road_depot.tostring()+")</a>"
        text.load = set_loading_capacity(6)
        text.wait = get_wait_time_text(set_waiting_time(9))
        text.cnr = d2_cnr

        break

      case 4:
        local list_tx = ""
        local c_list = city7_halt
        local siz = c_list.len()
        for (local j=0;j<siz;j++){
          local c = coord(c_list[j].x, c_list[j].y)
          local tile = my_tile(c)
          local st_halt = tile.get_halt()

          if ( check_halt_wt(tile, wt_air) != null ) {
            // airport bus halt
            text.sch2 = "<a href=\"("+tile.x+","+tile.y+")\"> "+st_halt.get_name()+" ("+tile.x+","+tile.y+")</a>"
          }

          if(sch_cov_correct){
            list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
            continue
          }
          if(tmpsw[j]==0 ){
            list_tx += format("<st>%s %d:</st> %s<br>", translate("Stop"), j+1, c.href(st_halt.get_name()+" ("+c.tostring()+")"))
          }
          else{
            list_tx += format("<em>%s %d:</em> %s <em>%s</em><br>", translate("Stop"), j+1, st_halt.get_name(), translate("OK"))
          }
        }
        local c = coord(c_list[get_waiting_halt(8)].x, c_list[get_waiting_halt(8)].y)
        text.stnam = (get_waiting_halt(8)+1) + ") " + my_tile(c).get_halt().get_name()+" ("+c.tostring()+")"
        text.stx = list_tx
        text.dep3 = "<a href=\"("+city7_road_depot.x+","+city7_road_depot.y+")\">("+city7_road_depot.tostring()+")</a>"

        text.load = set_loading_capacity(7)
        text.wait = get_wait_time_text(set_waiting_time(10))
        text.cnr = d3_cnr

        break
    }

      text.w1name = translate(obj1_way_name)
      text.w2name = translate(obj2_way_name)
      text.bus1 = translate(veh1_obj)
      text.bus2 = translate(veh2_obj)
      text.cit1 = city1_tow.href(cty1.name.tostring())
      text.cit2 = city7_tow.href(cty2.name.tostring())
      text.dep1 = "<a href=\"("+ch6_air_depot.a.x+","+ch6_air_depot.a.y+")\">("+ch6_air_depot.a.tostring()+")</a>"
      return text
  }

  function is_chapter_completed(pl) {

    save_glsw()
    save_pot()

    persistent.ch_max_steps = 4
    local chapter_step = persistent.step
    persistent.ch_max_sub_steps = 0 // count all sub steps
    persistent.ch_sub_step = 0  // actual sub step

    switch (this.step) {
      case 1:
        if (pot[0]==0){
          local tile = my_tile(c1_start)
          c1_is_way = tile.find_object(mo_way)

          local ta = my_tile(c1_track.a)
          local tb = my_tile(c1_track.b)
          local wt = gl_wt
          local name_list = [obj1_way_name]
          local dir = c1_track.dir
          local fullway = check_way(ta, tb, wt, name_list, dir)
          if (fullway.result){
            c_way =  coord(0,0)
            pot[0]=1
          }
          else
            c_way = fullway.c

          //return 5
        }

        else if (pot[0]==1 && pot[1]==0){
          local tile = my_tile(c2_start)
          c2_is_way = tile.find_object(mo_way)

          local ta = my_tile(c2_track.a)
          local tb = my_tile(c2_track.b)
          local wt = gl_wt
          local name_list = [obj1_way_name, obj2_way_name]
          local dir = c2_track.dir
          local fullway = check_way(ta, tb, wt, name_list, dir)
          if (fullway.result){
            c_way = coord(0,0)
            pot[1]=1
          }
          else
            c_way = fullway.c

          //return 10
        }

        else if (pot[1]==1 && pot[2]==0){
          local tile = my_tile(city1_city7_air[0])
          local way = tile.find_object(mo_way)
          local buil = tile.find_object(mo_building)
          local name = translate("Build here")
          public_label(tile, name)
          if(way && buil){
            tile.remove_object(player_x(1), mo_label)
            pot[2] = 1
          }
          //return 15
        }

        else if (pot[2]==1 && pot[3]==0){
          local tile = my_tile(city1_halt_airport_extension[0])
          local buil = tile.find_object(mo_building)
          local name = translate("Build here")
          public_label(tile, name)
          if(buil){
            tile.remove_object(player_x(1), mo_label)
            pot[3] = 1
          }
          //return 20
        }

        else if (pot[3]==1 && pot[4]==0){
          local tile = my_tile(ch6_air_depot.a)
          local way = tile.find_object(mo_way)
          local depot = tile.find_object(mo_depot_air)
          local name = translate("Build here")
          public_label(tile, name)
          if(way && depot){
            tile.remove_object(player_x(1), mo_label)
            tile.remove_object(player_x(1), mo_label)
            pot[4] = 1
          }
          //return 25
        }
        else if (pot[4]==1 && pot[5]==0){
          local tile = my_tile(city1_halt_airport[0])
          local buil = tile.find_object(mo_building)
          if(buil && buil.get_owner().nr == 1){
            pot[5] = 1
          }
          //return 30
        }
        else if (pot[5]==1 && pot[6]==0){
          this.next_step()
        }

        break;

      case 2:

        local c_dep = my_tile(ch6_air_depot.a)
        local line_name = line1_name
        set_convoy_schedule(pl, c_dep, wt_air, line_name)

        local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
        local cov_list = depot.get_convoy_list()    //Lista de vehiculos en el deposito
        local convoy = convoy_x(gcov_id)
        if (cov_list.len()>=1){
          convoy = cov_list[0]
        }
        local all_result = checks_convoy_schedule(convoy, pl)
        sch_cov_correct = all_result.res == null ? true : false

        if(current_cov == ch6_cov_lim1.b){
          sch_cov_correct = false
          this.next_step()
        }

        //return 50
        break;

      case 3:
        local c_dep = my_tile(city1_road_depot)
        local line_name = line2_name
        set_convoy_schedule(pl, c_dep, wt_road, line_name)

        local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
        local cov_list = depot.get_convoy_list()    //Lista de vehiculos en el deposito
        local convoy = convoy_x(gcov_id)
        if (cov_list.len()>=1){
          convoy = cov_list[0]
        }
        local all_result = checks_convoy_schedule(convoy, pl)
        sch_cov_correct = all_result.res == null ? true : false

        if(current_cov == ch6_cov_lim2.b){
          sch_cov_correct = false
          this.next_step()
        }
        //return 65
        break;

      case 4:
        if (pot[0]==0){
          local tile = my_tile(city7_road_depot)
          local way = tile.find_object(mo_way)
          local depot = tile.find_object(mo_depot_road)
          if(way && depot){
            pot[0] = 1
          }
          //return 25
        }
        else if (pot[0]==1 && pot[1]==0){
          local c_dep = my_tile(city7_road_depot)
          local line_name = line3_name
          set_convoy_schedule(pl, c_dep, wt_road, line_name)

          local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
          local cov_list = depot.get_convoy_list()    //Lista de vehiculos en el deposito
          local convoy = convoy_x(gcov_id)
          if (cov_list.len()>=1){
            convoy = cov_list[0]
          }
          local all_result = checks_convoy_schedule(convoy, pl)
          sch_cov_correct = all_result.res == null ? true : false

          if(current_cov == ch6_cov_lim3.b){
            sch_cov_correct = false
            this.next_step()
          }
        }
        //return 80
        break;

      case 5:
        this.step=1
        persistent.step=1
        persistent.status.step = 1
        //return 100
        break;
    }
    local percentage = chapter_percentage(persistent.ch_max_steps, chapter_step, persistent.ch_max_sub_steps, persistent.ch_sub_step)
    return percentage
  }

  function is_work_allowed_here(pl, tool_id, name, pos, tool) {
    local result = null // null is equivalent to 'allowed'

    result = get_message(2) //translate("Action not allowed")
    local t = tile_x(pos.x, pos.y, pos.z)
    local ribi = 0
    local wt = 0
    //local tmark = t.is_marked()
    local buil = t.find_object(mo_building)
    //if(buil)
      //gui.add_message(""+buil.get_desc().get_name())

    local depot = t.find_object(mo_depot_air)
    //if(depot)
      //gui.add_message(""+depot.get_desc().get_name())

    local way = t.find_object(mo_way)
    //local gcursor = t.find_object(mo_pointer)
    //local cursor = null
    //local hold_way = null

    if (way){
      wt = way.get_waytype()
      if (tool_id!=4111)
        ribi = way.get_dirs()
      if (!t.has_way(gl_wt))
        ribi = 0
    }

    if (tool_id==4096)
      return null

    switch (this.step) {
      case 1:
        local climate = square_x(pos.x, pos.y).get_climate()
        //return climate
        if (pot[0]==0){
          if ((pos.x>=c1_track.a.x)&&(pos.y>=c1_track.a.y)&&(pos.x<=c1_track.b.x)&&(pos.y<=c1_track.b.y)){

            // check selected way
            local s = check_select_way(name, wt_air, st_runway)
            if ( s != null ) return s

            if ( way && way.get_name() != obj1_way_name ) {
              if ( tool_id == tool_remover || tool_id == tool_remove_way ) return null

              result = format(translate("The track is not correct it must be: %s, use the 'Remove' tool"),translate(obj1_way_name)) + " ("+c1_start.tostring()+")."

              if(tool_id == tool_build_way) return result
            }
            else if (way) result = translate("The track is correct.")

            if(tool_id == tool_build_way) return null
          }
          else return translate("Build here") + ": ("+coord3d_to_string(c_way)+")!."
        }
        else if (pot[0]==1 && pot[1]==0){
          if (pos.x == c2_track.a.x && pos.y == c2_track.a.y){
            if(tool_id == tool_remover || tool_id == tool_remove_way) return result
            else if(tool_build_way) return null
          }

          if ((pos.x>=c2_track.a.x)&&(pos.y>=c2_track.a.y)&&(pos.x<=c2_track.b.x)&&(pos.y<=c2_track.b.y)){

            // check selected way
            local s = check_select_way(name, wt_air)
            if ( s != null ) return s

            if (way && way.get_name() != obj2_way_name){
              if(tool_id == tool_remover || tool_id == tool_remove_way) return null

              result = format(translate("The track is not correct it must be: %s, use the 'Remove' tool"),translate(obj2_way_name)) + " ("+c2_start.tostring()+")."

              if(tool_id == tool_build_way){
                return result
              }
            }
            else if (way) result = translate("The track is correct.")

            if(tool_id == tool_build_way) return null
          }
          else return translate("Build here") + ": ("+c_way.tostring()+")!."
        }

        else if (pot[1]==1 && pot[2]==0){
          if(pos.x == city1_city7_air[0].x && pos.y == city1_city7_air[0].y){
            if(tool_id == tool_build_way){
              if (way){
                return translate("The track is correct.")
              }
              else return null
            }
            if(tool_id == tool_build_station){
              if(buil){
                return translate("There is already a station.")
              }
              else return null
            }
          }
          else return translate("Build here") + ": ("+city1_halt_airport[0].tostring()+")!."
        }

        else if (pot[2]==1 && pot[3]==0){
          if(pos.x == city1_halt_airport_extension[0].x && pos.y == city1_halt_airport_extension[0].y){
            if(tool_id == tool_build_station){
              if (buil){
                return translate("There is already a station.")
              }
              else return null
            }
          }
          else return translate("Build here") + ": ("+city1_halt_airport_extension[0].tostring()+")!."
        }

        else if (pot[3]==1 && pot[4]==0){
          if((pos.x == ch6_air_depot.b.x && pos.y == ch6_air_depot.b.y) || (pos.x == ch6_air_depot.a.x && pos.y == ch6_air_depot.a.y)){
            if(tool_id == tool_build_way){
              return null
            }
            if(tool_id == tool_build_depot){
              if(depot){
                return translate("The Hangar is correct.")
              }
              else return null
            }
          }
          else return translate("Build here") + ": ("+ch6_air_depot.a.tostring()+")!."
        }
        else if (pot[4]==1 && pot[5]==0){
          if(pos.x == city1_halt_airport[0].x && pos.y == city1_halt_airport[0].y){
            if(tool_id == tool_make_stop_public){
              if(buil){
                return null
              }
              else return null
            }
          }
          else return translate("Click on the stop") + " ("+city1_halt_airport[0].tostring()+")!."

        }
        break;

      case 2:

        if (tool_id==4108) {
          return is_stop_allowed(ch6_air_depot.a, city1_city7_air, pos)

        }
        break;

      case 3:
        if (tool_id==4108) {
          return is_stop_allowed(city1_road_depot, city1_halt_airport, pos)
        }
        break;

      case 4:
        if (pot[0]==0){
          if(pos.x == city7_road_depot.x && pos.y == city7_road_depot.y){
            if(tool_id == tool_build_depot){
              if(depot){
                return translate("The Depot is correct.")
              }
              else return null
            }
          }
          else return translate("Build here") + ": ("+city7_road_depot.tostring()+")!."
        }
        if (pot[0]==1 && pot[1]==0){
          if (tool_id==4108) {
            return is_stop_allowed(city7_road_depot, city7_halt, pos)
          }
        }
        break;
    }
    if (tool_id==4096)
      return null
    return result

  }

  function is_schedule_allowed(pl, schedule) {
    local result=null // null is equivalent to 'allowed'
    switch (this.step) {
      case 2:
        if ( schedule.waytype != wt_air )
          result = translate("Only air schedules allowed")

        reset_glsw()

        local selc = get_waiting_halt(6)
        local load = set_loading_capacity(5)
        local time = set_waiting_time(8)
        local c_list = city1_city7_air
        result = compare_schedule(result, pl, schedule, selc, load, time, c_list, false)
        if(result == null){
          update_convoy_schedule(pl, wt_air, line1_name, schedule)
        }
        return result
      break
      case 3:
        if ( schedule.waytype != wt_road )
          result = translate("Only road schedules allowed")

        reset_glsw()

        local selc = get_waiting_halt(7)
        local load = set_loading_capacity(6)
        local time = set_waiting_time(9)
        local c_list = city1_halt_airport
        result = compare_schedule(result, pl, schedule, selc, load, time, c_list, true)
        if(result == null){
          update_convoy_schedule(pl, wt_road, line2_name, schedule)
        }
        return result
      break
      case 4:
        if ( schedule.waytype != wt_road )
          result = translate("Only road schedules allowed")

        reset_glsw()

        local selc = get_waiting_halt(8)
        local load = set_loading_capacity(7)
        local time = set_waiting_time(10)
        local c_list = city7_halt
        result = compare_schedule(result, pl, schedule, selc, load, time, c_list, true)
        if(result == null){
          update_convoy_schedule(pl, wt_road, line3_name, schedule)
        }
        return result
      break
    }
    return get_message(2) //translate("Action not allowed")
  }

  function is_convoy_allowed(pl, convoy, depot)
  {
    local result=null // null is equivalent to 'allowed'
    switch (this.step) {
      case 2:
        local wt = gl_wt
        if ((depot.x != ch6_air_depot.a.x)||(depot.y != ch6_air_depot.a.y))
          return get_tile_message(15, ch6_air_depot.a) //translate("You must select the deposit located in")+" ("+ch6_air_depot.a.tostring()+")."
        if (current_cov>ch6_cov_lim1.a && current_cov<ch6_cov_lim1.b){
          local cov = d1_cnr
          local veh = 1
          local good_list = [good_desc_x(good_alias.passa).get_catg_index()] //Passengers
          local name = plane1_obj
          local st_tile = 1
          local load = set_loading_capacity(5)

          result = is_convoy_correct(depot, cov, veh,good_list, name, st_tile)
          if (result!=null){
            local name = translate(plane1_obj)
            local load = translate(good_alias.passa)
            if (result==0)
              return format(translate("You must select a [%s]."),translate(name))

            if (result==1)
              return format(translate("The number of aircraft in the hangar must be [%d]."),cov)

            if (result==2)
              return format(translate("The number of convoys must be [%d], press the [Sell] button."),cov)

            if (result==3)
              return format(translate("The Plane must be for [%s]."),load)

            if (result==4)
              return translate("Extensions are not allowed.")

            if (result==5)
              return format(translate("The number of planes in the hangar must be [%d], use the [sell] button."),cov)
          }

          local selc = get_waiting_halt(6)
          local time = set_waiting_time(8)
          local c_list = city1_city7_air
          local siz = c_list.len()
          result = compare_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
          if(result == null)
            reset_tmpsw()
          return result
        }
      break
      case 3:
        if ((depot.x != city1_road_depot.x)||(depot.y != city1_road_depot.y))
          return get_tile_message(15, city1_road_depot) //translate("You must select the deposit located in")+" ("+city1_road_depot.tostring()+")."
        if (current_cov>ch6_cov_lim2.a && current_cov<ch6_cov_lim2.b){
          local cov_list = depot.get_convoy_list()
          local cov = d2_cnr
          local veh = 1
          local good_list = [good_desc_x (good_alias.passa).get_catg_index()]    //Passengers
          local name = veh1_obj
          local st_tile = 1

          //Para arracar varios vehiculos
          local id_start = ch6_cov_lim2.a
          local id_end = ch6_cov_lim2.b
          local c_list = city1_halt_airport
          local cir_nr = get_convoy_number_exp(c_list[0], depot, id_start, id_end)
          cov -= cir_nr

          result = is_convoy_correct(depot,cov,veh,good_list,name, st_tile)
          if (result!=null){
            reset_tmpsw()
            return bus_result_message(result, translate(name), veh, cov)
          }

          local selc = get_waiting_halt(7)
          local load = set_loading_capacity(6)
          local wait = set_waiting_time(9)
          local siz = c_list.len()
          local line = false
          result = compare_schedule_convoy(result, pl, cov, convoy, selc, load, wait, c_list, siz, line)
          if(result == null)
            reset_tmpsw()
          return result
        }
      break
      case 4:
        if ((depot.x != city7_road_depot.x)||(depot.y != city7_road_depot.y))
          return get_tile_message(15, city7_road_depot) //translate("You must select the deposit located in")+" ("+city7_road_depot.tostring()+")."
        if (current_cov>ch6_cov_lim3.a && current_cov<ch6_cov_lim3.b){
          local cov_list = depot.get_convoy_list()
          local cov = d3_cnr
          local veh = 1
          local good_list = [good_desc_x (good_alias.passa).get_catg_index()]    //Passengers
          local name = veh1_obj
          local st_tile = 1

          //Para arracar varios vehiculos
          local id_start = ch6_cov_lim3.a
          local id_end = ch6_cov_lim3.b
          local c_list = city7_halt
          local cir_nr = get_convoy_number_exp(c_list[0], depot, id_start, id_end)
          cov -= cir_nr

          result = is_convoy_correct(depot,cov,veh,good_list,name, st_tile)
          if (result!=null){
            reset_tmpsw()
            return bus_result_message(result, translate(name), veh, cov)
          }

          local selc = get_waiting_halt(8)
          local load = set_loading_capacity(7)
          local wait = set_waiting_time(10)
          local siz = c_list.len()
          local line = false
          result = compare_schedule_convoy(result, pl, cov, convoy, selc, load, wait, c_list, siz, line)
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
    local player = player_x(0)
    switch (this.step) {
      case 1:
        // Pista de aterrizaje --------------------------
        if(pot[0] == 0) {
          local coora = my_tile(c1_track.a)
          local coorb = my_tile(c1_track.b)

          local wt = gl_wt
          local name_list = [obj1_way_name]
          local dir = c1_track.dir
          local fullway = check_way(coora, coorb, wt, name_list, dir)
          if (fullway.result){
            c_way =  coord(0,0)
          }
          else{
            local tile = tile_x(fullway.c.x, fullway.c.y, fullway.c.z)
            local way = tile.find_object(mo_way)
            if(way)
              way.unmark()

            local siz = (coorb.y)-(coora.y)+(1)
            local opt = 2 //Incrementa y
            local t = coora
            clean_track_segment(t, siz, opt)
          }
          //gui.add_message(""+fullway.result)

          coora = my_tile(c1_track.a)
          coorb = my_tile(c1_track.b)
          local t = command_x(tool_build_way)
          t.work(player, coora, coorb, obj1_way_name)
        }

        // Pista de maniobras --------------------------
        if(pot[1] == 0) {
          local coora = my_tile(c2_track.a)
          local coorb = my_tile(c2_track.b)

          local wt = gl_wt
          local name_list = [obj2_way_name]
          local dir = c2_track.dir
          local fullway = check_way(coora, coorb, wt, name_list, dir)
          if (fullway.result){
            c_way =  coord(0,0)
          }
          else{
            local tile = tile_x(fullway.c.x, fullway.c.y, fullway.c.z)
            local way = tile.find_object(mo_way)
            if(way)
              way.unmark()

            local siz = (coorb.x)-(coora.x)-1
            //gui.add_message(""+siz+" -- "+coorb.x)
            local opt = 1 //Incrementa x
            coora.x++
            local t = coora
            clean_track_segment(t, siz, opt)
          }
          //gui.add_message(""+fullway.result)

          coora = my_tile(c2_track.a)
          coorb = my_tile(c2_track.b)

          local t = command_x(tool_build_way)
          t.work(player, coora, coorb, obj2_way_name)
        }
        // Parada aerea ---------------------------------
        if(pot[2] == 0) {
          local tile = my_tile(city1_city7_air[0])
          tile.remove_object(player_x(1), mo_label)
          local t = command_x(tool_build_station)
          t.work(player, tile, sc_sta1)
          t = command_x(tool_make_stop_public)
          t.work(player, tile)
        }
        // Terminal -------------------------------------
        if(pot[3] == 0) {
          local tile = my_tile(city1_halt_airport_extension[0])
          tile.remove_object(player_x(1), mo_label)
          local t = command_x(tool_build_station)
          t.work(player, tile, sc_sta2)
        }

        //  Hangar --------------------------------------
        if(pot[4] == 0) {
          local coora = my_tile(ch6_air_depot.a)
          local coorb = my_tile(ch6_air_depot.b)
          local t = command_x(tool_build_way)
          t.work(player, coora, coorb, obj2_way_name)
          local tile = my_tile(ch6_air_depot.a)
          t = command_x(tool_build_depot)
          t.work(player, tile, sc_dep1)
        }
        if(pot[5] == 0) {
          local t = command_x(tool_make_stop_public)
          t.work(player, my_tile(city1_halt_airport[0]), "")
        }
        return null
      break;
      case 2:
        //gui.add_message(""+current_cov+" -- "+ch6_cov_lim1.a +" -- "+ ch6_cov_lim1.b)
        if (current_cov> ch6_cov_lim1.a && current_cov< ch6_cov_lim1.b){

          local pl = player
          local c_depot = my_tile(ch6_air_depot.a)

          try {
            comm_destroy_convoy(pl, c_depot) // Limpia los vehiculos del deposito
          }
          catch(ev) {
            return null
          }
          local sched = schedule_x(gl_wt, [])
          local c_list = city1_city7_air
          for(local j = 0; j<c_list.len(); j++){
            if(j==get_waiting_halt(6))
              sched.entries.append(schedule_entry_x(my_tile(c_list[j]), set_loading_capacity(5), set_waiting_time(8)))
            else
              sched.entries.append(schedule_entry_x(my_tile(c_list[j]), 0, 0))
          }
          local c_line = comm_get_line(player, gl_wt, sched, line1_name)

          local depot = c_depot.find_object(mo_depot_air)
          local name = plane1_obj
          local cov_nr = d1_cnr  //Max convoys nr in depot
          if (!comm_set_convoy(cov_nr, c_depot, name))
            return 0

          local conv = depot.get_convoy_list()
          conv[0].set_line(player, c_line)
          comm_start_convoy(player, conv[0], depot)
        }

      break
      case 3:
        local c_depot = my_tile(city1_road_depot)
        comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito

        if (current_cov>ch6_cov_lim2.a && current_cov<ch6_cov_lim2.b){
          local c_list = city1_halt_airport
          local sch_siz = c_list.len()
          local load = set_loading_capacity(6)
          local wait = set_waiting_time(9)
          local sched = schedule_x(wt_road, [])
          for(local i=0;i<sch_siz;i++){
            if (i==get_waiting_halt(7))
              sched.entries.append(schedule_entry_x(my_tile(c_list[i]), load, wait))
            else
              sched.entries.append(schedule_entry_x(my_tile(c_list[i]), 0, 0))
          }
          local c_line = comm_get_line(player, wt_road, sched, line2_name)

          local good_nr = 0 //Passengers
          local name = veh1_obj
          local cov_nr = d2_cnr  //Max convoys nr in depot
          local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
          for (local j = 0; j<cov_nr; j++){
            if (!comm_set_convoy(cov_nr, c_depot, name))
              return 0

            local conv = depot.get_convoy_list()
            if (conv.len()==0) continue
            conv[j].set_line(player, c_line)
          }
          local convoy = false
          local all = true
          comm_start_convoy(player, convoy, depot, all)
        }
        return null
        break;
      case 4:
        local c_depot = my_tile(city7_road_depot)
        if(pot[0]==0){

          local tool = command_x(tool_build_depot)
          tool.work(player, c_depot, sc_dep2)
          pot[0]=1
        }
        comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito
        //gui.add_message(""+current_cov+" -- "+ch6_cov_lim3.a +" -- "+ ch6_cov_lim3.b)
        if (current_cov>ch6_cov_lim3.a && current_cov<ch6_cov_lim3.b){
          local c_list = city7_halt
          local sch_siz = c_list.len()
          local load = set_loading_capacity(7)
          local wait = set_waiting_time(10)
          local sched = schedule_x(wt_road, [])
          for(local i=0;i<sch_siz;i++){
            if (i==get_waiting_halt(8))
              sched.entries.append(schedule_entry_x(my_tile(c_list[i]), load, wait))
            else
              sched.entries.append(schedule_entry_x(my_tile(c_list[i]), 0, 0))
          }
          local c_line = comm_get_line(player, wt_road, sched, line3_name)

          local good_nr = 0 //Passengers
          local name = veh1_obj
          local cov_nr = d3_cnr  //Max convoys nr in depot
          local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
          for (local j = 0; j<cov_nr; j++){
            if (!comm_set_convoy(cov_nr, c_depot, name))
              return 0

            local conv = depot.get_convoy_list()
            if (conv.len()==0) continue
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
        local t_list = [tool_remove_way, tool_build_way, tool_build_station, tool_build_depot]
        local wt_list = [gl_wt, 0] // enabled extensions building
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 2://Schedule
        local t_list = [-t_icon.plane, -t_icon.other, -tool_remover, -tool_make_stop_public]
        local wt_list = []
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 3://Schedule
        local t_list = [-t_icon.plane, -t_icon.other, -tool_remover, -tool_make_stop_public]
        local wt_list = [gl_wt]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 4:
        local t_list = [-t_icon.plane, -t_icon.other, -tool_remover, -tool_make_stop_public, tool_build_depot]
        local wt_list = [wt_road]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break
    }
    return result
  }

  function is_tool_allowed(pl, tool_id, wt){
    local gt_list = [ t_icon.tram ]


    if(step < 4){
        gt_list.push(t_icon.road)
    }
    foreach (id in gt_list){
      if(id == tool_id)
        return false
    }
    local result = true
    if(step < 4) {
      local t_list = [0] // 0 = all tools allowed
      local wt_list = [gl_wt, 0] // enabled extensions building
      local res = update_tools(t_list, tool_id, wt_list, wt)
      return res.result
    }
    else {
      local t_list = [0] // 0 = all tools allowed
      local wt_list = [gl_wt, wt_road]
      local res = update_tools(t_list, tool_id, wt_list, wt)
      return res.result
    }
  }

  //case 1:  //y--
  //case 2:  //x++
  //case 4:  //y++
  //case 8:  //x--
  function check_way(coora, coorb, wt, name_list, dir = false)
  {
    local sve_coord = coora
    local tile_start =  tile_x(coora.x, coora.y, coora.z)
    local way_start = tile_start.find_object(mo_way)
    local name = translate("Build here")
    if(way_start){
      way_start.mark()
      public_label(tile_start, name)
      local start_wt = way_start.get_waytype()
      if(start_wt != wt) {
        public_label(tile_start, name)
        return {c = coora, result = false}
      }
      local start_name = way_start.get_name()
      for(local j = 0;j<name_list.len();j++){
        if(start_name == name_list[j]) {
          break
        }
        if(j == name_list.len()-1) {
          public_label(tile_start, name)
          return {c = coora, result = false}
        }
      }

      local dir_start = dir? dir : way_start.get_dirs()
      switch (dir_start) {
        case 1:  //y--
          coora.y--
        break
        case 2:  //x++
          coora.x++
        break
        case 4:  //y++
          coora.y++
        break
        case 8:  //x--
          coora.x--
        break
        default:
          if(coora.x >= coorb.x && coora.y == coorb.y){
            coora.x--
            dir_start = 8
          }
          else if(coora.x <= coorb.x && coora.y == coorb.y){
            coora.x++
            dir_start = 2
          }

          else if(coora.x == coorb.x && coora.y >= coorb.y){
            coora.y--
            dir_start = 4
          }
          else if(coora.x == coorb.x && coora.y <= coorb.y){
            coora.y++
            dir_start = 1
          }

        break
      }

      local tile_test =  tile_x(coora.x, coora.y, coora.z)
      local way_test = tile_test.find_object(mo_way)
      if (!way_test){
        return {c = sve_coord, result = false}
      }

      way_start.unmark()
      tile_start.remove_object(player_x(1), mo_label)

      while(true){
        local current_dir = 0
        local tile = tile_x(coora.x, coora.y, coora.z)
        local way = tile.find_object(mo_way)
        if(way){
          way.unmark()
          local current_wt = way.get_waytype()
          if(current_wt != wt){
            way.mark()
            public_label(tile_start, name)
            return {c = coora, result = false}
          }

          local current_name = way.get_name()
          for(local j = 0;j<name_list.len();j++){
            if(current_name == name_list[j]) {
              break
            }
            if(j == name_list.len()-1) {
              tile_start.mark()
              return {c = coora, result = false}
            }
          }

          current_dir = way.get_dirs()
          local c_z = coora.z -1
          for(local j = c_z;j<=(c_z+2);j++){
            local c_test = square_x(coora.x,coora.y).get_tile_at_height(j)
            local is_tile = true
            try {
               c_test.is_valid()
            }
            catch(ev) {
              is_tile = false
              //gui.add_message("This faill")
            }
            if(is_tile && c_test.is_valid()){
              local t = tile_x(coora.x, coora.y, coora.z)
              local way = c_test.find_object(mo_way)
              if(t.is_bridge())c_test.z = coora.z

              //gui.add_message(""+coora.y+","+c_test.z+"  - "+way+"")
              if(way){
                coora.z = c_test.z
                break
              }
            }
          }

          if(coora.x==coorb.x && coora.y==coorb.y && coora.z==coorb.z){
            return {c = coora, result = true}
          }
          if ((current_dir==1)||(current_dir==2)||(current_dir==4)||(current_dir==8)){
            way.mark()
            public_label(tile_start, name)
            return {c = coora, result = false}
          }
          else if(dir_start == 1){ //y--
            switch (current_dir) {
              case 5:
                coora.y--
                dir_start = 1
              break
              case 6:
                coora.x++
                dir_start = 2
              break
              case 12:
                coora.x--
                dir_start = 8
              break
              default:
                coora.y--
              break
            }
          }
          else if(dir_start == 2){ //x++
            switch (current_dir) {
              case 9:
                coora.y--
                dir_start = 1
              break
              case 12:
                coora.y++
                dir_start = 4
              break
              default:
                coora.x++
              break
            }
          }
          else if(dir_start == 4){ //y++
            switch (current_dir) {
              case 3:
                coora.x++
                dir_start = 2
              break
              case 12:
                coora.x--
                dir_start = 8
              break
              case 9:
                coora.x--
                dir_start = 8
              break
              default:
                coora.y++
              break
            }
          }
          else if(dir_start == 8){ //x--
            switch (current_dir) {
              case 3:
                coora.y--
                dir_start = 1
              break
              case 6:
                coora.y++
                dir_start = 4
              break
              case 12:
                coora.y--
                dir_start = 12
              break
              default:
                coora.x--
              break
            }
          }
        }
        else {
          public_label(tile_start, name)
          return {c = coora, result = false}
        }
      }
    }
    else {
      public_label(tile_start, name)
      return {c = coora, result = false}
    }
  }

}        // END of class

// END OF FILE
