/** @file class_chapter_05.nut
  * @brief Road freight transport, electricity supply and postal services
  */

/**
  * @brief class_chapter_05.nut
  * Road freight transport, electricity supply and postal services
  *
  *  Can NOT be used in network game !
  *
  */
class tutorial.chapter_05 extends basic_chapter
{
  chapter_name  = ch5_name
  chapter_coord = coord_chapter_5
  startcash     = 500000            // pl=0 startcash; 0=no reset

  //Step 2 =====================================================================================
  ch5_cov_lim1 = {a = 0 , b = 0}

  //Step 4 =====================================================================================
  ch5_cov_lim2 = {a = 0 , b = 0}
  ch5_cov_lim3 = {a = 0 , b = 0}

  cov_cir = 0
  sch_cov_correct = false

  //Para el Camion
  veh1_obj = get_veh_ch5(1)
  veh1_load = 100
  veh1_wait = 0
  d1_cnr = null //auto started
  f1_good = get_good_data(5, 2)

  //Step 3 =====================================================================================
  f_power = 0
  f_pow_list = [0,0,0,0]
  way5_power = [] // coords transformer

  //Step 4 =====================================================================================
  st_name = null // mail extension

  //Para el Camion
  veh2_obj = get_veh_ch5(3)
  veh2_load = set_loading_capacity(8)
  veh2_wait = set_waiting_time(6)
  d2_cnr = null //auto started
  veh2_waiting_halt = get_waiting_halt(9)

  line1_name = "ch5_l1"
  line2_name = "ch5_l2"
  line3_name = "ch5_l3"

  //Para el barco
  //sch_list3 = [coord(133,189), coord_fac_4]
  veh3_obj = get_veh_ch5(4)
  veh3_load = set_loading_capacity(9)
  veh3_wait = set_waiting_time(7)
  //c_dep3 = coord(150,190) // depot
  d3_cnr = null //auto started

  extensions_tiles = []

  //Script
  //----------------------------------------------------------------------------------
  sc_way_name = get_obj_ch5(1)
  sc_station_name = get_obj_ch5(2)
  sc_dep_name = null
  sc_trail_name = get_veh_ch5(2)
  sc_trail_nr = 1
  sc_power_name = null
  sc_transf_name = get_obj_ch5(4)

  function start_chapter()  //Inicia solo una vez por capitulo
  {

    local fab_list = [
          factory_data.rawget("5"),
          factory_data.rawget("3"),
          factory_data.rawget("7"),
          factory_data.rawget("8")
        ]

    line1_name = get_good_data(5, 3) + " " + fab_list[2].name + " - " + fab_list[3].name
    line2_name = translate("Post") + " City " +  get_city_name(city1_tow)
    local ta = this.my_tile(ch5_post_ship_halts[0])
    local tb = this.my_tile(ch5_post_ship_halts[1])
    line3_name = translate("Post") + " " + ta.get_halt().get_name() + " - " + tb.get_halt().get_name()

    // search free tile for transformer
    for ( local i = 0; i < fab_list.len(); i++ ) {
      local fac_tiles = fab_list[i].c_list
      //local size = fab_list[i].get_desc().get_building_desc ().get_size(), size
      local t = search_free_tile(fac_tiles, i+1)
      way5_power.append(t)
    }

    //sch_list2.extend(city1_post_halts)

    local lim_idx = cv_list[(persistent.chapter - 2)].idx
    ch5_cov_lim1 = {a = cv_lim[lim_idx].a, b = cv_lim[lim_idx].b}
    ch5_cov_lim2 = {a = cv_lim[lim_idx+1].a, b = cv_lim[lim_idx+1].b}
    ch5_cov_lim3 = {a = cv_lim[lim_idx+2].a, b = cv_lim[lim_idx+2].b}

    /// set depot name
    sc_dep_name = find_object("depot", wt_road).get_name()
    /// set mail extension name
    st_name = find_object("extension", wt_road, null, good_alias.mail).get_name()
    /// set powerline name
    sc_power_name = find_object("way", wt_power, 0).get_name()

    d1_cnr = get_dep_cov_nr(ch5_cov_lim1.a,ch5_cov_lim1.b)
    d2_cnr = get_dep_cov_nr(ch5_cov_lim2.a,ch5_cov_lim2.b)
    d3_cnr = get_dep_cov_nr(ch5_cov_lim3.a,ch5_cov_lim3.b)

    local pl = 0

    return 0
  }

