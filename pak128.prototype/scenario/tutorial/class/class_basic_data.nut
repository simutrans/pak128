/** @file class_basic_data.nut
  * @brief sets the pakset specific data
  *
  * all object names correspond to the names in the dat files
  *
  */

/// placeholder for tools names in simutrans
tool_alias  <- {inspe = "Abfrage", road= "ROADTOOLS", rail = "RAILTOOLS", ship = "SHIPTOOLS", land = "SLOPETOOLS", spec = "SPECIALTOOLS"}

/// placeholder for good names in pak64
good_alias  <- {mail = "Post", passa= "Passagiere", goods = "Goods", wood = "Holz", plan = "Bretter", coal = "Kohle", oel = "Oel" , gas = "Gasoline"}

/**
  * placeholder for shortcut keys names
  *
  * @param string pak name
  */
  switch (pak_name) {
    case "pak64":
      key_alias  <- {plus_s = "+", minus_s = "-"}
      break
    case "pak64.german":
      key_alias  <- {plus_s = "+", minus_s = "-"}
      break
    case "pak128":
      key_alias  <- {plus_s = "Home", minus_s = "End"}
      break
  }

/**
  * factory_data list the factory data
  *
  * list factory_data ( id, { translate name, tile list, tile_x(0, 0) } )
  */
factory_data <- {}
function get_factory_data(id) {
  local t = factory_data.rawget(id)
  return t
}

/**
  * translate factorys raw name in to game language by start scenario
  *
  * set factory_data{}
  *
  */
function rename_factory_names() {

  local list = factory_list_x()
  foreach(factory in list) {
    // factory is an instance of the factory_x class
    local f_tile = factory.get_tile_list()
    local f_name = factory_x(f_tile[0].x, f_tile[0].y).get_desc().get_name()
    //gui.add_message("Current: "+factory_x(f_tile[0].x, f_tile[0].y).get_desc().get_name()+" translate: "+translate(f_name))

    factory_x(f_tile[0].x, f_tile[0].y).set_name(translate(f_name))

    if ( search_tile_in_tiles(f_tile, coord_fac_1) ) {
      // Timber plantation
      //translate_objects_list.rawset("fac_1_name", translate(f_name))
      local t = factory_x(f_tile[0].x, f_tile[0].y).get_tile_list()
      local f = factory_x(f_tile[0].x, f_tile[0].y).get_fields_list()
      t.extend(f)

      factory_data.rawset("1", {name = translate(f_name), c_list = t, c = coord(f_tile[0].x, f_tile[0].y)})
      /*local d = factory_data.rawget("1")
      gui.add_message("factory_data rawin: "+factory_data.rawin("1"))
      gui.add_message("factory_data d.rawin: "+d.rawget("c_list"))
      //factory_data.1.rawset(")*/
    }
    if ( search_tile_in_tiles(f_tile, coord_fac_2) ) {
      // Saw mill
      translate_objects_list.rawset("fac_2_name", translate(f_name))
      local t = factory_x(f_tile[0].x, f_tile[0].y).get_tile_list()
      factory_data.rawset("2", {name = translate(f_name), c_list = t, c = coord(f_tile[0].x, f_tile[0].y)})
    }
    if ( search_tile_in_tiles(f_tile, coord_fac_3) ) {
      // Construction Wholesaler
      translate_objects_list.rawset("fac_3_name", translate(f_name))
      local t = factory_x(f_tile[0].x, f_tile[0].y).get_tile_list()
      factory_data.rawset("3", {name = translate(f_name), c_list = t, c = coord(f_tile[0].x, f_tile[0].y)})
    }
    if ( search_tile_in_tiles(f_tile, coord_fac_4) ) {
      // Oil rig
      translate_objects_list.rawset("fac_4_name", translate(f_name))
      local t = factory_x(f_tile[0].x, f_tile[0].y).get_tile_list()
      factory_data.rawset("4", {name = translate(f_name), c_list = t, c = coord(f_tile[0].x, f_tile[0].y)})
    }
    if ( search_tile_in_tiles(f_tile, coord_fac_5) ) {
      // Oil refinery
      translate_objects_list.rawset("fac_5_name", translate(f_name))
      local t = factory_x(f_tile[0].x, f_tile[0].y).get_tile_list()
      factory_data.rawset("5", {name = translate(f_name), c_list = t, c = coord(f_tile[0].x, f_tile[0].y)})
    }
    if ( search_tile_in_tiles(f_tile, coord_fac_6) ) {
      // Gas station
      translate_objects_list.rawset("fac_6_name", translate(f_name))
      local t = factory_x(f_tile[0].x, f_tile[0].y).get_tile_list()
      factory_data.rawset("6", {name = translate(f_name), c_list = t, c = coord(f_tile[0].x, f_tile[0].y)})
    }
    if ( search_tile_in_tiles(f_tile, coord_fac_7) ) {
      // Coal mine
      translate_objects_list.rawset("fac_7_name", translate(f_name))
      local t = factory_x(f_tile[0].x, f_tile[0].y).get_tile_list()
      factory_data.rawset("7", {name = translate(f_name), c_list = t, c = coord(f_tile[0].x, f_tile[0].y)})
    }
    if ( search_tile_in_tiles(f_tile, coord_fac_8) ) {
      // Coal power station
      translate_objects_list.rawset("fac_8_name", translate(f_name))
      local t = factory_x(f_tile[0].x, f_tile[0].y).get_tile_list()
      factory_data.rawset("8", {name = translate(f_name), c_list = t, c = coord(f_tile[0].x, f_tile[0].y)})
    }

  }

  /*local fab_list = [  factory_data.rawin("1"),
                factory_data.rawin("2"),
                factory_data.rawin("3"),
                factory_data.rawin("4"),
                factory_data.rawin("5"),
                factory_data.rawin("6"),
                factory_data.rawin("7"),
                factory_data.rawin("8")
    ]*/
/*
      gui.add_message(player_x(1), "factory_data len: "+factory_data.len())

      gui.add_message(player_x(1), "factory_data rawin 1: "+factory_data.rawin("1"))
      gui.add_message(player_x(1), "factory_data rawin 2: "+factory_data.rawin("2"))
      gui.add_message(player_x(1), "factory_data rawin 3: "+factory_data.rawin("3"))
      gui.add_message(player_x(1), "factory_data rawin 4: "+factory_data.rawin("4"))
      gui.add_message(player_x(1), "factory_data rawin 5: "+factory_data.rawin("5"))
      gui.add_message(player_x(1), "factory_data rawin 6: "+factory_data.rawin("6"))
      gui.add_message(player_x(1), "factory_data rawin 7: "+factory_data.rawin("7"))
      gui.add_message(player_x(1), "factory_data rawin 8: "+factory_data.rawin("8"))

      gui.add_message(player_x(1), "coord_fac_1: "+coord_to_string(coord_fac_1))
*/
}

