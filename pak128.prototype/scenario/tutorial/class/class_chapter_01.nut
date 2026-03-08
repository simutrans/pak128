/** @file class_chapter_01.nut
  * @brief Basic information about Simutrans
  */

/**
  * @class tutorial.chapter_01
  * @brief class_chapter_01.nut
  * Basic information about Simutrans
  *
  * Can NOT be used in network game !
  *
  */
class tutorial.chapter_01 extends basic_chapter
{
  chapter_name  = ch1_name
  chapter_coord = coord_chapter_1
  startcash     = 500000          // pl=0 startcash; 0=no reset

  comm_script = false

  // Step 2 =====================================================================================
  c_test = coord3d(0,0,1)

  // Step 3 =====================================================================================
  buil1_name = "" //auto started
  buil2_name = "" //auto started
  buil2_list = null //auto started
  c_list_mon = null // tile list mon
  c_list_cur = null // tile list cur

  // Step 4 =====================================================================================
  cit_list = null //auto started
  cty1 = {name = ""}

  function start_chapter()  //Inicia solo una vez por capitulo
  {
    cty1.name = get_city_name(city1_tow)
    local t = my_tile(city1_tow)
    local buil = t.find_object(mo_building)
    cit_list = buil ? buil.get_tile_list() : null

    t = my_tile(city1_mon)
    buil = t.find_object(mo_building)
    buil1_name = buil ? translate(buil.get_name()):"No existe"
    c_list_mon = buil.get_tile_list()

    t = my_tile(city1_cur)
    buil = t.find_object(mo_building)
    buil2_name = buil ? translate(buil.get_name()):"No existe"
    c_list_cur = buil.get_tile_list()

    //gui.add_message("city1_post_halts " + city1_post_halts.len())

    return 0
  }

  function set_goal_text(text){
    switch (this.step) {
      case 1:
        text.pos = city1_tow.href("("+city1_tow.tostring()+")")
        text.pos1 = city1_tow.href(""+translate(ch1_text1)+" ("+city1_tow.tostring()+")")
        text.pos2 = coord_fac_1.href(""+translate(ch1_text2)+" ("+coord_fac_1.tostring()+")")
        text.pos3 = coord_st_1.href(""+translate(ch1_text3)+" ("+coord_st_1.tostring()+")")
        text.link = "<a href='script:script_text()'>"+translate(ch1_text4)+"  >></a>"
        text.next_step = translate("Go to next step")
      break;
      case 3:
        text.pos = "<a href=\"("+city1_mon.x+","+city1_mon.y+")\">"+buil1_name+" ("+city1_mon.tostring()+")</a>"
        text.buld_name = "<a href=\"("+city1_cur.x+","+city1_cur.y+")\">"+buil2_name+" ("+city1_cur.tostring()+")</a>"
      break;
      case 4:
        text.pos2 = "<a href=\"("+city1_tow.x+","+city1_tow.y+")\">" + translate(ch1_text5)+" ("+city1_tow.tostring()+")</a>"
      break;

    }

    // set image for buttons by different in paksets
    text.img_grid = get_gui_img("grid")
    text.img_display = get_gui_img("display")

    text.town = cty1.name
    text.tool1 =  translate(tool_alias.inspe)
    return text
  }

