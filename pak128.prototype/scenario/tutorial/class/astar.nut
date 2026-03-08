/** @file astar.nut
  * @brief Classes to help with route-searching.
  */

/**
 * @brief astar.nut
 * Classes to help with route-searching.
 * Based on the A* algorithm.
 */

/**
 * Nodes for A*
 */
class astar_node extends coord3d
{
  previous = null // previous node
  cost     = -1   // cost to reach this node
  dist     = -1   // distance to target
  constructor(c, p, co, d)
  {
    x = c.x
    y = c.y
    z = c.z
    previous = p
    cost     = co
    dist     = d
  }
  function is_straight_move(d)
  {
    return d == dir ||  (previous  &&  previous.dir == d)
  }
}

/**
 * Class to perform A* searches.
 *
 * Derived classes have to implement:
 *    process_node(node): add nodes to open list reachable by node
 *
 * To use this:
 * 1) call prepare_search
 * 2) add tiles to target array
 * 3) call compute_bounding_box
 * 4) add start tiles to open list
 * 5) call search()
 * 6) use route
 */
class astar
{
  closed_list = null // table
  nodes       = null // array of astar_node
  heap        = null // binary heap
  targets     = null // array of coord3d's

  boundingbox = null // box containing all the targets

  route       = null // route, reversed: target to start

  // statistics
  calls_open = 0
  calls_closed = 0
  calls_pop = 0

  // costs - can be fine-tuned
  cost_straight = 10
  cost_curve    = 14

  constructor()
  {
    closed_list = {}
    heap        = simple_heap_x()
    targets     = []

  }

  function prepare_search()
  {
    closed_list = {}
    nodes       = []
    route       = []
    heap.clear()
    targets     = []
    calls_open = 0
    calls_closed = 0
    calls_pop = 0
  }

  // adds node c to closed list
  function add_to_close(c)
  {
    closed_list[ coord3d_to_key(c) ] <- 1
    calls_closed++
  }

  function test_and_close(c)
  {
    local key = coord3d_to_key(c)
    if (key in closed_list) {
      return false
    }
    else {
      closed_list[ key ] <- 1
      calls_closed++
      return true
    }
  }

  function is_closed(c)
  {
    local key = coord3d_to_key(c)
    return (key in closed_list)
  }

  // add node c to open list with give weight
  function add_to_open(c, weight)
  {
    local i = nodes.len()
    nodes.append(c)
    heap.insert(weight, i)
    calls_open++
  }

  function search()
  {
    // compute bounding box of targets
    compute_bounding_box()

    local current_node = null
    while (!heap.is_empty()) {
      calls_pop++

      local wi = heap.pop()
      current_node = nodes[wi.value]
      local dist = current_node.dist

      // target reached
      if (dist == 0) break;
      // already visited previously
      if (!test_and_close(current_node)) {
        current_node = null
        continue;
      }
      // investigate neighbours and put them into open list
      process_node(current_node)

      if ( current_node != null ) {
        check_way_last_tile = current_node
      }

      current_node = null
    }

    route = []
    if (current_node) {
      // found route
      route.append(current_node)

      while (current_node.previous) {
        current_node = current_node.previous
        route.append(current_node)
      }
    }

    print("Calls: pop = " + calls_pop + ", open = " + calls_open + ", close = " + calls_closed)
  }

  /**
   * Computes bounding box of all targets to speed up distance computation.
   */
  function compute_bounding_box()
  {
    if (targets.len()>0) {
      local first = targets[0]
      boundingbox = { xmin = first.x, xmax = first.x, ymin = first.y, ymax = first.y }

      for(local i=1; i < targets.len(); i++) {
        local t = targets[i]
        if (boundingbox.xmin > t.x) boundingbox.xmin = t.x;
        if (boundingbox.xmax < t.x) boundingbox.xmax = t.x;
        if (boundingbox.ymin > t.y) boundingbox.ymin = t.y;
        if (boundingbox.ymax < t.y) boundingbox.ymax = t.y;
      }
    }
  }