/**
  * array to translate texts from simutrans programm
  *
  * set translate_objects_list
  */
function translate_objects() {

  //translate_objects_list.inspec <- translate("Abfrage")
  translate_objects_list.rawset("inspec", translate("Abfrage"))

  translate_objects_list.rawset("tools_road", translate("ROADTOOLS"))
  translate_objects_list.rawset("tools_rail", translate("RAILTOOLS"))
  translate_objects_list.rawset("tools_ship", translate("SLOPETOOLS"))
  translate_objects_list.rawset("tools_special", translate("SPECIALTOOLS"))
  translate_objects_list.rawset("tools_slope", translate("SLOPETOOLS"))

  translate_objects_list.rawset("depot_road", translate("CarDepot"))
  translate_objects_list.rawset("depot_rail", translate("TrainDepot"))
  translate_objects_list.rawset("depot_ship", translate("ShipDepot"))
  translate_objects_list.rawset("depot_air", translate("1930AirDepot"))

  translate_objects_list.rawset("good_goods", translate("Goods"))

  translate_objects_list.rawset("good_mail", translate("Post"))
  translate_objects_list.rawset("good_passa", translate("Passagiere"))
  translate_objects_list.rawset("good_wood", translate("Holz"))
  translate_objects_list.rawset("good_plan", translate("Bretter"))
  translate_objects_list.rawset("good_coal", translate("Kohle"))
  translate_objects_list.rawset("good_oil", translate("Oel"))
  translate_objects_list.rawset("good_gas", translate("Gasoline"))

  // set toolbar with powerline tools
  if ( pak_name == "pak64.german" ) {
    translate_objects_list.rawset("tools_power", translate("POWERLINE"))
    translate_objects_list.rawset("tools_mail_extension", translate("EXTENSIONS"))
    translate_objects_list.rawset("tools_road_stations", translate("ROADSTATIONS"))
  } else {
    translate_objects_list.rawset("tools_power", translate("SPECIALTOOLS"))
    translate_objects_list.rawset("tools_mail_extension", translate("SPECIALTOOLS"))
    translate_objects_list.rawset("tools_road_stations", translate("ROADTOOLS"))
  }
  //gui.add_message("Current: "+translate_objects_list.inspec)

  // tools
  translate_objects_list.rawset("public_stop", translate("Make way or stop public (will join with neighbours), %i times maintainance"))

  rename_factory_names()
}

/**
  * vehicle for chapter 2 step 4, 6, 7
  *
  * @return string object name
  */
function get_veh_ch2_st4() {
  switch (pak_name) {
    case "pak64":
      return "BuessingLinie"
      break
    case "pak64.german":
      return "BuessingLinie"
      break
    case "pak128":
      return "S_Kroytor_LiAZ-677"
      break
  }

}

