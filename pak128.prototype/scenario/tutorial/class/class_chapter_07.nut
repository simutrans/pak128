/** @file class_chapter_07.nut
  * @brief City transport with buses without step sequence
  */

/**
  * @brief class_chapter_07.nut
  * City transport with buses without step sequence
  *
  *
  * Can NOT be used in network game !
  */
class tutorial.chapter_07 extends basic_chapter
{
  chapter_name  = ch7_name
  chapter_coord = coord_chapter_7
  startcash     = 500000  // pl=0 startcash; 0=no reset
  load = 0                // count for transportet passenger

  gl_wt = wt_road
  gl_good = 0 //Passengers

  compass_nr = 0

  cty1 = {name = ""}
  c_cty_lim1 = {a = coord(0,0), b = coord(0,0)}

  cty2 = {name = ""}
  c_cty_lim2 = {a = coord(0,0), b = coord(0,0)}

  cty3 = {name = ""}
  c_cty_lim3 = {a = coord(0,0), b = coord(0,0)}

  cty4 = {name = ""}
  c_cty_lim4 = {a = coord(0,0), b = coord(0,0)}

  // Step 1
  goal_lod1 = set_transportet_goods(3)

  // Step 2
  goal_lod2 = set_transportet_goods(4)

  // Step 3
  goal_lod3 = set_transportet_goods(5)

  // Step 4
  goal_lod4 = set_transportet_goods(6)

  pass_count = 0
  transfer_pass = 0

  function load_limits(city)  //Load all limits for citys
  {
    local list = []
    local c_nw = city.get_pos_nw()
    local c_se = city.get_pos_se()

    list.push({a = c_nw, b = c_se})                                       // N
    list.push({a =  coord(c_nw.x, c_se.y), b = coord(c_se.x, c_nw.y)})    // W
    list.push({a = c_se, b = c_nw})                                       // S
    list.push({a =  coord(c_se.x, c_nw.y), b = coord(c_nw.x, c_se.y)})    // E

    return list
  }

  function start_chapter()  //Inicia solo una vez por capitulo
  {

    cty1.name = get_city_name(city3_tow)
    local cty_buil1 = my_tile(city3_tow).find_object(mo_building).get_city()
    c_cty_lim1 = load_limits(cty_buil1)

    cty2.name = get_city_name(city4_tow)
    local cty_buil2 = my_tile(city4_tow).find_object(mo_building).get_city()
    c_cty_lim2 = load_limits(cty_buil2)

    cty3.name = get_city_name(city5_tow)
    local cty_buil3 = my_tile(city5_tow).find_object(mo_building).get_city()
    c_cty_lim3 = load_limits(cty_buil3)

    cty4.name = get_city_name(city6_tow)
    local cty_buil4 = my_tile(city6_tow).find_object(mo_building).get_city()
    c_cty_lim4 = load_limits(cty_buil4)

    compass_nr = my_compass()

    /*
    //Debug ---------------------------------------------------------------
    local opt = 0
    local del = false
    local text = "X"
    local nr = my_compass()

    my_tile(c_cty_lim1[nr].a).mark()
    my_tile(c_cty_lim1[nr].b).mark()

    label_bord(c_cty_lim1[nr].a, c_cty_lim1[nr].b, opt, del, text)
    //---------------------------------------------------------------
    */

    return 0
  }

  function set_goal_text(text){

    switch (this.step) {
      case 1:
        local t = ch7_rail_stations[0]
        local halt = t.get_halt()
        text.name = t.href(""+halt.get_name()+" ("+coord3d_to_string(t)+")")+""
        text.city = city3_tow.href(""+cty1.name +" ("+city3_tow.tostring()+")")+""
        text.load = goal_lod1
        break

      case 2:
        local t = ch7_rail_stations[1]
        local halt = t.get_halt()
        text.name = t.href(""+halt.get_name()+" ("+coord3d_to_string(t)+")")+""
        text.city = city4_tow.href(""+cty2.name +" ("+city4_tow.tostring()+")")+""
        text.load =  goal_lod2
        break

      case 3:
        local t = ch7_rail_stations[2]
        local halt = t.get_halt()
        text.name = t.href(""+halt.get_name()+" ("+coord3d_to_string(t)+")")+""
        text.city = city5_tow.href(""+cty3.name +" ("+city5_tow.tostring()+")")+""
        text.load =  goal_lod3
        break

      case 4:
        local t = ch7_rail_stations[3]
        local halt = t.get_halt()
        text.name = t.href(""+halt.get_name()+" ("+coord3d_to_string(t)+")")+""
        text.city = city6_tow.href(""+cty4.name +" ("+city6_tow.tostring()+")")+""
        text.load =  goal_lod4
        break

      case 5:
        break
    }
    text.get_load = load
    return text
  }