  /**
   * Estimates distance to target.
   * Returns zero if and only if c is a target tile.
   */
  function estimate_distance(c)
  {
    local d = 0
    local curved = 0

    // distance to bounding box
    local dx = boundingbox.xmin - c.x
    if (dx <= 0) dx = c.x - boundingbox.xmax;
    if (dx > 0) d += dx; else dx = 0;

    local dy = boundingbox.ymin - c.y
    if (dy <= 0) dy = c.y - boundingbox.ymax
    if (dy > 0) d += dy; else dy = 0;

    if (d > 0) {
      // cost to bounding box
      return cost_straight * d + (dx*dy > 0 ? cost_curve - cost_straight : 0);
    }
    else {
      local t = targets[0]
      d = abs(t.x-c.x) + abs(t.y-c.y)

      // inside bounding box
      for(local i=1; i < targets.len(); i++) {
        local t = targets[i]
        local dx = abs(t.x-c.x)
        local dy = abs(t.y-c.y)
        d = min(d, cost_straight * (dx+dy) + (dx*dy > 0 ? cost_curve - cost_straight : 0))
      }
    }
    return d
  }
}

/**
 * Class to search a route along existing ways.
 */
class astar_route_finder extends astar
{
  wt = wt_all

  constructor(wt_)
  {
    base.constructor()
    wt = wt_
    if ( [wt_all, wt_invalid, wt_water, wt_air].find(wt) ) {
      throw("Using this waytype is going to be inefficient. Use at own risk.")
    }
    cost_curve = cost_straight
  }

  function process_node(cnode)
  {
    local from = tile_x(cnode.x, cnode.y, cnode.z)
    local back = dir.backward(cnode.dir)
    // allowed directions
    local dirs = from.get_way_dirs_masked(wt)

    for(local d = 1; d<16; d*=2) {
      // do not go backwards, only along existing ways
      if ( d == back  ||  ( (dirs & d) == 0) ) {
        continue
      }

      local to = from.get_neighbour(wt, d)
      if (to) {
        if (!is_closed(to)) {
          // estimate moving cost
          local move = cnode.is_straight_move(d)  ?  cost_straight  :  cost_curve
          local dist   = estimate_distance(to)
          local cost   = cnode.cost + move
          local weight = cost //+ dist
          local node = ab_node(to, cnode, cost, dist, d)

          add_to_open(node, weight)
        }
      }
    }
  }

  // start and end have to be arrays of objects with 3d-coordinates
  function search_route(start, end)
  {
    prepare_search()
    foreach (e in end) {
      targets.append(e);
    }
    compute_bounding_box()

    foreach (s in start)
    {
      local dist = estimate_distance(s)
      add_to_open(ab_node(s, null, 1, dist+1, 0, 0), dist+1)
    }

    search()

    if (route.len() > 0) {
      return { start = route[route.len()-1], end = route[0], routes = route }
    }
    print("No route found")
    return { err =  "No route" }
  }
}

/**
 * Class to search a route along existing ways.
 */
class astar_route_finder extends astar
{
  wt = wt_all

  constructor(wt_)
  {
    base.constructor()
    wt = wt_
    if ( [wt_all, wt_invalid, wt_water, wt_air].find(wt) ) {
      throw("Using this waytype is going to be inefficient. Use at own risk.")
    }
    cost_curve = cost_straight
  }

  function process_node(cnode)
  {
    local from = tile_x(cnode.x, cnode.y, cnode.z)
    local back = dir.backward(cnode.dir)
    // allowed directions
    local dirs = from.get_way_dirs_masked(wt)

    for(local d = 1; d<16; d*=2) {
      // do not go backwards, only along existing ways
      if ( d == back  ||  ( (dirs & d) == 0) ) {
        continue
      }

      local to = from.get_neighbour(wt, d)
      if (to) {
        if (!is_closed(to)) {
          // estimate moving cost
          local move = cnode.is_straight_move(d)  ?  cost_straight  :  cost_curve
          local dist   = estimate_distance(to)
          local cost   = cnode.cost + move
          local weight = cost //+ dist
          local node = ab_node(to, cnode, cost, dist, d)

          add_to_open(node, weight)
        }
      }
    }
  }