/**
  * set objects for chapter 2
  *
  * @param integer id
  *  @li id 1 = way name
  *  @li id 2 = bridge name
  *  @li id 3 = stations name
  *
  * @return object raw name
  */
function get_obj_ch2(id) {
  switch (pak_name) {
    case "pak64":
      switch (id) {
        case 1:
          return "mip_cobblestone_road"
          break
        case 2:
          return "tb_classic_road"
          break
        case 3:
          return "BusStop"
          break
      }
      break
    case "pak64.german":
      switch (id) {
        case 1:
          return "asphalt_road"
          break
        case 2:
          return "ClassicRoad"
        break
        case 3:
          return "BusHalt_1"
          break
      }
      break
    case "pak128":
      switch (id) {
        case 1:
          return "Road_050"
          break
        case 2:
          return "Road_070_Bridge"
          break
        case 3:
          return "medium_classic_bus_stop"
          break
      }
      break
  }
}

/**
  * vehicle for chapter 3
  *
  * @param integer id
  *  @li id 1 = step 5 loco
  *  @li id 2 = step 7 loco
  *  @li id 3 = step 11 loco
  *  @li id 4 = step 5 wag
  *  @li id 5 = step 7 wag
  *  @li id 6 = step 11 wag
  *
  * @return object raw name
  */
function get_veh_ch3(id) {
  switch (pak_name) {
    case "pak64":
      switch (id) {
        case 1:
          return "3Diesellokomotive"
          break
        case 2:
          return "3Diesellokomotive"
          break
        case 3:
          return "NS1000"
          break
        case 4:
          return "Holzwagen"
          break
        case 5:
          return "Holzwagen"
          break
        case 6:
          return "TPPassagierwagen"
          break
      }
    break
    case "pak64.german":
      switch (id) {
        case 1:
          return "1Diesellokomotive"
          break
        case 2:
          return "1Diesellokomotive"
          break
        case 3:
          return "E41"
          break
        case 4:
          return "Bretterwagen"
          break
        case 5:
          return "Bretterwagen"
          break
        case 6:
          return "Bn_original"
          break
      }
      break
    case "pak128":
      switch (id) {
        case 1:
          return "Haru_F7A"
          break
        case 2:
          return "Haru_F7A"
          break
        case 3:
          return "Renfe_279_(Benemerita)"
          break
        case 4:
          return "Holzwagen_0"
          break
        case 5:
          return "Holzwagen_0"
          break
        case 6:
          return "Passanger_waggon_2"
          break
      }
    break
  }

}

/**
  * objects for chapter 3
  *
  * @param integer id
  *  @li id 1 = way name
  *  @li id 2 = bridge name
  *  @li id 3 = stations name
  *  @li id 4 = -
  *  @li id 5 = tunnel name
  *  @li id 6 = signal name
  *  @li id 7 = overheadpower name
  *
  * @return object raw name
  */
function get_obj_ch3(id) {
  switch (pak_name) {
    case "pak64":
      switch (id) {
        case 1:
          return "wooden_sleeper_track"
          break
        case 2:
          return "ClassicRail"
          break
        case 3:
          return "FreightTrainStop"
          break
        case 4:
          return ""
          break
        case 5:
          return "RailTunnel"
          break
        case 6:
          return "Signals"
          break
        case 7:
          return "SlowOverheadpower"
          break
      }
      break
    case "pak64.german":
      switch (id) {
        case 1:
          return "Gleis_140"
          break
        case 2:
          return "ClassicRail"
        break
        case 3:
          return "MHzPS2FreightTrainStop"
          break
        case 4:
          return ""
          break
        case 5:
          return "RailTunnel_2"
          break
        case 6:
          return "Signals"
          break
        case 7:
          return "SlowOverheadpower"
          break
      }
      break
    case "pak128":
      switch (id) {
        case 1:
          return "Rail_140_Tracks"
          break
        case 2:
          return "Rail_100_Bridge"
          break
        case 3:
          return "Container1TrainStop"
          break
        case 4:
          return ""
          break
        case 5:
          return "Rail_140_Tunnel"
          break
        case 6:
          return "Signals"
          break
        case 7:
          return "grey_type_catenary"
          break
      }
      break
  }
}

/**
  * vehicle for chapter 4
  *
  * @param integer id
  *  @li id 1 = step 4 ship
  *  @li id 2 = step 7 ship
  *
  * @return object raw name
  */
