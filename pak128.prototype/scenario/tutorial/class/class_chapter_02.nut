/** @file class_chapter_02.nut
  * @brief Road traffic for bus and postal service
  */

/**
  * @brief class_chapter_02.nut
  * Road traffic for bus and postal service
  *
  *  Can NOT be used in network game !
  *
  */
class tutorial.chapter_02 extends basic_chapter
{
  chapter_name  = ch2_name
  chapter_coord = coord_chapter_2

  startcash     = 800000            // pl=0 startcash; 0=no reset
  stop_mark = false

  gltool = null
  gl_wt = wt_road
  gl_st = st_flat

  // Step 4 =====================================================================================
  ch2_cov_lim1 = {a = 0, b = 0}

  // Step 6 =====================================================================================
  ch2_cov_lim2 = {a = 0, b = 0}

  // Step 7 =====================================================================================
  ch2_cov_lim3 = {a = 0, b = 0}

  cty1 = {name = ""}

  // Step 1 =====================================================================================
  //Carretera para el deposito

  build_list = [] // tile list for build

  // Step 3 =====================================================================================
  //Parasdas de autobus
  sch_cov_correct = false

  // Step 4 =====================================================================================
  //Primer autobus
  line1_name = "ch2_l1"
  veh_obj = get_veh_ch2_st4()
  dep_cnr1 = null //auto started

  // Step 5 =====================================================================================
  // Primer puente
  t_list_brd = []

  // Step 6 =====================================================================================
  // Conectando el muelle

  line2_name = "ch2_l2"
  dep_cnr2 = null //auto started
  cov_nr = 0

  // Step 7 =====================================================================================
  // Conectando las ciudades

  cty2 = {name = ""}

  line3_name = "ch2_l3"
  dep_cnr3 = null //auto started

  veh_load = 0
  veh_wait = 0

  // Step 8 =====================================================================================
  price = 1200

  // define objects
  //----------------------------------------------------------------------------------
  sc_way_name = get_obj_ch2(1)
  sc_bridge_name = get_obj_ch2(2)
  sc_station_name = get_obj_ch2(3)
  sc_dep_name = null // depot name

  function start_chapter()  //Inicia solo una vez por capitulo
  {
    local lim_idx = cv_list[(persistent.chapter - 2)].idx
    ch2_cov_lim1 = {a = cv_lim[lim_idx].a, b = cv_lim[lim_idx].b}
    ch2_cov_lim2 = {a = cv_lim[lim_idx+1].a, b = cv_lim[lim_idx+1].b}
    ch2_cov_lim3 = {a = cv_lim[lim_idx+2].a, b = cv_lim[lim_idx+2].b}

    /// set depot name
    sc_dep_name = find_object("depot", wt_road).get_name()

    dep_cnr1 = get_dep_cov_nr(ch2_cov_lim1.a,ch2_cov_lim1.b)
    dep_cnr2 = get_dep_cov_nr(ch2_cov_lim2.a,ch2_cov_lim2.b)
    dep_cnr3 = get_dep_cov_nr(ch2_cov_lim3.a,ch2_cov_lim3.b)

    cty1.name = get_city_name(city1_tow)
    cty2.name = get_city_name(city2_tow)
    line1_name = "City " + cty1.name
    line2_name = line1_name + " dock/station"
    line3_name = cty1.name + " - " + cty2.name

    // look for streets next to the depot field
    if(this.step == 1) {
      local tile = my_tile(city1_road_depot)
      if ( tile_x(tile.x-1, tile.y, tile.z).get_way(wt_road) != null ) { build_list.append(tile_x(tile.x-1, tile.y, tile.z)) }
      if ( tile_x(tile.x+1, tile.y, tile.z).get_way(wt_road) != null ) { build_list.append(tile_x(tile.x+1, tile.y, tile.z)) }
      if ( tile_x(tile.x, tile.y-1, tile.z).get_way(wt_road) != null ) { build_list.append(tile_x(tile.x, tile.y-1, tile.z)) }
      if ( tile_x(tile.x, tile.y+1, tile.z).get_way(wt_road) != null ) { build_list.append(tile_x(tile.x, tile.y+1, tile.z)) }
      build_list.append(tile)
    }

    local pl = 0
    //Schedule list form current convoy
    if(this.step == 4){
      local c_dep = this.my_tile(city1_road_depot)
      local c_list = city1_halt_1
      start_sch_tmpsw(pl, c_dep, c_list)
    }
    else if(this.step == 6){
      local c_dep = this.my_tile(city1_road_depot)
      local c_list = city1_halt_2
      start_sch_tmpsw(pl, c_dep, c_list)
    }
    else if(this.step == 7){
      local c_dep = this.my_tile(city1_road_depot)
      local c_list = city2_halt_1
      start_sch_tmpsw(pl, c_dep, c_list)
    }

    // Starting tile list for bridge
    for(local i = bridge1_coords.a.y; i <= bridge1_coords.b.y; i++){
      t_list_brd.push(my_tile(coord(bridge1_coords.a.x, i)))
    }

  }