  // start and end have to be arrays of objects with 3d-coordinates
  function search_route(start, end)
  {
    prepare_search()
    foreach (e in end) {
      targets.append(e);
    }
    compute_bounding_box()

    foreach (s in start)
    {
      local dist = estimate_distance(s)
      add_to_open(ab_node(s, null, 1, dist+1, 0, 0), dist+1)
    }

    search()

    if (route.len() > 0) {
      return { start = route.top(), end = route[0], routes = route }
    }
    print("No route found")
    return { err =  "No route" }
  }
}

class ab_node extends ::astar_node
{
  dir = 0   // direction to reach this node
  flag = 0  // flag internal to the route searcher
  constructor(c, p, co, d, di, fl=0)
  {
    base.constructor(c, p, co, d)
    dir  = di
    flag = fl
  }
}

/**
 * Helper class to find bridges and spots to place them.
 */
class pontifex
{
  player = null
  bridge = null

  constructor(pl, way)
  {
    // print messages box
    // 1 = erreg
    // 2 = list bridges
    local print_message_box = 0
    local wt_name = ["", "road", "rail", "water"]

    if ( print_message_box > 1 ) {
      gui.add_message_at("____________ Search bridge ___________", world.get_time())
    }
    player = pl
    local list = bridge_desc_x.get_available_bridges(way.get_waytype())
    local len = list.len()
    local way_speed = way.get_topspeed()
    local bridge_min_len = 5

    if (len>0) {
      bridge = list[0]
        if ( print_message_box == 2 ) {
          gui.add_message_at(" ***** way : " + wt_name[way.get_waytype()], world.get_time())
          gui.add_message_at(" ***** bridge : " + bridge.get_name(), world.get_time())
          gui.add_message_at(" ***** get_max_length : " + bridge.get_max_length(), world.get_time())
        }

      for(local i=1; i<len; i++) {
        local b = list[i]
        if ( print_message_box == 2 ) {
          gui.add_message_at(" ***** way : " + wt_name[way.get_waytype()], world.get_time())
          gui.add_message_at(" ***** bridge : " + b.get_name(), world.get_time())
          gui.add_message_at(" ***** get_max_length : " + b.get_max_length(), world.get_time())
        }
        if ( b.get_max_length() > bridge_min_len || b.get_max_length() == 0 ) {
          if (bridge.get_topspeed() < way_speed) {
            if (b.get_topspeed() > bridge.get_topspeed()) {
              bridge = b
            }
          }
          else {
            if (way_speed < b.get_topspeed() && b.get_topspeed() < bridge.get_topspeed()) {
              bridge = b
            }
          }
        }
      }
    }
    if ( print_message_box > 1 ) {
      gui.add_message_at(" *** bridge found : " + bridge.get_name() + " way : " + wt_name[way.get_waytype()], world.get_time())
      gui.add_message_at("--------- Search bridge end ----------", world.get_time())
    }
  }

  function find_end(pos, dir, min_length)
  {
    return bridge_planner_x.find_end(player, pos, dir, bridge, min_length)
  }
}

/**
 * Class to search a route and to build a connection (i.e. roads).
 * Builds bridges. But not tunnels (not implemented).
 */
class astar_builder extends astar
{
  builder = null
  bridger = null
  way     = null

