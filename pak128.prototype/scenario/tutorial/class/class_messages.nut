/**
  * @file class_messages.nut
  * @brief list messages
  *
  */

/**
 *  chapter texts
 *
*/
ch1_name        <- "Getting Started"
ch1_text1       <- "This is a town centre"
ch1_text2       <- "This is a factory"
ch1_text3       <- "This is a station"
ch1_text4       <- "This is a link"
ch1_text5       <- "Town Centre"

ch2_name        <- "Ruling the Roads"
ch3_name        <- "Riding the Rails"
ch4_name        <- "Setting Sail"
ch5_name        <- "Industrial Efficiency"
ch6_name        <- "The forgotten Air transport"
ch7_name        <- "Bus networks"

/**
 *  single messages
 *
 *  id - message id
 *   1 = You can only delete the stops.
 *   2 = Action not allowed
 *   3 = Only road schedules allowed
 *   4 = It is not allowed to start vehicles.
 *
 *
 *
 *
 *
 *
 */
function get_message(id) {
  local txt_message = ""

  switch(id) {
    case 1:
      txt_message = translate("You can only delete the stops.")
      break
    case 2:
      txt_message = translate("Action not allowed")
      break
    case 3:
      txt_message = translate("Only road schedules allowed")
      break
    case 4:
      txt_message = translate("It is not allowed to start vehicles.")
      break
    case 5:

      break
    case 6:

      break
    case 7:

      break
  }

  return txt_message

}

/**
 *  messages with a tile
 *
 *  id    - message id
 *  tile  - coord from tile : x,y or x,y,z
 *
 *  id list
 *   1 = Action not allowed (x, y, z).
 *   2 = Connect the road here (x, y, z).
 *   3 = The route is complete, now you may dispatch the vehicle from the depot (x, y, z).
 *   4 = You must build the bridge here (x, y, z).
 *   5 = Indicates the limits for using construction tools (x, y, z).
 *   6 = Text label (x, y, z).
 *   7 = You must first build a stretch of road (x, y, z).
 *   8 = You must build the depot in (x, y, z).
 *   9 = You must use the inspection tool (x, y, z).
 *  10 = Depot coordinate is incorrect (x, y, z).
 *  11 = Connect the Track here (x, y, z).
 *  12 = You must build the train depot in (x, y, z).
 *  13 = You are outside the allowed limits! (x, y, z).
 *  14 = Place the shipyard here (x, y, z).
 *  15 = You must select the deposit located in (x, y, z).
 *  16 =
 *  17 =
 *  18 =
 *  19 =
 *  20 =
 *
 */
function get_tile_message(id, tile) {
  local txt_tile = ""
  /*if ( tz == null ) {
    local tile = coord(tx, ty)
    txt_tile = coord_to_string(tile)
  } else {
    local tile = coord3d(tx, ty, tz)
    txt_tile = coord3d_to_string(tile)
  }*/
  local count = 0
  try {
    count = tile.len()
    if ( count == 2 ) {
      txt_tile = coord_to_string(tile)
    } else if ( tile.len() == 3 ) {
      txt_tile = coord3d_to_string(tile)
    } else {
      txt_tile = tile
    }
  }
  catch(ev) {
    try {
      txt_tile = coord_to_string(tile)
    }
    catch(ev) {
      txt_tile = coord3d_to_string(tile)
    }
  }


  local txt_message = ""

  switch(id) {
    case 1:
      txt_message = format(translate("Action not allowed (%s)."), txt_tile)
      break
    case 2:
      txt_message = translate("Connect the road here")+" ("+txt_tile+")."
      break
    case 3:
      txt_message = format(translate("The route is complete, now you may dispatch the vehicle from the depot (%s)."), txt_tile)
      break
    case 4:
      txt_message = translate("You must build the bridge here")+" ("+txt_tile+")."
      break
    case 5:
      txt_message = format(translate("Indicates the limits for using construction tools (%s)."), txt_tile)
      break
    case 6:
      txt_message = translate("Text label")+" ("+txt_tile+")."
      break
    case 7:
      txt_message = translate("You must first build a stretch of road")+" ("+txt_tile+")."
      break
    case 8:
      txt_message = translate("You must build the depot in")+" ("+txt_tile+")."
      break
    case 9:
      txt_message = format(translate("You must use the inspection tool (%s)."), txt_tile)
      break
    case 10:
      txt_message = format(translate("Depot coordinate is incorrect (%s)."), txt_tile)
      break
    case 11:
      txt_message = format(translate("Connect the Track here (%s)."), txt_tile)
      break
    case 12:
      txt_message = format(translate("You must build the train depot in (%s)."), txt_tile)
      break
    case 13:
      txt_message = format(translate("You are outside the allowed limits! (%s)."), txt_tile)
      break
    case 14:
      txt_message = format(translate("Place the shipyard here (%s)."), txt_tile)
      break
    case 15:
      txt_message = format(translate("You must select the deposit located in (%s)."), txt_tile)
      break
    case 16:
      //txt_message = format(translate(" (%s)."), txt_tile)
      break
    case 17:
      //txt_message = format(translate(" (%s)."), txt_tile)
      break
  }

  return txt_message

}