function get_veh_ch4(id) {
  switch (pak_name) {
    case "pak64":
      switch (id) {
        case 1:
          return "EnCo_Oil_Ship"
          break
        case 2:
          return "SlowFerry"
          break
      }
      break
    case "pak64.german":
      switch (id) {
        case 1:
          return "Oeltankschiff"
          break
        case 2:
          return "Ferry"
          break
      }
      break
    case "pak128":
      switch (id) {
        case 1:
          return "MHz-OT5_Oil_Barge"
          break
        case 2:
          return "MV_Balmoral"
          break
      }
    break
  }

}

/**
  * objects for chapter 4
  *
  * @param integer id
  *  @li id 1 = -
  *  @li id 2 = harbour 1 name (good)
  *  @li id 3 = cannel stop name
  *  @li id 4 = harbour 2 name (passenger)
  *
  * @return string object name
  */
function get_obj_ch4(id) {
  switch (pak_name) {
    case "pak64":
      switch (id) {
        case 1:
          return ""
          break
        case 2:
          return "LargeShipStop"
          break
        case 3:
          return "ChannelStop"
          break
        case 4:
          return "ShipStop"
          break
      }
      break
    case "pak64.german":
      switch (id) {
        case 1:
          return ""
          break
        case 2:
          return "LargeShipStop"
        break
        case 3:
          return "ChannelStop"
          break
        case 4:
          return "ShipStop"
          break
      }
      break
    case "pak128":
      switch (id) {
        case 1:
          return ""
          break
        case 2:
          return "Long_Goods_Dock"
          break
        case 3:
          return "canal_ware_stop"
          break
        case 4:
          return "ShipStop"
          break
      }
      break
  }
}

/**
  * vehicle for chapter 5
  *
  * @param integer id
  *  @li id 1 = step 2 truck (coal)
  *  @li id 2 = step 2 truck trail (coal)
  *  @li id 3 = step 4 truck (post)
  *  @li id 4 = step 4 ship (post)
  *
  * @return string object name
  */
function get_veh_ch5(id) {
  switch (pak_name) {
    case "pak64":
      switch (id) {
        case 1:
          return "Kohletransporter"
          break
        case 2:
          return "Kohleanhaenger"
          break
        case 3:
          return "Posttransporter"
          break
        case 4:
          return "Postschiff"
          break
      }
      break
    case "pak64.german":
      switch (id) {
        case 1:
          return "Buessing_B8000_catg2"
          break
        case 2:
          return "anhaenger_catg2"
          break
        case 3:
          return "Post_Opel"
          break
        case 4:
          return "Tugboat"
          break
      }
      break
    case "pak128":
      switch (id) {
        case 1:
          return "PMNV_50_Mack"
          break
        case 2:
          return "PMNV_Mack_Bulk_Trailer_0"
          break
        case 3:
          return "RVg_Post_Truck_1"
          break
        case 4:
          return "Post_Barge"
          break
      }
      break
  }

}

/**
  * objects for chapter 5
  *
  * @param integer id
  *  @li id 1 = road way name
  *  @li id 2 = truck stop name (good)
  *  @li id 3 = -
  *  @li id 4 = powerline transformer
  *
  * @return string object name
  */
function get_obj_ch5(id) {
  switch (pak_name) {
    case "pak64":
      switch (id) {
        case 1:
          return "asphalt_road"
          break
        case 2:
          return "CarStop"
          break
        case 3:
          return ""
          break
        case 4:
          return "Aufspanntransformator"
          break
      }
      break
    case "pak64.german":
      switch (id) {
        case 1:
          return "asphalt_road"
          break
        case 2:
          return "LKW_Station_1"
        break
        case 3:
          return ""
          break
        case 4:
          return "Aufspanntransformator" //PowerSource
          break
      }
      break
    case "pak128":
      switch (id) {
        case 1:
          return "Road_070"
          break
        case 2:
          return "CarStop"
          break
        case 3:
          return ""
          break
        case 4:
          return "Aufspanntransformator"
          break
      }
      break
  }
}

/**
  * vehicle for chapter 6
  *
  * @param integer id
  *  @li id 1 = step 2 airplane (passenger)
  *  @li id 2 = step 3 bus
  *  @li id 3 = step 4 bus
  *
  * @return string object name
  */
function get_veh_ch6(id) {
  switch (pak_name) {
    case "pak64":
      switch (id) {
        case 1:
          return "Fokker_F27"
          break
        case 2:
          return "BuessingLinie"
          break
        case 3:
          return "BuessingLinie"
          break
      }
      break
    case "pak64.german":
      switch (id) {
        case 1:
          return "DC-3"
          break
        case 2:
          return "OpelBlitz"
          break
        case 3:
          return "OpelBlitz"
          break
      }
      break
    case "pak128":
      switch (id) {
        case 1:
          return "SAC-Lockheed_Constellation_128_set"
          break
        case 2:
          return "S_Kroytor_LiAZ-677"
          break
        case 3:
          return "S_Kroytor_LiAZ-677"
          break
      }
      break
  }

}