  function process_node(cnode)
  {
    local from = tile_x(cnode.x, cnode.y, cnode.z)
    local back = dir.backward(cnode.dir)

    for(local d = 1; d<16; d*=2) {
      // do not go backwards
      if (d == back) {
        continue
      }
      // continue straight after a bridge
      if (cnode.flag == 1  &&  d != cnode.dir) {
        continue
      }

      local to = from.get_neighbour(wt_all, d)
      if (to) {
        if (builder.is_allowed_step(from, to)  &&  !is_closed(to)) {
          // estimate moving cost
          local move = cnode.is_straight_move(d)  ?  cost_straight  :  cost_curve
          local dist   = estimate_distance(to)
          // is there already a road?
          if (!to.has_way(wt_road)) {
            move += 8
          }

          local cost   = cnode.cost + move
          local weight = cost + dist
          local node = ab_node(to, cnode, cost, dist, d)

          add_to_open(node, weight)
        }
        // try bridges
        else if (bridger  &&  d == cnode.dir  &&  cnode.flag != 1) {
          local len = 1
          local max_len = bridger.bridge.get_max_length()

          do {
            local to = bridger.find_end(from, d, len)
            if (to.x < 0  ||  is_closed(to)) {
              break
            }
            local bridge_len = abs(from.x-to.x) + abs(from.y-to.y)

            // long bridges bad
            local bridge_factor = 3

            if ( bridge_len > 20 ) {
              bridge_factor = 4
            }/* else if ( bridge_len > 8 ) {
              bridge_factor = 4
            }*/
            local move = bridge_len * cost_straight  * bridge_factor  /*extra bridge penalty */;
            // set distance to 1 if at a target tile
            local dist = max(estimate_distance(to), 1)

            local cost   = cnode.cost + move
            local weight = cost + dist
            local node = ab_node(to, cnode, cost, dist, d, 1 /*bridge*/)

            add_to_open(node, weight)

            len = bridge_len + 1
          } while (len <= max_len)
        }
      }
    }
  }