  function set_goal_text(text){

    if ( translate_objects_list.rawin("inspec") ) {
      if ( translate_objects_list.inspec != translate("Abfrage") ) {
        //gui.add_message("change language")
        translate_objects()
      }
    } else {
      gui.add_message("error language object key")
    }

    switch (this.step) {
      case 1:
        break
      case 2:
        break
      case 3:
        veh_load = set_loading_capacity(1)
        veh_wait = set_waiting_time(1)
        text.list = create_halt_list(city1_halt_1)
        break
      case 4:

        local tile = my_tile(city1_halt_1[get_waiting_halt(1)])
        text.stnam = (get_waiting_halt(1)+1) + ") "+tile.get_halt().get_name()+" ("+city1_halt_1[get_waiting_halt(1)].tostring()+")"

        text.list = create_schedule_list(city1_halt_1)
        text.nr = city1_halt_1.len()
        break
      case 5:
        text.bpos1 = bridge1_coords.a.href("("+bridge1_coords.a.tostring()+")")
        text.bpos2 = bridge1_coords.b.href("("+bridge1_coords.b.tostring()+")")

        // load file info/build_bridge_xx.txt
        text.bridge_info = get_info_file("bridge")

        break
      case 6:
        veh_load = set_loading_capacity(2)
        veh_wait = set_waiting_time(2)

        if (current_cov==(ch2_cov_lim2.a+1)){
          text = ttextfile("chapter_02/06_1-2.txt")
          text.tx = ttext("<em>[1/2]</em>")
        }
        else if (current_cov<=(dep_cnr2)){
          text = ttextfile("chapter_02/06_2-2.txt")
          text.tx = ttext("<em>[2/2]</em>")
        }
        text.list = create_schedule_list(city1_halt_2)

        // dock bus halt
        local tile = my_tile(city1_halt_2[get_waiting_halt(2)])
        text.stnam = ""+tile.get_halt().get_name()+" ("+city1_halt_2[get_waiting_halt(2)].tostring()+")"

        local halt = my_tile(city1_halt_2[get_waiting_halt(2)]).get_halt()
        text.line = get_line_name(halt)

        text.cir = cov_nr
        text.cov = dep_cnr2

        break
      case 7:
        veh_load = set_loading_capacity(3)
        veh_wait = set_waiting_time(3)

        if (!correct_cov){
          text = ttextfile("chapter_02/07_3-4.txt")
          text.tx = ttext("<em>[3/4]</em>")

          //local tile = my_tile(city2_halt_1[city2_halt_1.len()-1])
          //text.stnam = ""+city2_halt_1.len()+") "+tile.get_halt().get_name()+" ("+coord_to_string(tile)+")"

          //text.list = create_halt_list(city2_halt_1)
          //text.nr = city2_halt_1.len()
        }
        else if (pot[0]==0){
          text = ttextfile("chapter_02/07_1-4.txt")
          text.tx = ttext("<em>[1/4]</em>")

          text.list = create_halt_list(city2_halt_1.slice(1))
        }
        else if (pot[2]==0){
          text = ttextfile("chapter_02/07_2-4.txt")
          text.tx = ttext("<em>[2/4]</em>")

          if (r_way.r)
            text.cbor = "<em>"+translate("Ok")+"</em>"
          else
            text.cbor = coord(r_way.c.x, r_way.c.y).href("("+r_way.c.tostring()+")")
        }
        else if (pot[3]==0){
          text = ttextfile("chapter_02/07_3-4.txt")
          text.tx = ttext("<em>[3/4]</em>")

          local tile = my_tile(city2_halt_1[get_waiting_halt(3)])
          text.stnam = ""+tile.get_halt().get_name()+" ("+coord_to_string(tile)+")"

          text.list = create_schedule_list(city2_halt_1)
          text.nr = city2_halt_1.len()
        }
        else if (pot[4]==0){
          text = ttextfile("chapter_02/07_4-4.txt")
          text.tx = ttext("<em>[4/4]</em>")

          local conv = cov_save[current_cov-1]
          if(is_cov_valid(conv)){
            local pos = conv.get_pos()
            text.covpos =   pos.href(conv.get_name()+" ("+pos.tostring()+")")
          }
          else{
            text.covpos = "null"
          }
        }

        local t = coord(way1_coords.a.x, way1_coords.a.y)
        text.pt1 = t.href("("+t.tostring()+")")
        t = coord(way1_coords.b.x, way1_coords.b.y)
        text.pt2 = t.href("("+t.tostring()+")")
        break

      case 8:
        local st_halt1 = my_tile(city1_halt_2[city1_halt_2.len()-1]).get_halt()
        text.st1 = city1_halt_2[city1_halt_2.len()-1].href(st_halt1.get_name()+" ("+city1_halt_2[city1_halt_2.len()-1].tostring()+")")
        // toolbar icon make_stop_publuc tooltip
        local factor = settings.get_make_public_months()
        local tool_text = translate_objects_list.public_stop
        local idx = tool_text.find("%i")
        local t1 = tool_text.slice(0, idx)
        local t2 = tool_text.slice(idx+2)
        tool_text = t1 + factor + t2
        text.public_stop = tool_text
        break
    }

    // road menu step 1, 2, 4, 5 and 7
    local steps = [1, 2, 4, 5, 7]
    if ( steps.find(this.step) != null ) {
      // set image for button by different in paksets
      text.img_road_menu = get_gui_img("road_menu")
      text.toolbar_road = translate_objects_list.tools_road
    }

    steps.clear()
    // road halt menu step 3 and 7
    steps = [3, 7]
    if ( steps.find(this.step) != null ) {
      // set image for button by different in paksets
      text.img_road_menu = get_gui_img("road_halts")
      text.toolbar_halt = translate_objects_list.tools_road_stations
    }

    steps.clear()
    // depot coord step 1, 2, 4, 6 and 7
    steps = [1, 2, 4, 6, 7]
    if ( steps.find(this.step) != null ) {
      text.dep = city1_road_depot.href("("+city1_road_depot.tostring()+")")
    }

    steps.clear()
    // veh load and wait time set to steps 4, 6 and 7
    steps = [4, 6, 7]
    if ( steps.find(this.step) != null ) {
      text.load = veh_load
      text.wait = get_wait_time_text(veh_wait)
      text.bus1 = translate(veh_obj)
    }

    text.name = city1_tow.href(cty1.name.tostring())
    text.name2 = city2_tow.href(cty2.name.tostring())
    text.tool1 = translate_objects_list.inspec

    return text
  }