/**
 *  messages with a string/digit include
 *
 *  id    - message id
 *  data  - digit or string
 *
 *  id list
 *   1 = You must build the %d stops first.
 *   2 = Only %d stops are necessary.
 *
 *
 *
 *
 *
 *
 */
function get_data_message(id, data) {
  local txt_message = ""

  switch(id) {
    case 1:
      txt_message = format(translate("You must build the %d stops first."), data)
      break
    case 2:
      txt_message = format(translate("Only %d stops are necessary."), data)
      break
    case 3:

      break
    case 4:

      break
    case 5:

      break
    case 6:

      break
    case 7:

      break
  }

  return txt_message

}

/**
 *  messages with a string/digit and tile
 *
 *  id    - message id
 *  data  - digit or string
 *  tile  - coord from tile : x,y or x,y,z
 *
 *  id list
 *   1 = Stops should be built in [%s] (x, y, z).
 *   2 = You must build a stop in [%s] first (x, y, z).
 *   3 = Select station No.%d") (x, y, z).
 *   4 = Dock No.%d must accept goods (x, y, z).
 *
 *
 *
 *
 */
function get_tiledata_message(id, data, tile) {
  local txt_tile = ""
  /*if ( tile.len() == 2 ) {
    txt_tile = coord_to_string(tile)
  } else if ( tile.len() == 3 ) {
    txt_tile = coord3d_to_string(tile)
  } else {
    txt_tile = tile
  }*/
  local count = 0
  try {
    count = tile.len()
    if ( count == 2 ) {
      txt_tile = coord_to_string(tile)
    } else if ( tile.len() == 3 ) {
      txt_tile = coord3d_to_string(tile)
    } else {
      txt_tile = tile
    }
  }
  catch(ev) {
    txt_tile = coord_to_string(tile)
  }


  local txt_message = ""

  switch(id) {
    case 1:
      txt_message = format(translate("Stops should be built in [%s]"), data)+" ("+txt_tile+")."
      break
    case 2:
      txt_message = format(translate("You must build a stop in [%s] first"), data)+" ("+txt_tile+")."
      break
    case 3:
      txt_message = format(translate("Select station No.%d"), data)+" ("+txt_tile+")."
      break
    case 4:
      txt_message = format(translate("Dock No.%d must accept goods (%s)."), data, txt_tile)
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

  return txt_message

}

function bus_result_message(nr, name, veh, cov) {
    switch (nr) {
      case 0:
        return format(translate("Select the Bus [%s]."), name)
        break

      case 1:
        return format(translate("The number of bus must be [%d]."), cov)
        break

      case 2:
        return format(translate("The number of convoys must be [%d], press the [Sell] button."), cov)

      case 3:
        return translate("The bus must be [Passengers].")
        break

      case 4:
        return format(translate("Must not use trailers [%d]."),veh-1)
        break

      default:
        return translate("The convoy is not correct.")
        break
    }
}

/**
 *  label messages
 *
 *
 */
function get_label_text(id) {
  local txt_message = ""

  switch(id) {
    case 1:
      txt_message = translate("Place Stop here!.")
      break
    case 2:
      txt_message = translate("Build a Bridge here!.")
      break
    case 3:

      break
    case 4:

      break
    case 5:

      break
    case 6:

      break
    case 7:

      break
  }

  return txt_message

}