  function search_route(start, end, build_route = 1)
  {

    if ( start.len() == 0 || end.len() == 0 ) {
      if ( print_message_box > 0 ) {
        gui.add_message_at(" *** invalid tile : start or end ", world.get_time())
      }
      return { err =  "No route" }
    }

    prepare_search()
    foreach (e in end) {
      targets.append(e);
    }
    compute_bounding_box()

    foreach (s in start)
    {
      local dist = estimate_distance(s)
      add_to_open(ab_node(s, null, 1, dist+1, 0, 0), dist+1)
    }

    search()

    local bridge_tiles = 0
    local count_tree = 0

    if (route.len() > 0) {
      remove_field( route[0] )

      // do not try to build in tunnels
      local is_tunnel_0 = tile_x(route[0].x, route[0].y, route[0].z).find_object(mo_tunnel)
      local is_tunnel_1 = is_tunnel_0

      local last_treeway_tile = null

      for (local i = 1; i<route.len(); i++) {
        // remove any fields on our routes (only start & end currently)
        remove_field( route[i] )

        // check for tunnel
        is_tunnel_0 = is_tunnel_1
        is_tunnel_1 = tile_x(route[i].x, route[i].y, route[i].z).find_object(mo_tunnel)

        if (is_tunnel_0 && is_tunnel_1) {
          continue
        }

        local err
        // build
        if (route[i-1].flag == 0) {
          /*if ( way.get_waytype() == wt_road ) {
            if ( build_route == 1 ) {
              err = command_x.build_road(our_player, route[i-1], route[i], way, true, true)
              if (err) {
                //gui.add_message_at("Failed to build " + way.get_name() + " from " + coord_to_string(route[i-1]) + " to " + coord_to_string(route[i]) +"\n" + err, route[i])
                remove_wayline(route, (i - 1), way.get_waytype())
              }

            }

          } else {*/
            if ( build_route == 1 ) {
              // test way is available
              if ( !way.is_available(world.get_time()) ) {
                way = find_object("way", way.get_waytype(), way.get_topspeed())
              }

              local t = tile_x(route[i].x, route[i].y, route[i].z)
              local d = t.get_way_dirs(way.get_waytype())
              local test_exists_way = t.find_object(mo_way)

              local check_build_tile = true
              if ( i > 1 && i < (route.len()-1) ) {
                local tx_0 = tile_x(route[i-1].x, route[i-1].y, route[i-1].z)
                local tx_1 = tile_x(route[i+1].x, route[i+1].y, route[i+1].z)
                if ( tx_0.find_object(mo_way) != null && tx_1.find_object(mo_way) != null ) {
                  //gui.add_message_at(" check tx_0 and tx_1 ", t)
                  if ( test_exists_way == null ) {
                    local ty = route[i]
                    local cnv_count = tx_0.find_object(mo_way).get_convoys_passed()[0] + tx_0.find_object(mo_way).get_convoys_passed()[1]

                    if ( last_treeway_tile != null && cnv_count == 0 ) {
                      ty = route[last_treeway_tile]
                    }
                    err = test_select_way(tx_1, tx_0, ty, way.get_waytype())
                    //gui.add_message_at(" check tx_0 and tx_1 : test_select_way " + err, t)
                    if ( err ) {
                      check_build_tile = false
                    }
                    err = null
                  }
                } else if ( test_exists_way != null && test_exists_way.get_waytype() == way.get_waytype() ) {
                  check_build_tile = false
                }
                if ( tx_0.find_object(mo_signal) != null ) {
                  check_build_tile = false

                }
              }

              if ( test_exists_way != null && test_exists_way.get_owner() != our_player.nr ) { //&& last_treeway_tile != null
                //gui.add_message_at("test_exists_way " + test_exists_way + " last_treeway_tile " + last_treeway_tile + " test_exists_way.get_waytype() " + test_exists_way.get_waytype() + " !t.is_bridge() " + !t.is_bridge() + " t.get_slope() " + t.get_slope(), t)

                  test_exists_way = null


              }

              if ( t.is_bridge() ) {
                //gui.add_message_at(" t.is_bridge() " + t.is_bridge(), t)
                last_treeway_tile = null
              }

              if ( i > 2 && test_exists_way != null && last_treeway_tile != null && test_exists_way.get_waytype() == wt_rail && t.get_slope() == 0 ) {
                //gui.add_message_at(our_player, " (624) ", t)
                err = test_select_way(route[i], route[last_treeway_tile], route[i-1], way.get_waytype())
                if ( err ) {
                  last_treeway_tile = null
                } else {
                  test_exists_way = null
                  last_treeway_tile = null
                }
                err = null
              }
              /*if ( way.get_waytype() == wt_rail && !t.is_bridge() && t.get_slope == 0 ) {
                t = tile_x(route[i-1].x, route[i-1].y, route[i-1].z)
                d = t.get_way_dirs(way.get_waytype())
                if ( dir.is_threeway(d) ) {
                  last_treeway_tile = i - 1
                } else {
                  last_treeway_tile = null
                  test_exists_way = null
                }

              }*/
              if ( test_exists_way != null && ( i < 2 || test_exists_way.get_waytype() == wt_road ) ) {
                test_exists_way = null
              }

              local build_tile = false
              if ( settings.get_pay_for_total_distance_mode == 2 && test_exists_way == null && check_build_tile ) {
                err = command_x.build_way(our_player, route[i-1], route[i], way, true)
                build_tile = true
              } else if ( test_exists_way == null && check_build_tile ) {
                err = command_x.build_way(our_player, route[i-1], route[i], way, false)
                build_tile = true
              }
              if (err) {
                //gui.add_message_at("Failed to build " + way.get_name() + " from " + coord_to_string(route[i-1]) + " to " + coord_to_string(route[i]) +"\n" + err, route[i])
                // remove way
                // route[0] to route[i]
                //err = command_x.remove_way(our_player, route[0], route[i])
                remove_wayline(route, (i - 1), way.get_waytype())
              } else {
                t = tile_x(route[i-1].x, route[i-1].y, route[i-1].z)
                d = t.get_way_dirs(way.get_waytype())
                //gui.add_message_at(" (666) dir.is_threeway(d) " + dir.is_threeway(d), t)
                if ( dir.is_threeway(d) && way.get_waytype() == wt_rail && build_tile ) {
                  last_treeway_tile = i - 1
                }
              }
            } else if ( build_route == 0 ) {
              if ( tile_x(route[i].x, route[i].y, route[i].z).find_object(mo_tree) != null ) {
                count_tree++
              }
            }
          //}
        }
        else if (route[i-1].flag == 1) {
          // plan build bridge

          local b_tiles = 0

          //
            if ( route[i-1].x == route[i].x ) {
              if ( route[i-1].y > route[i].y ) {
                b_tiles = (route[i-1].y - route[i].y + 1)
                bridge_tiles += b_tiles
              } else {
                b_tiles = (route[i].y - route[i-1].y + 1)
                bridge_tiles += b_tiles
              }
            } else if ( route[i-1].y == route[i].y ) {
              if ( route[i-1].x > route[i].x ) {
                b_tiles = (route[i-1].x - route[i].x + 1)
                bridge_tiles += b_tiles
              } else {
                b_tiles = (route[i].x - route[i-1].x + 1)
                bridge_tiles += b_tiles
              }
            }


          if ( build_route == 1 ) {
            // check ground under bridge
            // check_ground() return true build bridge
            // check_ground() return false no build bridge

            local build_bridge = true
            // check whether the ground can be adjusted and no bridge is necessary
            // bridge len <= 4 tiles
            if ( b_tiles < 8 ) {
              build_bridge = check_ground(tile_x(route[i-1].x, route[i-1].y, route[i-1].z), tile_x(route[i].x, route[i].y, route[i].z), way)
              //gui.add_message_at("check_ground(pos_s, pos_e) --- " + build_bridge, route[i-1])
            }

            if ( build_bridge ) {
              err = command_x.build_bridge(our_player, route[i-1], route[i], bridger.bridge)
              if (err) {
                // check whether bridge exists
                sleep()
                local arf = astar_route_finder(wt_road)
                local res_bridge = arf.search_route([route[i-1]], [route[i]])

                if ("routes" in res_bridge  &&  res_bridge.routes.len() == abs(route[i-1].x-route[i].x)+abs(route[i-1].y-route[i].y)+1) {
                  // there is a bridge, continue
                  err = null
                  gui.add_message_at("Failed to build bridge from " + coord_to_string(route[i-1]) + " to " + coord_to_string(route[i]) +"\n" + err, route[i])
                } else {
                  remove_wayline(route, (i - 1), way.get_waytype())
                  // remove bridge tiles build by not build bridge

                }
              }
            }

          } else if ( build_route == 0 ) {
          }

        }
        if (err) {
          return { err =  err }
        }
      }
      return { start = route.top(), end = route[0], routes = route, bridge_lens = bridge_tiles, bridge_obj = bridger.bridge, tiles_tree = count_tree }
    }
    print("No route found")
    return { err =  "No route" }
  }
}