  function is_chapter_completed(pl) {
    if (pl != 0) return 0   // only human player = 0

    save_glsw()
    save_pot()

    persistent.ch_max_steps = 8
    local chapter_step = persistent.step
    persistent.ch_max_sub_steps = 0 // count all sub steps
    persistent.ch_sub_step = 0  // actual sub step

    switch (this.step) {
      case 1:
        local next_mark = true
        local tile = my_tile(city1_road_depot)
        try {
           next_mark = delay_mark_tile_list(build_list)
        }
        catch(ev) {
          return 0
        }

        //Para la carretera
        //local tile = my_tile(city1_road_depot)
        local way = tile.find_object(mo_way)
        local label = tile.find_object(mo_label)
        if (!way && !label){
          local t1 = command_x(tool_remover)
          local err1 = t1.work(player_x(pl), tile, "")
          label_x.create(city1_road_depot, pl_unown, translate("Place the Road here!."))
          return 0
        }
        else if ((way)&&(way.get_owner().nr==pl)){
          if(next_mark) {
            next_mark = delay_mark_tile_list(build_list, true)
            tile.remove_object(player_x(1), mo_label)
            this.next_step()
          }
        }

        //return 0
        break;
      case 2:
        local next_mark = true
        local c_list1 = [my_tile(city1_road_depot)]
        local stop_mark = true
        try {
           next_mark = delay_mark_tile(c_list1)
        }
        catch(ev) {
          return 0
        }
        //Para el deposito
        local tile = my_tile(city1_road_depot)
        local waydepo = tile.find_object(mo_way)
        if (!tile.find_object(mo_depot_road)){
          label_x.create(city1_road_depot, pl_unown, translate("Build a Depot here!."))
        }
        else if (next_mark){
          next_mark = delay_mark_tile(c_list1, stop_mark)
          tile.remove_object(player_x(1), mo_label)
          waydepo.unmark()
          this.next_step()
        }
        //return 0
        break;
      case 3:
        if (pot[0]==0){
          //Marca tiles para evitar construccion de objetos
          local del = false
          local pl_nr = 1
          local text = "X"
          pot[0]=1
        }
        local c_list = city1_halt_1
        local name =  translate("Place Stop here!.")
        local load = good_alias.passa
        local all_stop = is_stop_building(c_list, name, load)

        if (all_stop && pot[0]==1){
          this.next_step()
        }
        //return 10+percentage
        break
      case 4:
        local conv = current_cov > 0 ? cov_save[current_cov-1] :  null
        local cov_valid = is_cov_valid(conv)
        if(cov_valid){
          pot[0] = 1
        }
        local c_list1 = [my_tile(city1_road_depot)]
        if (pot[0] == 0){
          local next_mark = true
          try {
             next_mark = delay_mark_tile(c_list1)
          }
          catch(ev) {
            return 0
          }
        }
        else if (pot[0] == 1 && pot[1] ==0){
          local next_mark = true
          local stop_mark = true
          try {
             next_mark = delay_mark_tile(c_list1, stop_mark)
          }
          catch(ev) {
            return 0
          }
          pot[1] = 1
        }

        if (pot[1] == 1 ){
          local c_dep = this.my_tile(city1_road_depot)
          local line_name = line1_name //"Test 1"
          set_convoy_schedule(pl, c_dep, gl_wt, line_name)

          local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
          local cov_list = depot.get_convoy_list()    //Lista de vehiculos en el deposito
          local convoy = convoy_x(gcov_id)
          if (cov_list.len()>=1){
            convoy = cov_list[0]
          }
          local all_result = checks_convoy_schedule(convoy, pl)
          sch_cov_correct = all_result.res == null ? true : false

          if(!all_result.cov ){
            reset_glsw()
          }

        }

        if (cov_valid && current_cov == ch2_cov_lim1.b){
          pot[2]=1
        }

        if (pot[2] == 1 ){
          this.next_step()
          //Crear cuadro label
          local opt = 0
          label_bord(bridge1_limit.a, bridge1_limit.b, opt, false, "X")
          //Elimina cuadro label
          label_bord(change1_city1_limit1.a, change1_city1_limit1.b, opt, true, "X")
        }

        //return 50
        break
      case 5:
        local t_label = my_tile(bridge1_coords.a)
        local label = t_label.find_object(mo_label)

        local next_mark = true
        if (pot[0] == 0){
          if(!label)
            label_x.create(bridge1_coords.a, pl_unown, get_label_text(2))
            label_x.create(bridge1_coords.b, pl_unown, "")
          try {
             next_mark = delay_mark_tile(t_list_brd)
          }
          catch(ev) {
            return 0
          }
        }
        else if (pot[0] == 1 && pot[1] ==0){
          stop_mark = true
          try {
             next_mark = delay_mark_tile(t_list_brd, stop_mark)
          }
          catch(ev) {
            return 0
          }
          pot[1] = 1
        }
        if (pot[1]==1) {
          //Comprueba la conexion de la via
          local tx = 0
          local ty = 1
          local tile = square_x(bridge1_coords.b.x+tx, bridge1_coords.b.y+ty).get_ground_tile()
          // todo check bridge direction

          local coora = coord3d(bridge1_coords.a.x, bridge1_coords.a.y, bridge1_coords.a.z)
          local coorb = coord3d(tile.x, tile.y, tile.z)
          local dir = bridge1_coords.dir
          local obj = false
          local r_way = get_fullway(coora, coorb, dir, obj)
          if (r_way.r){
            t_label.remove_object(player_x(1), mo_label)
            t_label = my_tile(bridge1_coords.b)
            t_label.remove_object(player_x(1), mo_label)
            this.next_step()
            //Crear cuadro label
            local opt = 0
            label_bord(c_dock1_limit.a, c_dock1_limit.b, opt, false, "X")
            //Elimina cuadro label
            label_bord(change2_city1_limit1.a, change2_city1_limit1.b, opt, true, "X")
          }
        }
        //return 65
        break

      case 6:
        persistent.ch_max_sub_steps = 2

        local c_dep = this.my_tile(city1_road_depot)
        local line_name = line2_name //"Test 2"
        set_convoy_schedule(pl, c_dep, gl_wt, line_name)

        local id_start = 1
        local id_end = 3
        cov_nr = get_convoy_number_exp(city1_halt_2[0], c_dep, id_start, id_end)

        local convoy = convoy_x(gcov_id)
        local all_result = checks_convoy_schedule(convoy, pl)
        sch_cov_correct = all_result.res == null ? true : false

        if(!all_result.cov ){
          reset_glsw()
        }

        //gui.add_message("current_cov "+current_cov+" cov_nr "+cov_nr+" all_result "+all_result+" all_result.cov "+all_result.cov)
        if ( cov_nr>=1 ) {
          persistent.ch_sub_step = 1  // sub step finish
        }

        if (current_cov==ch2_cov_lim2.b){
          this.next_step()
          //Elimina cuadro label
          local opt = 0
          label_bord(city1_limit1.a, city1_limit1.b, opt, true, "X")
          label_bord(bridge1_limit.a, bridge1_limit.b, opt, true, "X")
          label_bord(c_dock1_limit.a, c_dock1_limit.b, opt, true, "X")
          //Creea un cuadro label
          label_bord(city2_limit1.a, city2_limit1.b, opt, false, "X")
        }
        //return 70
        break

      case 7:
        persistent.ch_max_sub_steps = 3

        if (pot[0]==0){

          local c_list = city2_halt_1
          local name = get_label_text(1)
          local load = good_alias.passa
          local all_stop = is_stop_building(c_list, name, load)

          if (all_stop) {
            pot[0]=1
            reset_glsw()
          }
        }

        else if (pot[0]==1 && pot[1]==0){
          //Elimina cuadro label
          local opt = 0
          label_bord(city2_limit1.a, city2_limit1.b, opt, true, "X")

          //Creea un cuadro label
          opt = 0
          label_bord(c_way_limit1.a, c_way_limit1.b, opt, false, "X")

          //Limpia las carreteras
          opt = 2
          label_bord(c_way_limit1.a, c_way_limit1.b, opt, true, "X", gl_wt)

          pot[1]=1
        }

        else if (pot[1]==1 && pot[2]==0){
          persistent.ch_sub_step = 1  // sub step finish
          //Comprueba la conexion de la via
          local coora = coord3d(way1_coords.a.x,way1_coords.a.y,way1_coords.a.z)
          local coorb = coord3d(way1_coords.b.x,way1_coords.b.y,way1_coords.b.z)
          local dir = way1_coords.dir
          local obj = false
          local r_way = get_fullway(coora, coorb, dir, obj)

          //check_way_last_tile
          //test_select_way(my_tile(way1_coords.a), my_tile(way1_coords.b), wt_road)


          //Para marcar inicio y fin de la via
          local waya = tile_x(coora.x,coora.y,coora.z).find_object(mo_way)
          local wayb = tile_x(coorb.x,coorb.y,coorb.z).find_object(mo_way)
          if (waya) waya.mark()
          if (wayb) wayb.mark()

          if (r_way.r){
            //Para desmarcar inicio y fin de la carretera
            waya.unmark()
            wayb.unmark()

            //way1_coords.a.remove_object(player_x(1), mo_label)
            //way1_coords.b.remove_object(player_x(1), mo_label)

            //Elimina cuadro label
            local opt = 0
            label_bord(c_way_limit1.a, c_way_limit1.b, opt, true, "X")

            //Creea un cuadro label
            label_bord(city1_limit1.a, city1_limit1.b, opt, false, "X")
            label_bord(city2_limit1.a, city2_limit1.b, opt, false, "X")

            pot[2]=1
          }
        }

        else if (pot[2]==1) {
          persistent.ch_sub_step = 2  // sub step finish
          local c_dep = this.my_tile(city1_road_depot)
          local line_name = line3_name //"Test 3"
          set_convoy_schedule(pl, c_dep, gl_wt, line_name)

          local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
          local cov_list = depot.get_convoy_list()    //Lista de vehiculos en el deposito
          local convoy = convoy_x(gcov_id)
          if (cov_list.len()>=1){
            convoy = cov_list[0]
          }
          local all_result = checks_convoy_schedule(convoy, pl)
          sch_cov_correct = all_result.res == null ? true : false

          if (current_cov == ch2_cov_lim3.b){
              pot[3]=1
          }

          if (pot[3]==1 && pot[4]==0) {
            local conv = cov_save[current_cov-1]
            local cov_valid = is_cov_valid(conv)

            if (cov_valid && current_cov == ch2_cov_lim3.b){
              if (conv.is_followed()) {
                pot[4] = 1
              }
            }
            else{
              backward_pot(3)
              break
            }
          }
          else if (pot[4]==1 && pot[5]==0){
              //Desmarca la via en la parada
              local way_mark = my_tile(line_connect_halt).find_object(mo_way)
              way_mark.unmark()

              //Elimina cuadro label
              local opt = 0
              label_bord(city1_limit1.a, city1_limit1.b, opt, true, "X")
              label_bord(city2_limit1.a, city2_limit1.b, opt, true, "X")

              label_bord(bridge1_limit.a, bridge1_limit.b, opt, false, "X")
              this.next_step()
          }
        }
        //return 95
        break

      case 8:
        if (pot[0]==0){
          local halt1 = my_tile(city1_halt_2[city1_halt_2.len()-1]).get_halt()
          if (pl != halt1.get_owner().nr && glsw[0] == 0)
            glsw[0]=1
          if (pl != halt1.get_owner().nr)
            glsw[1]=1

          if (glsw[0]==1 && glsw[1]==1){
            local opt = 0
            label_bord(bridge1_limit.a, bridge1_limit.b, opt, true, "X")
            this.next_step()
          }
        }

        //return 98
        break
      case 9:
        //this.step=1
        persistent.step=1
        persistent.status.step = 1

        //return 100
        break
    }
    local percentage = chapter_percentage(persistent.ch_max_steps, chapter_step, persistent.ch_max_sub_steps, persistent.ch_sub_step)
    return percentage
  }