  function set_goal_text(text)
  {
    local ok_tx =  translate("Ok")
    local trf_name = translate("Build drain")           // Aufspanntransformator
    local toolbar = translate_objects_list.tools_power  // toolbar with powerline tools

    local fab_list = [
          factory_data.rawget("5"),
          factory_data.rawget("3"),
          factory_data.rawget("7"),
          factory_data.rawget("8")
        ]

    switch (this.step) {
      case 1:
      break
      case 2:
        local c_w1 = coord(way5_fac7_fac8[0].x, way5_fac7_fac8[0].y)
        local c_w2 = coord(way5_fac7_fac8[1].x, way5_fac7_fac8[1].y)

        text.w1 = c_w1.href("("+c_w1.tostring()+")")
        text.w2 = c_w2.href("("+c_w2.tostring()+")")

        text.dep = ch5_road_depot.a.href("("+ch5_road_depot.a.tostring()+")")
        text.veh = translate(veh1_obj)

        text.good     = get_good_data(5, 3) //translate_objects_list.good_coal
        //text.g_metric = get_good_data(5, 1)

        text.all_cov = d1_cnr
        text.cir = cov_cir
        text.load = veh1_load
        text.wait = get_wait_time_text(veh1_wait)
      break
      case 3:
        if (pot[0]==0){
          text = ttextfile("chapter_05/03_1-2.txt")
          text.tx="<em>[1/2]</em>"
          text.trf_name = trf_name
          text.toolbar = toolbar

          local tran_tx = ""
          for(local j=0;j<way5_power.len();j++){
                if ( glsw[j] == 0 ) {
                    tran_tx +=format("<st>%s %d</st> ", trf_name, j+1) + way5_power[j].href("("+coord3d_to_string(way5_power[j])+")") + "<br/>"
                }
                else {
                    tran_tx +=format("<em>%s %d</em> ",trf_name ,j+1)+"("+coord3d_to_string(way5_power[j])+") <em>"+ok_tx+"</em><br/>"
                }
            }
          text.tran = tran_tx
        }

        else if (pot[0]==1 && pot[1]==0){
          text = ttextfile("chapter_05/03_2-2.txt")
          text.tx="<em>[2/2]</em>"
          text.powerline_tool = translate(sc_power_name) // tool powerline
          text.toolbar = toolbar

          local tran_tx = ""
          local f_list = fab_list
          for(local j=0;j<f_list.len();j++){
             if ( glsw[j] == 0 ) {
              tran_tx +=format("<st>%s</st> ",translate(f_list[j].name)) + f_list[j].c.href("("+f_list[j].c.tostring()+")") + "<br/>"
             }
             else {
              tran_tx +=format("<em>%s</em> ",translate(f_list[j].name)) + "("+f_list[j].c.tostring()+") <em>"+translate("OK")+"</em><br/>"
             }
          }
          f_power = f_power + f_pow_list[0] + f_pow_list[1] + f_pow_list[2]
          text.pow = f_power
          text.tran = tran_tx
        }
      break
      case 4:
      if (pot[0]==1 && pot[1]==0){
        text = ttextfile("chapter_05/04_1-3.txt")
        text.tx="<em>[1/3]</em>"

        // set image for button by different in paksets
        text.img_road_menu = get_gui_img("road_halts")
        text.img_post_menu = get_gui_img("post_menu")

        //check_post_extension(city1_post_halts)
        text.toolbar_extension = translate_objects_list.tools_mail_extension
        text.toolbar_halt = translate_objects_list.tools_road_stations

        local st_tx = ""
        local list = city1_post_halts //extensions_tiles  //Lista de build
        for ( local j = 0; j < list.len(); j++ ) {
          //local c = coord(c_list[j].x, c_list[j].y)
          local tile = my_tile(list[j])
          local st_halt = tile.get_halt()
          //local name = list[j].name == ""? get_good_text(list[j].good) : translate(list[j].name)
          local name = st_halt.get_name() //translate(get_obj_ch5(6))
          if ( glsw[j] == 0 ) {
            st_tx +=format("%s: <st>%s</st> ", translate("Stop"), name) + list[j].href("("+list[j].tostring()+")")+"<br/>"
          }
          else {
            st_tx +=format("%s: <em>%s</em> ", translate("Stop"), name)+"("+list[j].tostring()+")<em>"+ok_tx+"</em><br/>"
          }
        }
        text.st = st_tx
      }
      else if (pot[1]==1 && pot[2]==0 || (current_cov> ch5_cov_lim2.a && current_cov< ch5_cov_lim2.b)){
        text = ttextfile("chapter_05/04_2-3.txt")
        text.tx = "<em>[2/3]</em>"
        local list_tx = ""
        local c_list = city1_post_halts

        for ( local j = 0; j < c_list.len(); j++ ) {
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

        if ( pot[1]==1 ) {
          new_set_waiting_halt(city1_post_halts)
        }
        local c = coord(c_list[veh2_waiting_halt].x, c_list[veh2_waiting_halt].y)
        local tile = my_tile(c)
        text.stnam = (veh2_waiting_halt+1) + ") "+tile.get_halt().get_name()+" ("+c.tostring()+")"

        text.list = list_tx
        text.dep = city1_road_depot.href("("+city1_road_depot.tostring()+")")
        text.veh = translate(veh2_obj)
        text.all_cov = d2_cnr
        text.cir = cov_cir
        text.load = veh2_load
        text.wait = get_wait_time_text(veh2_wait)
        text.nr = c_list.len()
      }
      else if (pot[2]==1 && pot[3]==0 || (current_cov> ch5_cov_lim3.a && current_cov< ch5_cov_lim3.b)){
        text = ttextfile("chapter_05/04_3-3.txt")
        text.tx = "<em>[3/3]</em>"
        local list_tx = ""
        local c_list = ch5_post_ship_halts
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
        local c = coord(c_list[get_waiting_halt(10)].x, c_list[get_waiting_halt(10)].y)
        local tile = my_tile(c)
        text.stnam = (get_waiting_halt(10)+1) + ") "+tile.get_halt().get_name()+" ("+c.tostring()+")"

        text.list = list_tx
        text.dep = ship_depot.href("("+ship_depot.tostring()+")")
        text.ship = translate(veh3_obj)
        text.load = veh3_load
        text.wait = get_wait_time_text(veh3_wait)
        text.nr = siz
      }
      break
    }

    text.f1 = fab_list[0].c.href(""+fab_list[0].name+" ("+fab_list[0].c.tostring()+")")+""
    text.f2 = fab_list[1].c.href(""+fab_list[1].name+" ("+fab_list[1].c.tostring()+")")+""
    text.f3 = fab_list[2].c.href(""+fab_list[2].name+" ("+fab_list[2].c.tostring()+")")+""
    text.f4 = fab_list[3].c.href(""+fab_list[3].name+" ("+fab_list[3].c.tostring()+")")+""

    text.tool1 = translate(tool_alias.inspe)
    text.tool2 = translate(tool_alias.road)
    text.tool3 = translate(tool_alias.spec)

    return text
  }

  function is_chapter_completed(pl) {
    save_glsw()
    save_pot()

    local fab_list =  [
          factory_data.rawget("5"),
          factory_data.rawget("3"),
          factory_data.rawget("7"),
          factory_data.rawget("8")
        ]

    persistent.ch_max_steps = 4
    local chapter_step = persistent.step
    persistent.ch_max_sub_steps = 0 // count all sub steps
    persistent.ch_sub_step = 0  // actual sub step

    switch (this.step) {
      case 1:
        if(pot[0]==1){
          //Creea un cuadro label
          local opt = 0
          local del = false
          local text = "X"
          label_bord(way5_fac7_fac8_lim.a, way5_fac7_fac8_lim.b, opt, del, text)

          this.next_step()
        }
        //return 0
        break;
      case 2:
        if (pot[0]==0){
          local coora = coord3d(way5_fac7_fac8[0].x,way5_fac7_fac8[0].y,way5_fac7_fac8[0].z)
          local coorb = coord3d(way5_fac7_fac8[1].x,way5_fac7_fac8[1].y,way5_fac7_fac8[1].z)

          local t_start = tile_x(coora.x,coora.y,coora.z)
          local t_end = tile_x(coorb.x,coorb.y,coorb.z)

          if(!t_start.find_object(mo_way)){
            local label = t_start.find_object(mo_label)
            if(label.get_text()== "X")
              t_start.remove_object(player_x(1), mo_label)

            label_x.create(t_start, pl_unown, translate("Place the Road here!."))
          }
          else t_start.remove_object(player_x(1), mo_label)

          if(!t_end.find_object(mo_way)){
            local label = t_end.find_object(mo_label)
            if(label.get_text()== "X")
              t_end.remove_object(player_x(1), mo_label)

            label_x.create(t_end, pl_unown, translate("Place the Road here!."))
          }
          else t_end.remove_object(player_x(1), mo_label)

          //Comprueba la conexion de la via
          local obj = false
          local dir = 2//way5_fac7_fac8[0].dir
          local r_way = get_fullway(coora, coorb, dir, obj)

          if (test_select_way(way5_fac7_fac8[1], way5_fac7_fac8[0], wt_road)){
            //elimina el cuadro label
            local opt = 0
            local del = true
            local text = "X"
            label_bord(way5_fac7_fac8_lim.a, way5_fac7_fac8_lim.b, opt, del, text)

            pot[0]=1
            //return 10
          }
        }
        else if (pot[0]==1 && pot[1]==0){
          local c_list = way5_fac7_fac8
          local name =  translate("Place Stop here!.")
          local load = good_alias.goods
          local all_stop = is_stop_building(c_list, name, load)

          if (all_stop){
            reset_glsw()
            pot[1]=1
          }
        }
        else if (pot[1]==1 && pot[2]==0){
          local tile = my_tile(ch5_road_depot.a)
          if(!tile.find_object(mo_way)){
            label_x.create(ch5_road_depot.a, pl_unown, translate("Place the Road here!."))
          }
          else {
            if (!tile.find_object(mo_depot_road)){
              local lab = tile.find_object(mo_label)
              if(lab) lab.set_text(translate("Build a Depot here!."))
            }
            else{
              tile.remove_object(player_x(1), mo_label)
              pot[2]=1
            }
          }
        }
        else if (pot[2]==1 && pot[3]==0){
          cov_cir = get_convoy_nr((ch5_cov_lim1.a), d1_cnr)

          if (cov_cir == d1_cnr){
            this.next_step()
          }
        }
        //return 0
        break;
      case 3:
        persistent.ch_max_sub_steps = 2
        if (pot[0]==0){
          for(local j=0;j<way5_power.len();j++){
            local tile = my_tile(way5_power[j])
            local f_transfc = tile.find_object(mo_transformer_c)
            local f_transfs = tile.find_object(mo_transformer_s)
            if (f_transfc || f_transfs){
              tile.remove_object(player_x(1), mo_label)
              glsw[j]=1
            }
            else
              label_x.create(way5_power[j], pl_unown, translate("Transformer Here!."))
          }

          if( glsw[0]==1 && glsw[1]==1 && glsw[2]==1 && glsw[3]==1){
            pot[0] = 1
            reset_glsw()

            //Crear cuadro label para las power line
            local opt = 0
            local del = false
            for(local j = 0;j<way5_power_lim.len();j++){
              label_bord(way5_power_lim[j].a, way5_power_lim[j].b, opt, del, "X")
            }
            //Elimina cudro label
            del = true
            for(local j = 0;j<way5_power_lim_del.len();j++){
              label_bord(way5_power_lim_del[j].a, way5_power_lim_del[j].b, opt, del, "X")
            }
            //return 20
          }
        }
        else if (pot[0]==1 && pot[1] == 0){
          persistent.ch_sub_step = 1
          local f_list = fab_list
          local pow_list = [0,0,0,0]
          local f_tile_t = my_tile(way5_power[3])
          local f_transf = f_tile_t.find_object(mo_transformer_s)
          for(local j=0;j<f_list.len();j++){
            local tile = my_tile(f_list[j].c)
            local factory = tile.find_object(mo_building).get_factory()
            if (factory){
                if(script_test && factory.is_transformer_connected()){
                  local transf = factory.get_transformer()
                  if (transf.is_connected(f_transf)){
                    glsw[j] = 1
                  }
                }
                else{
                  pow_list[j] = factory.get_power()[0]
                  f_pow_list[j] = pow_list[j]
                  if (pow_list[j] != 0)
                    glsw[j] = 1
                }
            }
          }
          if (glsw[0] == 1 && glsw[1] == 1 && glsw[2] == 1){
            //Elimina cuadro label para las power line
            local opt = 0
            local del = true

            for(local j = 0;j<way5_power_lim.len();j++){
              label_bord(way5_power_lim[j].a, way5_power_lim[j].b, opt, del, "X")
            }

            this.next_step()
            //return 30
          }
        }
        //return 0
        break;
      case 4:
        persistent.ch_max_sub_steps = 3
        if (pot[0]==0){

          check_post_extension(city1_post_halts)

          local player = player_x(1)
          local list = [] //extensions_tiles
          local good = good_alias.mail
          local accept_post = false

          for ( local i = 0; i < city1_post_halts.len(); i++ ) {
            // check halts accept mail
            local t = my_tile(city1_post_halts[i])
            local halt = t.get_halt()
            if ( halt != null ) {
              accept_post = halt.accepts_good(good_desc_x(good))
              //gui.add_message(coord3d_to_string(t) + " accept_post " + accept_post)
              if ( !accept_post ) {
                list.append(extensions_tiles[i])
              }
            }
          }

          local station = false
          local lab_name = translate("Mail Extension Here!.")


          delete_objet(player, list, mo_building, lab_name, station, accept_post)
          pot[0]=1
        }
        if (pot[0]==1 && pot[1]==0){
          local lab_name = translate("Mail Extension Here!.")
          local all_stop = is_stop_building_ex(city1_post_halts, lab_name)
          if (all_stop && pot[1]==0){
            pot[1]=1
            reset_glsw()
          }
        }
        if (pot[1]==1 && pot[2]==0){
          persistent.ch_sub_step = 2
          local c_dep = this.my_tile(city1_road_depot)
          local line_name = line1_name
          set_convoy_schedule(pl, c_dep, wt_road, line_name)

          local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
          local cov_list = depot.get_convoy_list()    //Lista de vehiculos en el deposito
          local convoy = convoy_x(gcov_id)
          if (cov_list.len()>=1){
            convoy = cov_list[0]
          }
          local all_result = checks_convoy_schedule(convoy, pl)
          sch_cov_correct = all_result.res == null ? true : false

          cov_cir = get_convoy_nr((ch5_cov_lim2.a), d2_cnr)
          if (current_cov >= ch5_cov_lim2.b){
            sch_cov_correct = false
            pot[2]=1
          }
        }
        if (pot[2]==1 && pot[3]==0){
          persistent.ch_sub_step = 1
          local c_dep = this.my_tile(ship_depot)
          local depot = depot_x(c_dep.x, c_dep.y, c_dep.z)
          local cov_list = depot.get_convoy_list()    //Lista de vehiculos en el deposito
          local convoy = convoy_x(gcov_id)
          if (cov_list.len()>=1){
            convoy = cov_list[0]
          }
          local all_result = checks_convoy_schedule(convoy, pl)
          sch_cov_correct = all_result.res == null ? true : false

          if (current_cov >= ch5_cov_lim3.b){
            sch_cov_correct = false
            this.next_step()
          }
        }
        //return 80
        break
      case 5:
        this.step=1
        persistent.step =1
        persistent.status.step = 1
        //return 100
        break
    }
    local percentage = chapter_percentage(persistent.ch_max_steps, chapter_step, persistent.ch_max_sub_steps, persistent.ch_sub_step)
    return percentage
  }

  function is_work_allowed_here(pl, tool_id, name, pos, tool) {
    //return tool_id
    glpos = coord3d(pos.x, pos.y, pos.z)
    //local t = tile_x(pos.x, pos.y, pos.z)
    //local ribi = 0
    //local wt = 0
    //local slope = t.get_slope()
    //local way = t.find_object(mo_way)
    //local powerline = t.find_object(mo_powerline)
    //local bridge = t.find_object(mo_bridge)
    //local label = t.find_object(mo_label)
    //local building = t.find_object(mo_building)
    //local sign = t.find_object(mo_signal)
    //local roadsign = t.find_object(mo_roadsign)
    /*if (way){
      wt = way.get_waytype()
      if (tool_id!=4111)
        ribi = way.get_dirs()
      if (!t.has_way(gl_wt))
        ribi = 0
    }*/

    local label = null
    local st_nr = [2, 3]
    if ( st_nr.find(this.step) ) {
      label = tile_x(pos.x, pos.y, pos.z).find_object(mo_label)
    }

    local fab_list =  [
          factory_data.rawget("5"),
          factory_data.rawget("3"),
          factory_data.rawget("7"),
          factory_data.rawget("8")
        ]

    local result = get_message(2) //translate("Action not allowed")    // null is equivalent to 'allowed'

    switch (this.step) {
      case 1:
        if (tool_id == 4096){
          local list = fab_list
          for(local j = 0; j<list.len(); j++){
            local t_list = fab_list[j].c_list
            foreach(t in t_list){
              if(pos.x == t.x && pos.y == t.y){
                pot[0]=1
              }
            }
          }
        }
      break;

      case 2:
        local way = tile_x(pos.x, pos.y, pos.z).find_object(mo_way)
        if(pot[0]==0){
          if(pos.x>=way5_fac7_fac8_lim.a.x && pos.y>=way5_fac7_fac8_lim.a.y && pos.x<=way5_fac7_fac8_lim.b.x && pos.y<=way5_fac7_fac8_lim.b.y){
            if (!way && label && label.get_text()=="X"){
              return get_tile_message(5, pos) //translate("Indicates the limits for using construction tools")+" ( "+pos.tostring()+")."
            }

            if( tile_x(r_way.c.x, r_way.c.y, r_way.c.z).find_object(mo_label) ){
              if(tool_id == tool_build_way || tool_id == 4113 || tool_id == tool_remover)
              return null
            }
            else return all_control(result, wt_road, st_flat, tool_id, pos, r_way.c, name)
          }
        }
        else if(pot[0]==1 && pot[1]==0){
          for ( local j = 0; j < way5_fac7_fac8.len(); j++ ) {
            if(pos.x==way5_fac7_fac8[j].x && pos.y==way5_fac7_fac8[j].y){
              if(tool_id==tool_build_station || tool_id==tool_remover){
                // check selected halt accept goods
                local s = check_select_station(name, wt_road, good_alias.goods)
                if ( s != null ) return s

                return is_station_truck_build(pos, tool_id, way5_fac7_fac8, good_alias.goods)
              }
            }
          }
        }
        else if(pot[1]==1 && pot[2]==0){
          if(pos.x>=ch5_road_depot.a.x && pos.y>=ch5_road_depot.a.y && pos.x<=ch5_road_depot.b.x && pos.y<=ch5_road_depot.b.y){
            if(tool_id==tool_build_way || tool_id==tool_build_depot){
              return null
            }
          }
        }
        else if(pot[2]==1 && pot[3]==0){
          if (tool_id==4108) {
            return is_stop_allowed(ch5_road_depot.a, way5_fac7_fac8, pos)
          }
        }
      break;

      //Conectando los transformadores
      case 3:
        if (pot[0]==0){
          for(local j=0;j<way5_power.len();j++){
            if (tool_id == tool_build_transformer){
              local f_transf = tile_x(pos.x, pos.y, pos.z).find_object(mo_transformer_c)
              if (pos.x==way5_power[j].x && pos.y==way5_power[j].y){
                if ( glsw[j] == 0 ) {
                  return null
                }
                else
                  return  translate("There is already a transformer here!")+" ("+pos.tostring()+")."
              }
              else if ( glsw[j] == 0 )
                result = translate("Build the transformer here!")+" ("+coord3d_to_string(way5_power[j])+")."
            }
          }
          if(tool_id == tool_build_transformer)
            return result
        }
        else if (pot[0]==1 && pot[1] == 0){
          for(local j=0;j<way5_power_lim.len();j++){
            if(pos.x>=way5_power_lim[j].a.x && pos.y>=way5_power_lim[j].a.y && pos.x<=way5_power_lim[j].b.x && pos.y<=way5_power_lim[j].b.y){

               if (tool_id == tool_build_way || tool_id == tool_build_bridge || tool_id == tool_build_tunnel){
                 if (label && label.get_text()=="X")
                   return get_tile_message(5, pos) //translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."
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
            else if ( j == way5_power_lim.len()-1 ) {
              result = get_tile_message(13, pos) //translate("You are outside the allowed limits!")+" ("+pos.tostring()+")."
            }
          }
          if (tool_id == tool_build_way)
            return result

        }
        break
      case 4:
        if ( pot[0] == 1 && pot[1] == 0 ) {
          // Permite construir paradas

          if ( tool_id == tool_build_station ) {
            local wt = wt_road
            local tile_found = false
            // define station or station_extension
            for( local j = 0; j < extensions_tiles.len(); j++ ) {
              if ( pos.x == extensions_tiles[j].a.x && pos.y == extensions_tiles[j].a.y ) {
                tile_found = true
                if ( extensions_tiles[j].b == 0 ) {
                  wt = 0
                  break
                }
              }
            }

            if ( !tile_found ) {
              return translate("Place the mail extension at the marked tiles.")
            }

            // check selected halt accept mail
            local s = check_select_station(name, wt, good_alias.mail)
            if ( s != null ) { return s }

            for ( local j = 0; j < extensions_tiles.len(); j++ ) {
              if ( pos.x == extensions_tiles[j].a.x && pos.y == extensions_tiles[j].a.y ) {
                if ( glsw[j] == 0 ) {
                  return null
                } else {
                return translate("This stop already accepts mail.")
                }
              }

            }
          }

          // Permite eliminar paradas
          if ( tool_id == 4097 ) {
            for( local j = 0; j < extensions_tiles.len(); j++ ) {
              local c = extensions_tiles[j].a
              if (c != null){
                local stop = my_tile(c).find_object(mo_building)
                if ( pos.x == c.x && pos.y == c.y && stop ) {
                  return null
                }
              }
            }
            return translate("You can only delete the stops/extensions.")
          }
        }
        if ( pot[1]==1 && pot[2]==0 ) {
          if (tool_id==4108) {
            return is_stop_allowed(city1_road_depot, city1_post_halts, pos)
          }
        }
        if ( pot[2]==1 && pot[3]==0 ) {
          if (tool_id==4108) {
            return is_stop_allowed_ex(ship_depot, ch5_post_ship_halts, pos, wt_water)
          }
        }
        break

    }

    if ( tool_id == 4096 ){
      local label = tile_x(pos.x, pos.y, pos.z).find_object(mo_label)
      if (label && label.get_text()=="X")
        return get_tile_message(5, pos) //translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."
      //else if (label)
      //  return translate("Text label")+" ("+pos.tostring()+")."
      result = null // Always allow query tool
    }
    //if (label && label.get_text()=="X")
    //  return get_tile_message(5, pos) //translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."

    return result
  }

  function is_schedule_allowed(pl, schedule) {
    local result=null // null is equivalent to 'allowed'

    local nr = schedule.entries.len()

    switch (this.step) {
      case 2:
        if ( (pl == 0) && (schedule.waytype != wt_road) )
          result = translate("Only road schedules allowed")

        local selc = 0
        local load = veh1_load
        local time = veh1_wait
        local c_list = way5_fac7_fac8
        result = compare_schedule(result, pl, schedule, selc, load, time, c_list, false)
        if(result != null) reset_tmpsw()
        return result
      break
      case 4:
        if (current_cov> ch5_cov_lim2.a && current_cov< ch5_cov_lim2.b){
          if ( (pl == 0) && (schedule.waytype != wt_road) )
            result = translate("Only road schedules allowed")

          local selc = veh2_waiting_halt
          local load = veh2_load
          local time = veh2_wait
          local c_list = city1_post_halts
          result = compare_schedule(result, pl, schedule, selc, load, time, c_list, true)
          if(result == null){
            local line_name = line2_name
            update_convoy_schedule(pl, wt_road, line_name, schedule)
          }
        }
        else if (current_cov> ch5_cov_lim3.a && current_cov< ch5_cov_lim3.b){
          if ( (pl == 0) && (schedule.waytype != wt_water) )
            result = translate("Only water schedules allowed")

          local selc = get_waiting_halt(10)
          local load = veh3_load
          local time = veh3_wait
          local c_list = ch5_post_ship_halts
          result = compare_schedule(result, pl, schedule, selc, load, time, c_list, false)
        }
        return result
      break
    }
    return result
  }

  function is_convoy_allowed(pl, convoy, depot)
  {
    local result=null // null is equivalent to 'allowed'

    switch (this.step) {
      case 2:
        local cov = d1_cnr
        local veh = 2
        local good_list = [good_desc_x(f1_good).get_catg_index()]    //Coal
        local name = veh1_obj
        local st_tile = 1

        //Para arracar varios vehiculos
        local id_start = ch5_cov_lim1.a
        local id_end = ch5_cov_lim1.b
        local c_sch = way5_fac7_fac8[0]
        local cir_nr = get_convoy_number_exp(c_sch, depot, id_start, id_end)
        cov -= cir_nr

        result = is_convoy_correct(depot, cov, veh, good_list, name, st_tile)

        if (result!=null){
          reset_tmpsw()
          local good = translate(f1_good)
          return truck_result_message(result, translate(name), good, veh, cov)
        }
        if (current_cov> ch5_cov_lim1.a && current_cov< ch5_cov_lim1.b){
          local selc = 0
          local load = veh1_load
          local time = veh1_wait
          local c_list = way5_fac7_fac8
          local siz = c_list.len()
          return compare_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
        }
      break
      case 4:
        if (current_cov> ch5_cov_lim2.a && current_cov< ch5_cov_lim2.b){
          local cov = d2_cnr
          local veh = 1
          local good_list = [good_desc_x(good_alias.mail).get_catg_index()]    //Mail
          local name = veh2_obj
          local st_tile = 1

          //Para arracar varios vehiculos
          local id_start = ch5_cov_lim2.a
          local id_end = ch5_cov_lim2.b
          local c_sch = city1_post_halts[0]
          local cir_nr = get_convoy_number_exp(c_sch, depot, id_start, id_end)
          cov -= cir_nr

          result = is_convoy_correct(depot, cov, veh, good_list, name, st_tile)

          if (result!=null){
            local good = translate(good_alias.mail)
            return truck_result_message(result, translate(name), good, veh, cov)
          }
          local selc = veh2_waiting_halt
          local load = veh2_load
          local time = veh2_wait
          local c_list = city1_post_halts
          local siz = c_list.len()
          return compare_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
        }

        else if (current_cov> ch5_cov_lim3.a && current_cov< ch5_cov_lim3.b){
          local cov = d3_cnr
          local veh = 1
          local good_list = [good_desc_x(good_alias.mail).get_catg_index()]    //Mail
          local name = veh3_obj
          local st_tile = 1
          result = is_convoy_correct(depot, cov, veh, good_list, name, st_tile)

          if (result!=null){
            local good = translate(good_alias.mail)
            return ship_result_message(result, translate(name), good, veh, cov)
          }
          local selc = get_waiting_halt(10)
          local load = veh3_load
          local time = veh3_wait
          local c_list = ch5_post_ship_halts
          local siz = c_list.len()
          return compare_schedule_convoy(result, pl, cov, convoy, selc, load, time, c_list, siz)
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
        if(pot[0]==0) pot[0]=1

        return null
      break;
      case 2:
        if (pot[0]==0){
          local coora = coord3d(way5_fac7_fac8[0].x,way5_fac7_fac8[0].y,way5_fac7_fac8[0].z)
          local coorb = coord3d(way5_fac7_fac8[1].x,way5_fac7_fac8[1].y,way5_fac7_fac8[1].z)

          local t = command_x(tool_build_way)
          local err = t.work(player, coora, coorb, sc_way_name)
        }
        if (pot[2]==0){

          //Para la carretera
          local t_start = my_tile(ch5_road_depot.a)
          local t_end = my_tile(ch5_road_depot.b)
          t_start.remove_object(player_x(1), mo_label)
          local t = command_x(tool_build_way)

          local err = t.work(player, t_start, t_end, sc_way_name)

          t = command_x(tool_build_depot)
          t.work(player, t_start, sc_dep_name)
        }

        if (pot[1]==0){
          for(local j=0;j<way5_fac7_fac8.len();j++){
            local tile = my_tile(way5_fac7_fac8[j])
            local way = tile.find_object(mo_way)
            tile.remove_object(player_x(1), mo_label)
            local tool = command_x(tool_build_station)
            local err = tool.work(player, tile, sc_station_name)
          }
        }

        if (current_cov> ch5_cov_lim1.a && current_cov< ch5_cov_lim1.b){
          local wt = wt_road
          local c_depot = my_tile(ch5_road_depot.a)

          try {
            comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito
          }
          catch(ev) {
            return null
          }

          local depot = c_depot.find_object(mo_depot_road)
          local good_nr = good_desc_x(f1_good).get_catg_index()  //Coal
          local sched = schedule_x(wt, [])
          sched.entries.append(schedule_entry_x(my_tile(way5_fac7_fac8[0]), veh1_load, veh1_wait))
          sched.entries.append(schedule_entry_x(my_tile(way5_fac7_fac8[1]), 0, 0))
          local c_line = comm_get_line(player, wt, sched, line1_name)

          local name = veh1_obj
          local cov_nr = d1_cnr  //Max convoys nr in depot
          local extender_name = sc_trail_name
          local siz = sc_trail_nr
          local extender = true
          for (local j = 0; j<(cov_nr); j++){
            if (!comm_set_convoy(cov_nr, c_depot, name))
              return 0
            for (local count = 0;count<siz;count++){
              if (!comm_set_convoy(j, c_depot, extender_name, extender))
                return 0
            }
            local conv = depot.get_convoy_list()
            conv[j].set_line(player, c_line)
          }
          local convoy = false
          local all = true
          comm_start_convoy(player, convoy, depot, all)
        }

      break
      case 3:

        if (pot[0]==0){
          for(local j=0;j<way5_power.len();j++){
            local tile = my_tile(way5_power[j])
            local label = tile.find_object(mo_label)
            if (label){
              tile.remove_object(player_x(1), mo_label)
            }

            local tool = command_x(tool_build_transformer)
            local err = tool.work(player, tile, sc_transf_name)
          }
        }
        if (pot[1] == 0){
          local start = my_tile(way5_power[0])
          local t_name = sc_power_name
          local tool = command_x(tool_build_way)
          for(local j=1;j<way5_power.len();j++){
            local tile = my_tile(way5_power[j])
            tool.work(player, start, tile, t_name)
          }
        }
        return null
        break;
      case 4:
        if (pot[0]==0){
          local pl = 0
          local list = extensions_tiles
          local obj = mo_building
          local station = false

          for(local j=0;j<list.len();j++){
            local tile = my_tile(list[j].a)
            local is_obj = tile.find_object(obj)
            local halt = tile.get_halt()
            if (is_obj){
                if (!halt){
                    tile.remove_object(player_x(1), obj)
                }
                else if (station){
                    tile.remove_object(player_x(1), obj)
                }
            }
          }
        }
        if (pot[1]==0){
            local count=0
            local nr = extensions_tiles.len()
            local list = extensions_tiles

          for(local j=0;j<nr;j++){
            if ( glsw[j] == 0 ) {
              local tile = my_tile(list[j].a)
              local name = st_name //list[j].name == ""? sc_st_name2 : list[j].name
              local label = tile.find_object(mo_label)
              local o = null
              if (label) {
                tile.remove_object(player_x(1), mo_label)
                o = find_object("extension", wt_road, null, good_alias.mail)
                name = o.get_name()
              }

              local way = tile.find_object(mo_way)
              if(way) {
                way.unmark()
                o = find_object("station", wt_road, null, good_alias.mail)
                name = o.get_name()
                city1_post_halts[j] = coord(tile.x, tile.y)
              }

              //local halt = tile.get_halt()
              local tool = command_x(tool_build_station)
              local res = tool.work(player, tile, name)
              if ( res != null ) {
                // not build -> message to message window and break
                gui.add_message( j + " tool.work " + res + " name " + name)
                break
              }

            }
          }
        }
        local ok = false
        if (current_cov> ch5_cov_lim2.a && current_cov< ch5_cov_lim2.b) {

          new_set_waiting_halt(city1_post_halts)

          local wt = wt_road
          local c_depot = my_tile(city1_road_depot)
          comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito

          local sched = schedule_x(wt, [])
          local c_list = city1_post_halts
          local siz = c_list.len()
          for(local j = 0;j<siz;j++){
            if(j==veh2_waiting_halt)
              sched.entries.append(schedule_entry_x(my_tile(c_list[j]), veh2_load, veh2_wait))
            else
              sched.entries.append(schedule_entry_x(my_tile(c_list[j]), 0, 0))
          }
          local c_line = comm_get_line(player, wt, sched, line2_name)

          local name = veh2_obj
          local cov_nr = d2_cnr  //Max convoys nr in depot
          local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
          for (local j = 0; j<(cov_nr); j++){
            if (!comm_set_convoy(j, c_depot, name))
              return 0
            local conv = depot.get_convoy_list()
            conv[j].set_line(player, c_line)
          }
          local convoy = false
          local all = true
          comm_start_convoy(player, convoy, depot, all)

          ok = true
        }

        if (ok || (current_cov> ch5_cov_lim3.a && current_cov< ch5_cov_lim3.b)){
          local wt = wt_water
          local c_depot = my_tile(ship_depot)
          comm_destroy_convoy(player, c_depot) // Limpia los vehiculos del deposito

          local sched = schedule_x(wt, [])
          local c_list = is_water_entry(ch5_post_ship_halts)
          local siz = c_list.len()
          for(local j = 0;j<siz;j++){
            if(j==get_waiting_halt(10))
              sched.entries.append(schedule_entry_x(my_tile(c_list[j]), veh3_load, veh3_wait))
            else
              sched.entries.append(schedule_entry_x(my_tile(c_list[j]), 0, 0))
          }
          local c_line = comm_get_line(player, wt, sched, line3_name)

          local name = veh3_obj
          local cov_nr = d3_cnr  //Max convoys nr in depot
          if (!comm_set_convoy(cov_nr, c_depot, name))
            return 0

          local depot = depot_x(c_depot.x, c_depot.y, c_depot.z)
          local conv = depot.get_convoy_list()
          conv[0].set_line(player, c_line)
          comm_start_convoy(player, conv[0], depot)
        }

        return null
      break
    }
    return null
  }

  function is_tool_active(pl, tool_id, wt) {
    //local t_list = {t_icon.road, t_icon.other, slope = 0x8001}
    local result = false
    switch (this.step) {
      case 1:
        local t_list = []
        local wt_list = [0]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 2:
        local t_list = [tool_build_way, tool_remove_way, tool_remover, tool_build_depot, tool_build_station]
        local wt_list = [wt_road]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 3:
        local t_list = [-t_icon.road, tool_build_transformer, tool_build_bridge, tool_build_tunnel, tool_build_way, tool_remove_way, tool_remover]
        local wt_list = [wt_power]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 4:
        local t_list = [t_icon.road, tool_build_station, t_icon.exted, 1013]
        local wt_list = [wt_road, 0]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break
    }

    return result
  }

  function is_tool_allowed(pl, tool_id, wt){
    local gt_list = [ t_icon.tram ]
    foreach (id in gt_list){
      if(id == tool_id)
        return false
    }
    local result = true
    switch (this.step) {
      case 1:
        local t_list = [0] // 0 = all tools allowed
        local wt_list = [-1]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 2:
        local t_list = [-t_icon.other, -tool_build_bridge, -tool_build_tunnel, 0] // 0 = all tools allowed
        local wt_list = [wt_road]
        local res = update_tools(t_list, tool_id, wt_list, wt)
        result = res.result
        break

      case 3:
        if(wt == wt_road){
          local t_list = [-t_icon.other, -tool_build_bridge, -tool_build_tunnel, 0] // 0 = all tools allowed
          local wt_list = [wt_road]
          local res = update_tools(t_list, tool_id, wt_list, wt)
          result = res.result
          break
        }
        else {
          local t_list = [0] // 0 = all tools allowed
          local wt_list = [wt_power]
          local res = update_tools(t_list, tool_id, wt_list, wt)
          result = res.result
          break
        }

      case 4:
        if(wt == wt_road){
          local t_list = [-tool_build_bridge, -tool_build_tunnel, -tool_build_way, -tool_remove_way, -tool_build_depot, 0] // 0 = all tools allowed
          local wt_list = [wt_road]
          local res = update_tools(t_list, tool_id, wt_list, wt)
          result = res.result
          break
        }
        else {
          local t_list = [0] // 0 = all tools allowed
          local wt_list = [0, wt_power]
          local res = update_tools(t_list, tool_id, wt_list, wt)
          result = res.result
          break
        }
    }
    return result
  }

    function delete_objet(player, list, obj, lab_name, station, accept_post)
    {
        for( local j = 0; j < list.len(); j++ ) {
            // array with coord and code
            local t = my_tile(list[j].a)

            local is_obj = t.find_object(obj)
            local halt = t.get_halt()
            //local accept_post = halt.accepts_good(good_desc_x(good))
            //try {
              if ( list[j].b == 0 && !accept_post ) {
                public_label(t, lab_name)
              } else if ( list[j].b == 1 && !accept_post ) {
                foreach(obj in t.get_objects()){
                  obj.mark()
                }
              }
            //}
            //catch {
             /* if (is_obj){
                if (!halt){
                    t.remove_object(player, obj)
                }
                else if (station){
                    t.remove_object(player, obj)
                }
              }
              if (t.is_empty())
                public_label(t, lab_name)*/
            //}
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
        return translate("No barges allowed.")
        break

      default :
        return translate("The convoy is not correct.")
        break
    }
  }
}        // END of class


/**
 *  search free tile for transformer on factory
 *
 *  tile_list = factory tile list
 *  r         = start search direction (1 = west, 2 = south, 3 = east, 4 = north)
 *
 *  return tile_x
 *
 */
function search_free_tile(tile_list, r) {

  local xl = tile_list[tile_list.len()-1].x - tile_list[0].x
  local yl = tile_list[tile_list.len()-1].y - tile_list[0].y

  local tile = null

  //gui.add_message("tile search  - " + coord3d_to_string(tile_list[0]))

    switch (r) {
      case 1:
        tile = tile_x(tile_list[0].x-1, tile_list[0].y, tile_list[0].z)
        break

      case 2:
        tile = tile_x(tile_list[0].x, tile_list[0].y+yl+1, tile_list[tile_list.len()-1].z)
        break

      case 3:
        tile = tile_x(tile_list[0].x+xl+1, tile_list[0].y, tile_list[0].z)
        break

      case 4:
        tile = tile_x(tile_list[0].x, tile_list[0].y-1, tile_list[0].z)
        break

      default :

        break
    }

    if ( test_tile_is_empty(tile) && tile.get_slope() == 0 ) {
      //gui.add_message("tile found  - " + coord3d_to_string(tile))
      return tile
    }


}

/**
  * @fn new_set_waiting_halt()
  *     set waiting halt to post halt
  *
  * @param list - halt list
  *
  *
  */
function new_set_waiting_halt(list) {
  local t = null

  for ( local i = 0; i < list.len(); i++ ) {
    t = my_tile(list[i])
    local w_dir = t.get_way_dirs(wt_road)
    if ( dir.is_single(w_dir) && extensions_tiles[i].b == 1 ) {
      veh2_waiting_halt = i
      break
    } else if ( dir.is_straight(w_dir) && extensions_tiles[i].b == 1 ) {
      local h = t.get_halt()
      local t_list = h.get_tile_list()
      if ( t_list[0].x != t_list[1].x && t_list[0].y != t_list[1].y ) {
        veh2_waiting_halt = i
        break
      }
    }
  }
}
// END OF FILE