  function is_chapter_completed(pl) {
    persistent.ch_max_steps = 4
    local chapter_step = persistent.step
    persistent.ch_max_sub_steps = 0 // count all sub steps
    persistent.ch_sub_step = 0  // actual sub step

    switch (this.step) {
      case 1:
        if (!correct_cov)
          return 0

        local tile = check_halt_wt(ch7_rail_stations[0], wt_road)
        if ( tile != null ) {
          if ( pass_count == 0 ) {
            transfer_pass = cov_pax(ch7_rail_stations[0], gl_wt, gl_good)
            pass_count++
          }
          load = cov_pax(tile, gl_wt, gl_good) - transfer_pass
        }
        if(load>goal_lod1){
          load = 0
          transfer_pass = 0
          pass_count = 0
          this.next_step()
        }
        //return 5
        break;

      case 2:
        if (!correct_cov)
          return 0

        local tile = check_halt_wt(ch7_rail_stations[1], wt_road)
        if ( tile != null ) {
          if ( pass_count == 0 ) {
            transfer_pass = cov_pax(ch7_rail_stations[1], gl_wt, gl_good)
            pass_count++
          }
          load = cov_pax(tile, gl_wt, gl_good) - transfer_pass
        }
        if(load>goal_lod2){
          load = 0
          transfer_pass = 0
          pass_count = 0
          this.next_step()
        }
        //return 25
        break;

      case 3:
        if (!correct_cov)
          return 0

        local tile = check_halt_wt(ch7_rail_stations[2], wt_road)
        if ( tile != null ) {
          if ( pass_count == 0 ) {
            transfer_pass = cov_pax(ch7_rail_stations[2], gl_wt, gl_good)
            pass_count++
          }
          load = cov_pax(tile, gl_wt, gl_good) - transfer_pass
        }
        if(load>goal_lod3){
          load = 0
          transfer_pass = 0
          pass_count = 0
          this.next_step()
        }
        //return 50
        break;

      case 4:
        if (!correct_cov)
          return 0

        local tile = check_halt_wt(ch7_rail_stations[3], wt_road)
        if ( tile != null ) {
          if ( pass_count == 0 ) {
            transfer_pass = cov_pax(ch7_rail_stations[3], gl_wt, gl_good)
            pass_count++
          }
          load = cov_pax(tile, gl_wt, gl_good) - transfer_pass
        }
        if(load>goal_lod4){
          load = 0
          transfer_pass = 0
          pass_count = 0
          this.next_step()
        }
        //return 75
        break;
    }
    local percentage = chapter_percentage(persistent.ch_max_steps, chapter_step, persistent.ch_max_sub_steps, persistent.ch_sub_step)
    return percentage
  }

  function is_work_allowed_here(pl, tool_id, name, pos, tool) {
    //local result=null // null is equivalent to 'allowed'
    local t = tile_x(pos.x, pos.y, pos.z)
    //local way = t.find_object(mo_way)
    local nr = compass_nr

    // inspections tool
    if (tool_id==4096)
      return null

    switch (this.step) {
      case 1:

        if ((pos.x>=c_cty_lim1[nr].a.x-(1))&&(pos.y>=c_cty_lim1[nr].a.y-(1))&&(pos.x<=c_cty_lim1[nr].b.x+(1))&&(pos.y<=c_cty_lim1[nr].b.y+(1))){
          return null
        }
        else
          return translate("You can only use this tool in the city")+ " " + cty1.name.tostring()+" ("+city3_tow.tostring()+")."
      break;

      case 2:

        if ((pos.x>=c_cty_lim2[nr].a.x-(1))&&(pos.y>=c_cty_lim2[nr].a.y-(1))&&(pos.x<=c_cty_lim2[nr].b.x+(1))&&(pos.y<=c_cty_lim2[nr].b.y+(1))){
          return null
        }
        else
          return translate("You can only use this tool in the city")+cty2.name.tostring()+" ("+city4_tow.tostring()+")."
      break;

      case 3:

        if ((pos.x>=c_cty_lim3[nr].a.x-(1))&&(pos.y>=c_cty_lim3[nr].a.y-(1))&&(pos.x<=c_cty_lim3[nr].b.x+(1))&&(pos.y<=c_cty_lim3[nr].b.y+(1))){
          return null
        }
        else
          return translate("You can only use this tool in the city")+cty3.name.tostring()+" ("+city5_tow.tostring()+")."
      break;

      case 4:

        if ((pos.x>=c_cty_lim4[nr].a.x-(1))&&(pos.y>=c_cty_lim4[nr].a.y-(1))&&(pos.x<=c_cty_lim4[nr].b.x+(1))&&(pos.y<=c_cty_lim4[nr].b.y+(1))){
          return null
        }
        else
          return translate("You can only use this tool in the city")+cty4.name.tostring()+" ("+city6_tow.tostring()+")."
      break;

    }

    return tool_id
  }

  function is_schedule_allowed(pl, schedule) {
    return null
  }

  function is_convoy_allowed(pl, convoy, depot)
  {
    if(this.step>4)
      return null

    local result=null // null is equivalent to 'allowed'
    //Check load type
    local good_nr = 0 //Passengers
    local good = convoy.get_goods_catg_index()
    for(local j=0;j<good.len();j++){
      if(good[j]!=good_nr)
        return translate("The bus must be [Passengers].")
    }
    if (result == null){
      ignore_save.push({id = convoy.id, ig = true})  //Ingnora el vehiculo
      return null
    }
    return get_message(3) //translate("It is not allowed to start vehicles.")
  }

  function script_text()
  {
    return null
  }

  function is_tool_active(pl, tool_id, wt) {
    local result = true
    return result
  }

  function is_tool_allowed(pl, tool_id, wt){
    if(this.step>4)
      return true

    local gt_list = [ t_icon.tram, t_icon.rail ]
    foreach (id in gt_list){
      if(id == tool_id)
        return false
    }
    local result = true
    return result
  }

}        // END of class

// END OF FILE