  function is_work_allowed_here(pl, tool_id, name, pos, tool) {
    local t = tile_x(pos.x, pos.y, pos.z)
    //local slope = t.get_slope()
    //local way = t.find_object(mo_way)
    //local bridge = t.find_object(mo_bridge)
    //local build = t.find_object(mo_building)
    local label = t.find_object(mo_label)
    //local car = t.find_object(mo_car)
    //local ribi = 0
    /*if (way){
      if ( tool_id != tool_build_bridge )
        ribi = way.get_dirs()
      if ( !t.has_way(gl_wt) )
        ribi = 0
    }*/
    //local st_c = coord(pos.x,pos.y)
    local result = null // null is equivalent to 'allowed'
    result = get_tile_message(1, pos) //translate("Action not allowed")+" ("+pos.tostring()+")."
    gltool = tool_id
    switch (this.step) {
      //Construye un tramo de carretera
      case 1:
        if ( tool_id == tool_build_way ) {

          // check selected way
          local s = check_select_way(name, wt_road)
          if ( s != null ) return s

          //local way_desc =  way_desc_x.get_available_ways(gl_wt, gl_st)
          local str_c = tile_x(tool.start_pos.x, tool.start_pos.y, tool.start_pos.z)
          //local str_way = str_c.is_valid () ? t.find_object(mo_way) : null
          local str_way = world.is_coord_valid(str_c)? tile_x(str_c.x, str_c.y, str_c.z).find_object(mo_way) : null
          //foreach ( desc in way_desc ) {
            //if ( desc.get_name() == name ) {
              for ( local i = 0; i < build_list.len()-1; i++ ) {
                if ( ( pos.x == build_list[i].x && pos.y == build_list[i].y ) || ( pos.x == city1_road_depot.x && pos.y == city1_road_depot.y ) ) {
                  if(cursor_control(build_list[i])){
                    return null
                  }
                  if( !str_way ){
                    return null
                  }
                }
              }
              return get_tile_message(2, city1_road_depot)//translate("Connect the road here")+" ("+city1_road_depot.tostring()+")."
            //}
          //}
        }
        break;
      //Construye un deposito de carreteras
      case 2:
        if ((pos.x==city1_road_depot.x)&&(pos.y==city1_road_depot.y)){
          if (my_tile(city1_road_depot).find_object(mo_way)){
            if (tool_id==tool_build_depot) return null
          }
          else {
            this.backward_step()
            return translate("You must first build a stretch of road")+" ("+pos.x+","+pos.y+")."
          }
        }
        else if (tool_id==tool_build_depot)
          return result=translate("You must build the depot in")+" ("+city1_road_depot.tostring()+")."

        break;
      //Construye las paradas de autobus
      case 3:

        if (pos.x == city1_road_depot.x && pos.y == city1_road_depot.y )
          return format(translate("You must build the %d stops first."), city1_halt_1.len())

        if ( pos.x > city1_limit1.a.x && pos.y > city1_limit1.a.y && pos.x < city1_limit1.b.x && pos.y < city1_limit1.b.y ) {
          //Permite construir paradas
          if ( tool_id == tool_build_station ) {
            // check selected halt accept passenger
            local s = check_select_station(name, wt_road, good_alias.passa)
            if ( s != null ) { return s }

            return build_stop(city1_halt_1, pos)
          }

          //Permite eliminar paradas
          if (tool_id==tool_remover){
            for( local j = 0 ; j < city1_halt_1.len(); j++ ) {
              if (city1_halt_1[j] != null){
                local stop = tile_x(city1_halt_1[j].x, city1_halt_1[j].y,0).find_object(mo_building)
                if ( pos.x == ccity1_halt_1_list[j].x && pos.y == city1_halt_1[j].y && stop ) {
                  way.mark()
                  return null
                }
              }
            }
            return translate("You can only delete the stops.")
          }
        }
        else if ( tool_id == tool_build_station )
          return result = format(translate("Stops should be built in [%s]"), cty1.name)+" ("+city1_tow.tostring()+")."

        break;
      //Enrutar el primer autobus
      case 4:
        if (tool_id==tool_build_station)
          return get_data_message(2, city1_halt_1.len()) //format(translate("Only %d stops are necessary."), city1_halt_1.len())

        //Enrutar vehiculo
        if ((pos.x == city1_road_depot.x && pos.y == city1_road_depot.y)){
          if(tool_id==4096){
            pot[0] = 1
            return null
          }
        }
        if (tool_id==4108) {
          return is_stop_allowed(city1_road_depot, city1_halt_1, pos)
        }

        break;
      //Construye un puente
      case 5:
        if (tool_id==tool_build_bridge || tool_id==tool_build_way) {

          if ((pos.x>=c_bridge1_limit1.a.x)&&(pos.y>=c_bridge1_limit1.a.y)&&(pos.x<=c_bridge1_limit1.b.x)&&(pos.y<=c_bridge1_limit1.b.y)){
            pot[0] = 1
            result=null
          }
          else
            return translate("You must build the bridge here")+" ("+bridge1_coords.a.tostring()+")."
        }
        break;
      //Segundo Autobus
      case 6:
        //Enrutar vehiculo
        if (pot[0]==0){
          if ((tool_id==4096)&&(pos.x == city1_road_depot.x && pos.y == city1_road_depot.y)){
            stop_mark = true
            return null
          }
          if (tool_id==4108) {
            stop_mark = true
            return is_stop_allowed(city1_road_depot, city1_halt_2, pos)
          }
        }
        break;
      case 7:
        // Construye las paradas
        if (pot[0]==0){
          if ((tool_id==tool_build_station)){
            if (pos.x>city2_limit1.a.x && pos.y>city2_limit1.a.y && pos.x<city2_limit1.b.x && pos.y<city2_limit1.b.y){

              // check selected halt accept passenger
              local s = check_select_station(name, wt_road, good_alias.passa)
              if ( s != null ) return s

              return build_stop(city2_halt_1, pos)
            }

            else
              return format(translate("You must build a stop in [%s] first"), cty2.name)+" ("+city2_tow.tostring()+")."
          }
          //Permite eliminar paradas
          if (tool_id==tool_remover){
            for(local j=0;j<city2_halt_1.len();j++){
              if (city2_halt_1[j] != null){
                local stop = my_tile(city2_halt_1[j]).find_object(mo_building)
                if (pos.x==city2_halt_1[j].x&&pos.y==city2_halt_1[j].y&&stop){
                  way.mark()
                  return null
                }
              }
            }
            return translate("You can only delete the stops.")
          }
        }
        //Para construir la carretera
        else if (pot[1]==1 && pot[2]==0){
          if ( (pos.x>=c_way_limit1.a.x) && (pos.y >= c_way_limit1.a.y) && (pos.x <= c_way_limit1.b.x) && (pos.y <= c_way_limit1.b.y) ) {
            if( (pos.x == way1_coords.a.x) && (pos.y == way1_coords.a.y) ) {
              if (tool_id == tool_remover || tool_id == tool_remove_way)
                return result
              else if (tool_id==tool_build_way)
                return null
            }
            else
              return all_control(result, gl_wt, gl_st, tool_id, pos, r_way.c, name)
          }

        }
        //Para enrutar vehiculos
        else if (pot[2]==1 && pot[3]==0){
          if (tool_id==4108){
            //Paradas de la primera ciudad
            return is_stop_allowed(city1_road_depot, city2_halt_1, pos)
          }
        }
        break;

      //Paradas publicas
      case 8:
        if (tool_id==4128) {
          if (pos.x==city1_halt_2[city1_halt_2.len()-1].x && pos.y==city1_halt_2[city1_halt_2.len()-1].y && glsw[0] > 0){
              return format(translate("Select station No.%d"),2)+" ("+pub_st2.tostring()+")."
          } else { return null }
        }
        break;
    }
    if (tool_id==4096){
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
    if ( (pl == 0) && (schedule.waytype != gl_wt) )
      result = get_message(3)
    local nr = schedule.entries.len()
    switch (this.step) {
      case 4:
        local selc = get_waiting_halt(1)
        local load = set_loading_capacity(1)
        local time = set_waiting_time(1)
        local c_list = city1_halt_1
        result = compare_schedule(result, pl, schedule, selc, load, time, c_list, true)
        if(result == null){
          local line_name = line1_name //"Test 1"
          update_convoy_schedule(pl, gl_wt, line_name, schedule)
        }

        return result
      break
      case 6:
        local selc = get_waiting_halt(2)
        local load = set_loading_capacity(2)
        local time = set_waiting_time(2)
        local c_list = city1_halt_2
        result = compare_schedule(result, pl, schedule, selc, load, time, c_list, true)
        if(result == null){
          local line_name = line2_name //"Test 2"
          update_convoy_schedule(pl, gl_wt, line_name, schedule)
        }
        return result
      break
      case 7:
        local selc = get_waiting_halt(3)
        local load = set_loading_capacity(3)
        local time = set_waiting_time(3)
        local c_list = city2_halt_1
        result = compare_schedule(result, pl, schedule, selc, load, time, c_list, true)
        if(result == null){
          local line_name = line3_name //"Test 3"
          update_convoy_schedule(pl, gl_wt, line_name, schedule)
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
      case 4:
        if (current_cov>ch2_cov_lim1.a && current_cov<ch2_cov_lim1.b){
          local cov = 1
          local veh = 1
          local good_list = [good_desc_x (good_alias.passa).get_catg_index()]    //Passengers
          local name = veh_obj
          local st_tile = 1
          result = is_convoy_correct(depot,cov,veh,good_list,name, st_tile)

          if (result!=null){
            reset_tmpsw()
            return bus_result_message(result, translate(name), veh, cov)
          }
          local selc = get_waiting_halt(1)
          local load = veh_load
          local time = veh_wait
          local c_list = city1_halt_1
          local siz = c_list.len()
          result = compare_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
          if(result == null)
            reset_tmpsw()
          return result
        }
      break
      case 6:
        if (current_cov>ch2_cov_lim2.a && current_cov<ch2_cov_lim2.b){
          local cov_list = depot.get_convoy_list()
          local cov = cov_list.len()
          local veh = 1
          local good_list = [good_desc_x (good_alias.passa).get_catg_index()]    //Passengers
          local name = veh_obj
          local st_tile = 1
          result = is_convoy_correct(depot, cov, veh, good_list, name, st_tile)
          if (result!=null){
            reset_tmpsw()
            return bus_result_message(result, translate(name), veh, cov)
          }

          local selc = get_waiting_halt(2)
          local load = veh_load
          local time = veh_wait
          local c_list = city1_halt_2
          local siz = c_list.len()
          local line = true
          result = compare_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz, line)
          if(result == null)
            reset_tmpsw()
          return result
        }
      break
      case 7:
        if (current_cov>ch2_cov_lim3.a && current_cov<ch2_cov_lim3.b){
          local cov = 1
          local veh = 1
          local good_list = [good_desc_x (good_alias.passa).get_catg_index()]    //Passengers
          local name = veh_obj
          local st_tile = 1
          result = is_convoy_correct(depot,cov,veh,good_list,name, st_tile)
          if (result!=null){
            reset_tmpsw()
            return bus_result_message(result, translate(name), veh, cov)
          }

          local load = veh_load
          local time = veh_wait
          local c_list = city2_halt_1
          local siz = c_list.len()
          local selc = get_waiting_halt(3)
          result = compare_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
          if(result == null)
            reset_tmpsw()
          return result
        }
      break
      case 1:
      break
    }
    return get_message(3) //translate("It is not allowed to start vehicles.")
  }

  function script_text()
  {
    if (!correct_cov)
      return 0
    local pl = 0
    switch (this.step) {
      case 1:
        local tile = my_tile(city1_road_depot)
        local list = [tile]
        delay_mark_tile(list, true)
        //Para la carretera
        local t1 = command_x(tool_remover)
        local err1 = t1.work(player_x(pl), tile, "")

        local btile = null
        if ( tile_x(tile.x-1, tile.y, tile.z).get_way(wt_road) != null ) { btile = tile_x(tile.x-1, tile.y, tile.z) }
        else if ( tile_x(tile.x+1, tile.y, tile.z).get_way(wt_road) != null ) { btile = tile_x(tile.x+1, tile.y, tile.z) }
        else if ( tile_x(tile.x, tile.y-1, tile.z).get_way(wt_road) != null ) { btile = tile_x(tile.x, tile.y-1, tile.z) }
        else if ( tile_x(tile.x, tile.y+1, tile.z).get_way(wt_road) != null ) { btile = tile_x(tile.x, tile.y+1, tile.z) }

        local t2 = command_x(tool_build_way)
        local err2 = t2.work(player_x(pl), btile, tile, sc_way_name)
        return null
        break;
      case 2:
        local list = [my_tile(city1_road_depot)]
        delay_mark_tile(list, true)
        //Para el deposito
        local t = command_x(tool_build_depot)
        local err = t.work(player_x(pl), my_tile(city1_road_depot), sc_dep_name)
        return null
        break;
      case 3:

        for(local j=0;j<city1_halt_1.len();j++){
          local t = my_tile(city1_halt_1[j])
          local way = t.find_object(mo_way)
          t.remove_object(player_x(1), mo_label)
          local tool = command_x(tool_build_station)
          local err = tool.work(player_x(pl), t, sc_station_name)
          t.unmark()
          if (way.is_marked()){
            way.unmark()
          }
        }
        this.step_nr(4)
        return null
        break
      case 4:
        local list = [my_tile(city1_road_depot)]
        delay_mark_tile(list, true)
        if (pot[0] == 0){
          pot[0] = 1
        }

        if (current_cov>ch2_cov_lim1.a && current_cov<ch2_cov_lim1.b){
          local player = player_x(pl)
          local c_depot = my_tile(city1_road_depot)
          comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito

          local c_list = city1_halt_1
          local sched = schedule_x(gl_wt, [])
          local load = veh_load
          local wait = veh_wait
          local sch_siz = c_list.len()
          for(local j=0;j<sch_siz;j++){
            if (j==get_waiting_halt(1))
              sched.entries.append(schedule_entry_x(my_tile(c_list[j]), load, wait))
            else
              sched.entries.append(schedule_entry_x(my_tile(c_list[j]), 0, 0))
          }
          local c_line = comm_get_line(player, gl_wt, sched, line1_name)

          local good_nr = 0 //Passengers
          local name = veh_obj
          local cov_nr = 0  //Max convoys nr in depot
          if (!comm_set_convoy(cov_nr, c_depot, name))
            return 0

          local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
          local conv = depot.get_convoy_list()
          conv[0].set_line(player, c_line)
          comm_start_convoy(player, conv[0], depot)
        }
        return null
        break
      case 5:
        if (pot[0] == 0){
          pot[0] = 1
        }
        if (pot[0] == 1){
          local t_start = my_tile(bridge1_coords.a)
          local t_end = my_tile(bridge1_coords.b)
          if ( !t_start.find_object(mo_bridge) ) {
            t_start.remove_object(player_x(1), mo_label)
            t_end.remove_object(player_x(1), mo_label)
            local t = command_x(tool_build_bridge)
            local err = t.work(player_x(pl), t_start, t_end, sc_bridge_name)
          }
        }

        return null
        break

      case 6:
        local player = player_x(pl)
        local c_depot = my_tile(city1_road_depot)
        comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito

        if (current_cov>ch2_cov_lim2.a && current_cov<ch2_cov_lim2.b){
          local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
          local c_list = city1_halt_2
          local sch_siz = c_list.len()
          local load = veh_load
          local time = veh_wait
          local sched = schedule_x(gl_wt, [])
          for(local i=0;i<sch_siz;i++){
            if (i==get_waiting_halt(2))
              sched.entries.append(schedule_entry_x(my_tile(c_list[i]), load, time))
            else
              sched.entries.append(schedule_entry_x(my_tile(c_list[i]), 0, 0))
          }
          local c_line = comm_get_line(player, gl_wt, sched, line2_name)

          local good_nr = 0 //Passengers
          local name = veh_obj
          local cov_nr = 0  //Max convoys nr in depot
          for (local j = current_cov; j>ch2_cov_lim2.a && j<ch2_cov_lim2.b && correct_cov; j++){
            if (!comm_set_convoy(cov_nr, c_depot, name))
              return 0

            local conv = depot.get_convoy_list()
            if (conv.len()==0) continue
            conv[0].set_line(player, c_line)
            comm_start_convoy(player, conv[0], depot)
          }
        }
        return null
        break

      case 7:
        if (pot[1]==0){
          for(local j=0;j<city2_halt_1.len();j++){
            local t = my_tile(city2_halt_1[j])
            local way = t.find_object(mo_way)
            t.remove_object(player_x(1), mo_label)
            local tool = command_x(tool_build_station)
            local err = tool.work(player_x(pl), t, sc_station_name)
            t.unmark()
            if (way.is_marked()){
              way.unmark()
            }
          }
        }
        if (pot[2]==0){
          local t = command_x(tool_build_way)
          local err = t.work(player_x(pl), way1_coords.a, way1_coords.b, sc_way_name)
        }
        if (current_cov>ch2_cov_lim3.a && current_cov<ch2_cov_lim3.b){
          local player = player_x(pl)
          local c_depot = my_tile(city1_road_depot)
          comm_destroy_convoy(pl, c_depot) // Limpia los vehiculos del deposito

          local sched = schedule_x(gl_wt, [])
          local load = veh_load
          local wait = veh_wait
          local c_list = city2_halt_1
          local sch_siz = c_list.len()
          for(local j=0;j<sch_siz;j++){
            if (j==get_waiting_halt(3))
              sched.entries.append(schedule_entry_x(my_tile(c_list[j]), load, wait))
            else
              sched.entries.append(schedule_entry_x(my_tile(c_list[j]), 0, 0))
          }
          local c_line = comm_get_line(player, gl_wt, sched, line3_name)

          local good_nr = 0 //Passengers
          local name = veh_obj
          local cov_nr = 0  //Max convoys nr in depot
          if (!comm_set_convoy(cov_nr, c_depot, name))
            return 0

          local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
          local conv = depot.get_convoy_list()
          conv[0].set_line(player, c_line)
          comm_start_convoy(player, conv[0], depot)
        }
        if (pot[4] == 0){
          local conv = cov_save[current_cov-1]
          local cov_valid = is_cov_valid(conv)
          if (cov_valid && current_cov == ch2_cov_lim3.b){
            conv.set_followed()
          }
        }
        return null
        break

      case 8:
        if (pot[0]==0){
          local t = command_x(tool_make_stop_public)
          t.work(player_x(pl), my_tile(city1_halt_2[city1_halt_2.len()-1]), "")
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
        local t_list = [tool_build_way]
        local wt_list = [gl_wt]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 2:
        local t_list = [tool_build_depot]
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

      case 4: //Schedule
        local t_list = [-tool_remover, -t_icon.road]
        local wt_list = [0]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break
      case 5:
        local t_list = [-tool_remover, tool_build_bridge]
        local wt_list = [gl_wt]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 6: //Schedule
        local t_list = [-tool_remover, -t_icon.road]
        local wt_list = [0]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 7:

        local t_list = [tool_build_station, tool_build_way, tool_remove_way]
        local wt_list = [gl_wt]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 8: //Make Stop public
        local t_list = [-tool_remover, -t_icon.road]
        local wt_list = [-1]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break
    }
    return result
  }

  function is_tool_allowed(pl, tool_id, wt){
    local result = true
    if(step < 8) {
      local t_list = [-t_icon.tram, -tool_make_stop_public, 0] // 0 = all tools allowed
      local wt_list = [gl_wt]
      local res = update_tools(t_list, tool_id, wt_list, wt)
      return res.result
    }
    else {
      local t_list = [-t_icon.tram, 0] // 0 = all tools allowed
      local wt_list = [gl_wt, -1]
      local res = update_tools(t_list, tool_id, wt_list, wt)
      return res.result
    }
  }

  function sch_conv_list(pl, coord) {
    local c_dep = this.my_tile(coord)
    local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
    local cov_list = depot.get_convoy_list()    //Lista de vehiculos en el deposito
    local result = 0
    sch_list=false
    foreach(cov in cov_list) {
      try {
        cov.get_pos()
      }
      catch(ev) {
        continue
      }
      local sch = null
      local line = cov.get_line()
      if (line)
        sch = line.get_schedule()

      else
        sch = cov.get_schedule()

      if (sch){
        if (is_schedule_allowed(pl, sch)==null)
          sch_list=true
      }
    }
    return result
  }
}

// END OF FILE