/**
  * objects for chapter 6
  *
  * @param integer id
  *  @li id 1 = runway name
  *  @li id 2 = taxiway name
  *  @li id 3 = air stop name
  *  @li id 4 = air extension name
  *
  * @return string object name
  */
function get_obj_ch6(id) {
  switch (pak_name) {
    case "pak64":
      switch (id) {
        case 1:
          return "runway_modern"
          break
        case 2:
          return "taxiway"
          break
        case 3:
          return "AirStop"
          break
        case 4:
          return "Terminal1930"
          break
      }
      break
    case "pak64.german":
      switch (id) {
        case 1:
          return "runway_modern"
          break
        case 2:
          return "taxiway"
        break
        case 3:
          return "AirStop"
          break
        case 4:
          return "Terminal1930"
          break
      }
      break
    case "pak128":
      switch (id) {
        case 1:
          return "runway_modern"
          break
        case 2:
          return "air_movement_area"
          break
        case 3:
          return "AirStop_AirportBlg"
          break
        case 4:
          return "Terminal1950_AirportBlg_S"
          break
      }
      break
  }
}

/**
  * count wg for train
  *
  * @param integer id
  *  @li id 1 - chapter 3 : train good Holz
  *  @li id 2 - chapter 3 : train good Bretter
  *  @li id 3 - chapter 3 : train good Passagiere
  *
  * @return integer count
  */
function set_train_lenght(id) {

  switch (pak_name) {
    case "pak64":
      switch (id) {
        case 1:
          return 5
          break
        case 2:
          return 5
        break
        case 3:
          return 7
          break
      }
      break
    case "pak64.german":
      switch (id) {
        case 1:
          return 4
          break
        case 2:
          return 4
        break
        case 3:
          return 5
          break
      }
      break
    case "pak128":
      switch (id) {
        case 1:
          return 5
          break
        case 2:
          return 5
        break
        case 3:
          return 7
          break
      }
      break
  }
}

/**
  * count convoys for line
  *
  * @param integer id
  *  @li id  1 - chapter 2 : city1_halt_1 - halts city 1
  *  @li id  2 - chapter 2 : city1_halt_2 - halts connect city 1 dock and station
  *  @li id  3 - chapter 2 : city2_halt_1 - halts connect city 2 to city 1
  *  @li id  4 - chapter 3 : rail factory 1 -> factory 2
  *  @li id  5 - chapter 3 : rail factory 2 -> factory 3
  *  @li id  6 - chapter 3 : ch3_rail_stations - city line
  *  @li id  7 - chapter 4 : ch4_ship1_halts - dock raffinerie - (coord_fac4)
  *  @li id  8 - chapter 4 : ch4_ship2_halts - dock raffinerie - canal stop gas station
  *  @li id  9 - chapter 4 : ch4_ship3_halts - passenger ship
  *  @li id 10 - chapter 5 : road coal to power plant
  *  @li id 11 - chapter 5 : city1_post_halts - halts for post
  *  @li id 12 - chapter 5 : post ship dock - oil rigg
  *  @li id 13 - chapter 6 : city1_city7_air
  *  @li id 14 - chapter 6 : city1_halt_airport
  *  @li id 15 - chapter 6 : city7_halt
  *
  * @return string object name
  */
function set_convoy_count(id) {

  switch (pak_name) {
    case "pak64":
      switch (id) {
        case 1:
          return 1
          break
        case 2:
          return 3
        break
        case 3:
          return 1
          break
        case 4:
          return 1
          break
        case 5:
          return 1
        break
        case 6:
          return 3
          break
        case 7:
          return 2
          break
        case 8:
          return 2
          break
        case 9:
          return 1
          break
        case 10:
          return 10
          break
        case 11:
          return 2
        break
        case 12:
          return 1
          break
        case 13:
          return 1
          break
        case 14:
          return 2
          break
        case 15:
          return 4
          break
      }
      break
    case "pak64.german":
      switch (id) {
        case 1:
          return 1
          break
        case 2:
          return 3
        break
        case 3:
          return 1
          break
        case 4:
          return 1
          break
        case 5:
          return 1
        break
        case 6:
          return 2
          break
        case 7:
          return 2
          break
        case 8:
          return 2
          break
        case 9:
          return 1
          break
        case 10:
          return 7
          break
        case 11:
          return 3
        break
        case 12:
          return 1
          break
        case 13:
          return 1
          break
        case 14:
          return 2
          break
        case 15:
          return 4
          break
      }
      break
    case "pak128":
      switch (id) {
        case 1:
          return 1
          break
        case 2:
          return 3
        break
        case 3:
          return 1
          break
        case 4:
          return 1
          break
        case 5:
          return 1
        break
        case 6:
          return 3
          break
        case 7:
          return 2
          break
        case 8:
          return 2
          break
        case 9:
          return 1
          break
        case 10:
          return 10
          break
        case 11:
          return 3
        break
        case 12:
          return 1
          break
        case 13:
          return 1
          break
        case 14:
          return 2
          break
        case 15:
          return 4
          break
      }
      break
  }
}