  function is_chapter_completed(pl) {
    persistent.ch_max_steps = 4
    local chapter_step = persistent.step
    persistent.ch_max_sub_steps = 0 // count all sub steps
    persistent.ch_sub_step = 0  // actual sub step

    local txt=c_test.tostring()
    switch (this.step) {
      case 1:
        if (pot[0] == 1) {
          this.next_step()
        }
        //return chapter_percentage(persistent.ch_max_steps, 1, 0, 0)
        break

      case 2:
        if (txt!="0,0,1" || pot[0] == 1) {
          //Creea un cuadro label
          local opt = 0
          local del = false
          local text = "X"
          label_bord(city1_limit1.a, city1_limit1.b, opt, del, text)
          this.next_step()
        }
        //return chapter_percentage(persistent.ch_max_steps, 2, 0, 0)
        break

      case 3:
        local next_mark = true
        local c_list1 = [my_tile(city1_mon)]
        local c_list2 = [my_tile(city1_cur)]
        local stop_mark = true
        if (pot[0]==0) {
          try {
             next_mark = delay_mark_tile(c_list_mon)
          }
          catch(ev) {
            return 0
          }
        }
        else if (pot[0]==1 && pot[1]==0) {
          try {
             next_mark = delay_mark_tile(c_list_mon, stop_mark)
          }
          catch(ev) {
            return 0
          }
          pot[1]=1
        }
        if (pot[1]==1 && pot[2]==0) {
          try {
             next_mark = delay_mark_tile(c_list_cur)
          }
          catch(ev) {
            return 0
          }
        }
        else if (pot[2]==1 && pot[3]==0) {
          try {
             next_mark = delay_mark_tile(c_list_cur, stop_mark)
          }
          catch(ev) {
            return 0
          }
          pot[3]=1
        }
        if (pot[3]==1 && pot[4]==0){
          comm_script = false
          this.next_step()
        }
        //return chapter_percentage(persistent.ch_max_steps, 3, 0, 0)
        break
      case 4:
        local next_mark = true
        local list = cit_list
        local stop_mark = true

        try {
           next_mark = delay_mark_tile(list)
        }
        catch(ev) {
          return 0
        }
        if (pot[0] == 1 && next_mark) {
          next_mark = delay_mark_tile(list, stop_mark)
          comm_script = false
          this.next_step()
        }
        break
      case 5:
        persistent.step=1
        persistent.status.step = 1
        //return 100
        break

    }
    local percentage = chapter_percentage(persistent.ch_max_steps, chapter_step, persistent.ch_max_sub_steps, persistent.ch_sub_step)
    return percentage
  }

  function is_work_allowed_here(pl, tool_id, name, pos, tool) {
    local label = tile_x(pos.x,pos.y,pos.z).find_object(mo_label)
    local result=null // null is equivalent to 'allowed'

    result = get_message(2)

    switch (this.step) {
      case 1:
        break
      case 2:
        break
      case 3:
        if(tool_id == 4096) {
          if(pot[0]==0){
            if ( pos.x == city1_mon.x && pos.y == city1_mon.y ) {
              pot[0] = 1
              return null
            }
          }
          else if ( pot[1] == 1 && pot[2] == 0 ) {
            if ( search_tile_in_tiles(c_list_cur, pos) ) {
              pot[2] = 1
              return null
            }
          }
        }
        break
      case 4:
        if (tool_id == 4096){
          if ( search_tile_in_tiles(cit_list, pos) ) {
            pot[0] = 1
            return null
          }
        }
        break
    }
    if (tool_id == 4096){
      if (label && label.get_text()=="X")
        //local message = get_tile_message(5, pos.x, pos.y)
        //return message
        return get_tile_message(5, pos) //translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."
      else if (label)
        return translate("Text label")+" ("+pos.tostring()+")."
      result = null // Always allow query tool
    }
    if (label && label.get_text()=="X")
      return get_tile_message(5, pos) //translate("Indicates the limits for using construction tools")+" ("+pos.tostring()+")."

    return result
  }

  function is_tool_active(pl, tool_id, wt) {
    local result = true
    return result
  }

  function is_tool_allowed(pl, tool_id, wt){
    local result = true
    return result
  }

  function script_text()
  {
    if (this.step==1){
      pot[0]=1
    }
    else if (this.step==2){
      pot[0] = 1
    }
    else if(this.step==3){
      comm_script = true
      //Creea un cuadro label
      local opt = 0
      local del = false
      local text = "X"
      label_bord(city1_limit1.a, city1_limit1.b, opt, del, text)
      pot[0]=1
      pot[2]=1
    }
    else if (this.step==4){
      comm_script = true
      pot[0] = 1
    }
    return null
  }
}        // END of class

// END OF FILE