/*
 *
 *
 */
function test_select_way(start, end, wt = wt_rail) {
  //gui.add_message_at("start " + coord3d_to_string(start) + " end " + coord3d_to_string(end) + " t_end " + coord3d_to_string(t_end), start)
  local asf = astar_route_finder(wt)
  local wayline = asf.search_route([start], [end])
  if ( "err" in wayline ) {
    //gui.add_message_at("no route from " + coord3d_to_string(start) + " to " + coord3d_to_string(end) , start)
    if ( check_way_last_tile != null ) {
      local tile = tile_x(check_way_last_tile.x, check_way_last_tile.y, check_way_last_tile.z)
      //gui.add_message("test_select_way last tile " + coord3d_to_string(tile))
      r_way.c = tile

      //if ( check_way_mark_tile == null ) { check_way_mark_tile = check_way_last_tile }
      /*local sasf = astar_route_finder(wt)
      local waybuild = sasf.search_route([start], [tile])
      if ( "err" in waybuild ) {
        //gui.add_message("error build ")
      } else {
        foreach(node in waybuild.routes) {
          local t = tile_x(node.x, node.y, node.z)
           // gui.add_message("test tile " + coord3d_to_string(t))


        }
      }*/

    } else {
      //gui.add_message("test_select_way last tile - null")
    }

    return false
  } else {
    //gui.add_message_at("exists route from " + coord3d_to_string(start) + " to " + coord3d_to_string(end) , start)

    return true
  }
}

function unmark_waybuild() {
  if ( check_way_mark_tile != null ) {

    local w_dir = my_tile(check_way_mark_tile).get_way_dirs(wt_rail)
    if ( dir.is_twoway(w_dir) ) {

      gui.add_message("### check_way_mark_tile " + coord3d_to_string(check_way_mark_tile))
      local r = my_tile(check_way_mark_tile).find_object(mo_way)
      if ( r ) { r.unmark() }
      //r = my_tile(check_way_mark_tile).find_object(mo_label)
      //if ( r ) { r.remove_object(player_x(0), mo_label) }
      check_way_mark_tile = check_way_last_tile
    }
  } else {
    check_way_mark_tile = check_way_last_tile
  }
}