/**
  *  Number of goods to be transported
  *
  * @param integer id
  *  @li id 1 - chapter 3 : train good Holz
  *  @li id 2 - chapter 3 : train good Bretter
  *  @li id 3 - chapter 7 : bus city Hepplock
  *  @li id 4 - chapter 7 : bus city Appingbury
  *  @li id 5 - chapter 7 : bus city Hillcross
  *  @li id 6 - chapter 7 : bus city Springville
  *
  * @return integer transport count
  */
function set_transportet_goods(id) {

  switch (pak_name) {
    case "pak64":
      switch (id) {
        case 1:
          return 60
          break
        case 2:
          return 30
        break
        case 3:
          return 20
          break
        case 4:
          return 40
          break
        case 5:
          return 80
          break
        case 6:
          return 160
          break
      }
      break
    case "pak64.german":
      switch (id) {
        case 1:
          return 120
          break
        case 2:
          return 150
        break
        case 3:
          return 35
          break
        case 4:
          return 48
          break
        case 5:
          return 27
          break
        case 6:
          return 55
          break
      }
      break
    case "pak128":
      switch (id) {
        case 1:
          return 60
          break
        case 2:
          return 30
        break
        case 3:
          return 20
          break
        case 4:
          return 40
          break
        case 5:
          return 80
          break
        case 6:
          return 160
          break
      }
      break
  }

}

/**
  * Number of loading capacity
  *
  * @param id
  *  @li id  1 - chapter 2 step  4 : bus city Pollingwick
  *  @li id  2 - chapter 2 step  6 : bus Pollingwick - Dock
  *  @li id  3 - chapter 2 step  7 : bus Pollingwick - Malliby
  *  @li id  4 - chapter 3 step 11 : city train
  *  @li id  5 - chapter 6 step  2 : air city 1 - city 7
  *  @li id  6 - chapter 6 step  3 : bus city 1 - Airport
  *  @li id  7 - chapter 6 step  4 : bus city 7 - Airport
  *  @li id  8 - chapter 5 step  4 : post city 1
  *  @li id  9 - chapter 5 step  4 : post ship oil rig
  *
  * @return integer loading capacity
  */
function set_loading_capacity(id) {

  switch (pak_name) {
    case "pak64":
      switch (id) {
        case 1:
          return 60
          break
        case 2:
          return 100
          break
        case 3:
          return 100
          break
        case 4:
          return 100
          break
        case 5:
          return 100
          break
        case 6:
          return 100
          break
        case 7:
          return 60
          break
        case 8:
          return 60
          break
        case 9:
          return 100
          break
      }
      break
    case "pak64.german":
      switch (id) {
        case 1:
          return 60
          break
        case 2:
          return 60
          break
        case 3:
          return 60
          break
        case 4:
          return 80
          break
        case 5:
          return 100
          break
        case 6:
          return 100
          break
        case 7:
          return 60
          break
        case 8:
          return 60
          break
        case 9:
          return 70
          break
      }
      break
    case "pak128":
      switch (id) {
        case 1:
          return 60
          break
        case 2:
          return 100
          break
        case 3:
          return 100
          break
        case 4:
          return 100
          break
        case 5:
          return 100
          break
        case 6:
          return 100
          break
        case 7:
          return 60
          break
        case 8:
          return 60
          break
        case 9:
          return 100
          break
      }
      break
  }

}

/**
  * Number of waiting time passenger and post
  *
  *  1 day   = 2115<br>
  *  1 hour  = 88
  *
  * @param id
  *  @li id  1 - chapter 2 step  4 : bus city Pollingwick
  *  @li id  2 - chapter 2 step  6 : bus Pollingwick - Dock
  *  @li id  3 - chapter 2 step  7 : bus Pollingwick - Malliby
  *  @li id  4 - chapter 3 step 11 : city train
  *  @li id  5 - chapter 4 step  7 : good ship produser -> consumer
  *  @li id  6 - chapter 5 step  4 : road mail
  *  @li id  7 - chapter 5 step  4 : ship oil rig
  *  @li id  8 - chapter 6 step  2 : air city 1 - city 7
  *  @li id  9 - chapter 6 step  3 : bus city 1 - Airport
  *  @li id 10 - chapter 6 step  4 : bus city 7 - Airport
  *
  * @return integer waiting time
  */
function set_waiting_time(id) {

  switch (pak_name) {
    case "pak64":
      switch (id) {
        case 1:
          return 10571
          break
        case 2:
          return 6343
          break
        case 3:
          return 10571
          break
        case 4:
          return 25369
          break
        case 5:
          return 42282
          break
        case 6:
          return 6343
          break
        case 7:
          return 42282
          break
        case 8:
          return 42282
          break
        case 9:
          return 10571
          break
        case 10:
          return 4230
          break
      }
      break
    case "pak64.german":
      switch (id) {
        case 1:
          return 2115
          break
        case 2:
          return 881
          break
        case 3:
          return 2555
          break
        case 4:
          return 2115
          break
        case 5:
          return 42282
          break
        case 6:
          return 10571
          break
        case 7:
          return 42282
          break
        case 8:
          return 42282
          break
        case 9:
          return 10571
          break
        case 10:
          return 4230
          break
      }
      break
    case "pak128":
      switch (id) {
        case 1:
          return 10571
          break
        case 2:
          return 6345
          break
        case 3:
          return 10571
          break
        case 4:
          return 25369
          break
        case 5:
          return 42282
          break
        case 6:
          return 10571
          break
        case 7:
          return 42282
          break
        case 8:
          return 42282
          break
        case 9:
          return 10571
          break
        case 10:
          return 4230
          break
      }
      break
  }

}

/**
  * good data
  *
  * @param integer id = good id
  * @param integer select = define return data
  *   @li select 1 = translate metric
  *   @li select 2 = raw good name
  *   @li select 3 = translate good name
  *
  * @return
  *   @li integer good metric (select 1)
  *   @li string good raw name (select2)
  *   @li string good translated name (select=3)
  */
function get_good_data(id, select = null) {

  local good_n = null

      switch (id) {
        case 1:
          good_n = "Holz"
          break
        case 2:
          good_n = "Bretter"
          break
        case 3:
          good_n = "Oel"
          break
        case 4:
          good_n = "Gasoline"
          break
        case 5:
          good_n = "Kohle"
          break
        case 6:
          good_n = "Post"
          break
      }

  local obj = good_desc_x(good_n)
  local output = null

      switch (select) {
        case 1:
          output = translate(obj.get_metric())
          break
        case 2:
          output = obj.get_name()
          break
        case 3:
          output = translate(obj.get_name())
          break
        case 4:

          break
        case 5:

          break
      }

  return output
}

/**
  * factory prod and good data for textfiles
  *
  * @param coord tile = tile_x factory
  * @param integer g_id = good name
  * @param string read = "in" / "out"
  *
  * @return array array[base_production, base_consumption, factor]
  */
function read_prod_data(tile, g_id, read = null) {

  // actual not read good data
  local t = square_x(tile.x, tile.y).get_ground_tile()
  local good = get_good_data(g_id, 2)

  local obj = t.find_object(mo_building).get_factory()
  local obj_desc = obj.get_desc()

  local output = [0, 0, 0]

  if ( read == "in" ) {
    foreach(key,value in obj.input) {
      // print raw name of the good
      //gui.add_message("Input slot key: " + key)
      // print current storage
      if ( key == good ) {
        //gui.add_message("get_base_production(): " + value.get_base_production())
        //gui.add_message("get_base_consumption(): " + value.get_base_consumption())
        //gui.add_message("get_consumption_factor(): " + value.get_consumption_factor())

        output[0] = value.get_base_production()
        output[1] = value.get_base_consumption()
        output[2] = value.get_consumption_factor()

        break
      }
    }
  }

  if ( read == "out" ) {
    foreach(key,value in obj.output) {
      // print raw name of the good
      //gui.add_message("Output slot key: " + key)
      // print current storage
      if ( key == good ) {
        //gui.add_message("get_base_production(): " + value.get_base_production())
        //gui.add_message("get_base_consumption(): " + value.get_base_consumption())
        //gui.add_message("get_production_factor(): " + value.get_production_factor())

        output[0] = value.get_base_production()
        output[1] = value.get_base_consumption()
        output[2] = value.get_production_factor()

        break
      }
    }
  }

  return output

}

/**
  * files for more infos
  *
  * @param txt_file
  *  txt_file = bridge - bridge build
  *  txt_file = tunnel - tunnel build
  *  txt_file = info   - more infos for pakset
  *
  * @return ttextfile(file)
  */
function get_info_file(txt_file) {

  //ttextfile("info/build_bridge.txt")
  switch (pak_name) {
    case "pak64":
      switch (txt_file) {
        case "bridge":
          return ""
          break
        case "tunnel":
          return ""
          break
        case "info":
          return ttextfile("info/info_pak64.txt")
          break
      }
      break
    case "pak64.german":
      switch (txt_file) {
        case "bridge":
          return ""
          break
        case "tunnel":
          return ""
          break
        case "info":
          return ttextfile("info/info_pak64perman.txt")
          break
      }
      break
    case "pak128":
      switch (txt_file) {
        case "bridge":
          return ttextfile("info/build_bridge_128.txt")
          break
        case "tunnel":
          return ttextfile("info/build_tunnel_128.txt")
          break
        case "info":
          return ttextfile("info/info_pak128.txt")
          break
      }
      break
  }

}

/**
  * halt id for waiting time in the halt list
  *
  * @param integer id
  *  @li id  1 = city1_halt_1[id]    - halts city 1
  *  @li id  2 = city1_halt_2[id]    - halts connect city 1 dock and station
  *  @li id  3 = city2_halt_1[id]    - halts connect city 2 to city 1
  *  @li id  4 = ch3_rail_stations   - city line
  *  @li id  5 = ch4_ship3_halts     - passenger ship
  *  @li id  6 = city1_city7_air     - airplane
  *  @li id  7 = city1_halt_airport  - bus airport - city 1
  *  @li id  8 = city7_halt          - bus airport - city 7
  *  @li id  9 = city1_post_halts    - road halts for post
  *  @li id 10 = ch5_post_ship_halts - post passenger dock - factory 4 (Oil rigg)
  *
  * @return integer id for halt list
  */
function get_waiting_halt(id) {

  switch (pak_name) {
    case "pak64":
      switch (id) {
        case 1:
          return 2
          break
        case 2:
          return 4
          break
        case 3:
          return 2
          break
        case 4:
          return 2
          break
        case 5:
          return 0
          break
        case 6:
          return 0
          break
        case 7:
          return 0
          break
        case 8:
          return 0
          break
        case 9:
          return 7
          break
        case 10:
          return 0
          break
      }
      break
    case "pak64.german":
      switch (id) {
        case 1:
          return 2
          break
        case 2:
          return 3
          break
        case 3:
          return 2
          break
        case 4:
          return 0
          break
        case 5:
          return 0
          break
        case 6:
          return 0
          break
        case 7:
          return 0
          break
        case 8:
          return 0
          break
        case 9:
          return 0
          break
        case 10:
          return 0
          break
      }
      break
    case "pak128":
      switch (id) {
        case 1:
          return 2
          break
        case 2:
          return 4
          break
        case 3:
          return 2
          break
        case 4:
          return 0
          break
        case 5:
          return 0
          break
        case 6:
          return 0
          break
        case 7:
          return 0
          break
        case 8:
          return 0
          break
        case 9:
          return 0
          break
        case 10:
          return 0
          break
      }
      break
  }

}

/**
  *  set icon code to text by different icons in paksets
  *
  *  The folder info_files/img-tools contains a scenario for displaying the icons with their IDs.
  *
  * @param string id = icon code
  *  The icon code are documented in the file info_files/img-tools.ods.
  *
  *
  * @return string image code for icons in text
  */
function get_gui_img(id) {

  switch (pak_name) {
    case "pak64":
      switch (id) {
        case "road_menu":
          return "<img src='#t4'></img>"
          break
        case "rail_menu":
          return "<img src='#t1'></img>"
          break
        case "grid":
          return "<img src='#s12'></img>"
          break
        case "display":
          return "<img src='#d1'></img> <img src='#d7'></img>"
          break
        case "post_menu":
          return "<img src='#t7'></img>"
          break
        case "road_halts":
          return "<img src='#t4'></img>"
          break
        case 7:
          return 0
          break
        case 8:
          return 0
          break
        case 9:
          return 0
          break
        case 10:
          return 0
          break
      }
      break
    case "pak64.german":
      switch (id) {
        case "road_menu":
          return "<img src='#t58'></img> <img src='#t4'></img>"
          break
        case "rail_menu":
          return "<img src='#t58'></img> <img src='#t1'></img>"
          break
        case "grid":
          return "<img src='#s12'></img>"
          break
        case "display":
          return "<img src='#d1'></img>"
          break
        case "post_menu":
          return "<img src='#t67'></img>"
          break
        case "road_halts":
          return "<img src='#t29'></img> <img src='#t62'></img>"
          break
        case 7:
          return 0
          break
        case 8:
          return 0
          break
        case 9:
          return 0
          break
        case 10:
          return 0
          break
      }
      break
    case "pak128":
      switch (id) {
        case "road_menu":
          return "<img src='#t4'></img>"
          break
        case "rail_menu":
          return "<img src='#t1'></img>"
          break
        case "grid":
          return "<img src='#s12'></img>"
          break
        case "display":
          return "<img src='#d1'></img> <img src='#d7'></img>"
          break
        case "post_menu":
          return "<img src='#t7'></img>"
          break
        case "road_halts":
          return "<img src='#t4'></img>"
          break
        case 7:
          return 0
          break
        case 8:
          return 0
          break
        case 9:
          return 0
          break
        case 10:
          return 0
          break
      }
      break
  }

}
