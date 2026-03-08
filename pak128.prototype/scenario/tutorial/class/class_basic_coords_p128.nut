/**
  * @file class_basic_coords_p128.nut
  * @brief sets the pakset specific map coords for pak128
  */

/**
 *  set limit for build
 *
 *
 */
city1_limit1          <- {a = coord(109,181), b = coord(128,193)}
city2_limit1          <- {a = coord(120,150), b = coord(138,159)}

bridge1_limit         <- {a = coord(119,193), b = coord(128,201)}
c_bridge1_limit1      <- {a = coord(126,191), b = coord(126,195)}
change1_city1_limit1  <- {a = coord(120,193), b = coord(127,193)}

c_dock1_limit         <- {a = coord(128,181), b = coord(135,193)}
change2_city1_limit1  <- {a = coord(128,182), b = coord(128,192)}

c_way_limit1          <- {a = coord(127,159), b = coord(133,187)}

c_way3_lim            <- {a = coord(94,198), b = coord(114,198)}
c_bridge3_limit       <- {a = coord(90,198), b = coord(94,198)}
c_way3_tun_limit      <- {b = coord(92,194), a = coord(63,202)}

way5_fac7_fac8_lim    <- {a = coord(127,211), b = coord(136,233)}
way5_power_lim        <- [{a = coord(127,196), b = coord(151,204)}, {a = coord(106,189), b = coord(112,201)},
                          {a = coord(106,201), b = coord(127,210)}, {a = coord(127,204), b = coord(140,238)}
                          ]
way5_power_lim_del    <- [{a = coord(107,201), b = coord(111,201)}, {a = coord(127,202), b = coord(127,209)}, {a = coord(128,204), b = coord(139,204)}]

/**
 *  set tiles for buildings
 *
 *  mon
 *  cur
 *  tow
 */
city1_mon <- coord(113,189)
city1_cur <- coord(113,185)

city1_tow <- coord(111,184)
city2_tow <- coord(129,154)
city3_tow <- coord(52,194)
city4_tow <- coord(115,268)
city5_tow <- coord(124,326)
city6_tow <- coord(125,378)
city7_tow <- coord(163,498)

/**
 *  set tiles for factory
 *
 *  coord_fac_1 - ch1, ch4
 *
 *
 */
coord_fac_1 <- coord(123,160) // Timber plantation
coord_fac_2 <- coord(93,153)  // Saw mill
coord_fac_3 <- coord(110,190) // Construction Wholesaler
coord_fac_4 <- coord(168,189) // Oil rig
coord_fac_5 <- coord(149,200) // Oil refinery
coord_fac_6 <- coord(112,192) // Gas station
coord_fac_7 <- coord(131,235) // Coal mine
coord_fac_8 <- coord(130,207) // Coal power station

/**
 *  set tiles for stations
 *
 *  coord_st_1 - city 1
 *
 *
 */
coord_st_1 <- coord(117,197)

/**
 *  set halt coords city
 *
 *  used in chapter: 2
 *    city1_halt_1 - halts city 1
 *    city1_halt_2 - halts connect city 1 dock and station
 *    city2_halt_1 - halts connect city 2 to city 1
 *    line_connect_halt - halt in all halt lists
 *
 *  used chapter 3
 *    ch3_rail_stations - city line
 *
 *  used chapter 4
 *    ch4_ship1_halts - dock raffinerie - (coord_fac4)
 *    ch4_ship2_halts - dock raffinerie - canal stop gas station
 *    ch4_ship3_halts - passenger ship
 *
 *  used chapter 5
 *    city1_post_halts     - halts for post
 *    ch5_post_ship_halts  - post passenger dock - factory 4 (Oil rigg)
 *
 *  used chapter 6
 *    city1_city7_air
 *    city1_halt_airport
 *    city1_halt_airport_extension
 *    city7_halt
 *
 *  used chapter 7
 *    ch7_rail_stations
 *
 *
 */
city1_halt_1 <- []
city1_halt_2 <- []
city2_halt_1 <- []

line_connect_halt <- coord(126,187)

city1_halt_airport <- [coord(114,177), coord(121,189), line_connect_halt]
local list = [coord(111,183), coord(116,183),  coord(120,183), coord(126,187), coord(121,189), coord(118,191), coord(113,190)]
for ( local i = 0; i < list.len(); i++ ) {
  city1_halt_1.append(list[i])
}
list.clear()
// first coord add city1_post_halts
list = [coord(132,189), coord(126,187), coord(121,189), coord(126,198), coord(120,196)]
for ( local i = 0; i < list.len(); i++ ) {
  city1_halt_2.append(list[i])
}
list.clear()
list = [coord(126,187), coord(121,155), coord(127,155), coord(132,155), coord(135,153)]
for ( local i = 0; i < list.len(); i++ ) {
  city2_halt_1.append(list[i])
}

city1_post_halts <- []
for ( local i = 0; i < city1_halt_1.len(); i++ ) {
  city1_post_halts.append(city1_halt_1[i])
  if ( i == 3 ) {
    city1_post_halts.append(city1_halt_2[0])
  }
}

city1_city7_air <- [coord(114,176), coord(168,489)]
city1_halt_airport_extension <- [coord(115,177)]

city7_halt <- [ coord(168,490), coord(160,493), coord(155,493), coord(150,494), coord(154,500), coord(159,499),
          coord(164,498), coord(166,503), coord(171,501), coord(176,501), coord(173,493)]

ch3_rail_stations <- [ tile_x(55,197,11), tile_x(116,198,0), tile_x(120,266,3), tile_x(120,326,5),
                       tile_x(120,380,9), tile_x(121,326,5), tile_x(121,266,3), tile_x(116,197,0)
                     ]

ch4_ship1_halts <- [coord3d(151, 198, -3)]
ch4_ship2_halts <- [ch4_ship1_halts[0], coord3d(114, 194, 1)]
ch4_ship3_halts <- [coord3d(133, 189, -3), coord3d(188, 141, -3), coord3d(179, 135, -3)]

// add Oil rigg ( factory 4 to schedule passenger ship )
ch4_schedule_line3 <- []
for ( local i = 0; i < ch4_ship3_halts.len(); i++ ) {
  ch4_schedule_line3.append(ch4_ship3_halts[i])
  if ( i == 0 || i == 2 ) {
    ch4_schedule_line3.append(coord_fac_4)
  }
}

ch5_post_ship_halts <- [ch4_ship3_halts[0], coord_fac_4]

ch7_rail_stations <- [tile_x(57,198,11), tile_x(120,267,3), tile_x(120,327,5), tile_x(120,381,9)]

/**
 *  define depots
 */
city1_road_depot <- coord(115,185)
city7_road_depot  <- coord(167,497)
ship_depot        <- coord(150, 190)

/**
 *  rail_depot{depot_tile, way_tile}
 *  air_depot{depot_tile, way_tile}
 *
 *  road depot must be located one field next to a road
 */
ch3_rail_depot1 <- {b = coord(121,164), a = coord(121,163)}
ch3_rail_depot2 <- {b = coord(94,160), a = coord(93,160)}
ch3_rail_depot3 <- {b = coord(108,196), a = coord(108,197)}
ch5_road_depot  <- {a = coord(131,232), b = coord(132,232)}
ch6_air_depot  <- {a = coord(113,177), b = coord(113,176)}

/**
 *  define bridges
 *
 *  bridge1_coords  = road bridge city 1
 *  bridge2_coors   = rail bridge fac_1 -> fac_2
 *  bridge3_coors   = rail bridge city 1 -> city 3
 *
 */
bridge1_coords <- {a = coord3d(126,192,-1), b = coord3d(126,194,-1), dir = 3}
bridge2_coords <- {a = coord3d(106,158,-1), b = coord3d(100,158,-1)}
bridge3_coords <- {a = coord3d(93,198,5), b = coord3d(91,198,5)}

/**
 *  define ways
 *
 *  way1_coords = road city 1 -> city 2
 *
 *  way2_fac1_fac2  = rail factory 1 -> factory 2
 *
 *  way3_cy1_cy3   = city 1 -> city 3
 *  way3_cy1_cy6    = city 1 -> city 4 -> city 5 -> city 6
 *
 *  way3_tun_list, way3_tun_coord = build tunnel city 1 -> city 3
 *
 *  way4_cannal     = cannel to gas station
 *
 *  way5_fac7_fac8  = road coal to power plant
 *  way5_power1     = powerline fac8 to fac
 *
 *
 */
way1_coords <- {a = coord3d(130,160,0), b = coord3d(130,185,0), dir = 3}

// start - 5 tiles after start - bridge tile - bridge tile - 5 tiles before the end - end
way2_fac1_fac2 <- [coord3d(125,163,0), coord3d(120,163,0), coord3d(107,158,1), coord3d(99,158,1), coord3d(96,155,1), coord3d(96,151,1)]
limit_ch3_rail_line_1a  <- {a = coord(105, 153), b = coord(122, 166)}
limit_ch3_rail_line_1b  <- {a = coord(95, 154), b = coord(103, 160)}

// start - 5 tiles after start - tunnel tile - tunnel tile - 5 tiles before the end - end
way2_fac2_fac3 <- [coord3d(94,155,2), coord3d(94,160,2), coord3d(95,172,3), coord3d(104,172,3), coord3d(109,184,2), coord3d(109,189,2)]
limit_ch3_rail_line_2a  <- {a = coord(91,159), b = coord(97,174)}
limit_ch3_rail_line_2b  <- {a = coord(102, 171), b = coord(110, 187)}

// connect city 1 -> city 3
way3_cy1_cy3 <- {a = coord3d(114,198,0), b = coord3d(94,198,6), dir = 123}
/* connect [0] - [1] -> city 1 - city 4
 * connect [2] - [3] -> city 4 - city 5
 * connect [4] - [5] -> city 5 - city 6
 */
way3_cy1_cy6   <- [ {a = coord3d(120,199,0), b = coord3d(120,264,3) }, {a = coord3d(121,264,3), b = coord3d(121,199,0) },
                    {a = coord3d(120,271,3), b = coord3d(120,324,5) }, {a = coord3d(121,324,5), b = coord3d(121,271,3) },
                    {a = coord3d(120,331,5), b = coord3d(120,377,9) }, {a = coord3d(121,377,9), b = coord3d(121,331,5) }
                  ]
// tunnel build
way3_tun_list <- [coord3d(88,198,7), coord3d(87,198,8)]
// portal - first tile - end tile - portal
way3_tun_coord <- [coord3d(90,198,7), coord3d(89,198,8), coord3d(63,198,8), coord3d(60,198,11)]//, dir = null

/**
 *  define signals and catenary for rail line city 3 -> city 6
 *
 */
way3_sign_list <- [ {c = coord3d(94,197,6), ribi = 8}, {c = coord3d(112,198,2), ribi = 2},
                    {c = coord3d(121,199,0), ribi = 1}, {c = coord3d(120,263,3), ribi = 4},
                    {c = coord3d(121,271,3), ribi = 1}, {c = coord3d(120,324,5), ribi = 4},
                    {c = coord3d(121,331,5), ribi = 1}, {c = coord3d(120,377,9), ribi = 4},
                  ]
way3_cate_list1 <- [ {a = coord3d(55,198,11), b = way3_tun_coord[0], dir = 0, tunn = true},
                     {a = way3_tun_coord[0], b = coord3d(120,198,0), dir = 0, tunn = false},
                     {a = coord3d(120,198,0), b = coord3d(120,383,9), dir = 5, tunn = false},
                     {a = coord3d(121,383,9), b = coord3d(121,197,0), dir = 2, tunn = false},
                     {a = coord3d(120,197,0), b = coord3d(90,197,7), dir = 6, tunn = false},
                     {a = coord3d(90,197,7), b = coord3d(55,197,11), dir = 6, tunn = true}
                   ]

// dock raffenery - cannal stop - cannel way build
way4_cannal <- [coord3d(140,194,-3), coord3d(114,194,1), coord3d(127,193,-1)]
c_cannel_lim  <- {a = coord(114, 193), b = coord(140, 194)}

way5_fac7_fac8 <- [coord3d(132,233,0), coord3d(132,211,0)]//{, dir = 2}

/**
 *  chapter 5
 *
 *  extensions_tiles - tiles for post building
 *
 */

//extensions_tiles <- [coord(111,182), coord(116,182), coord(121,183), coord(127,187),
//                      coord(132,190), coord(121,190), coord(118,192), coord(113,191)]

/**
 *  set tiles for pos chapter start
 *
 *
 */
coord_chapter_1 <- city1_mon              // city1_mon
coord_chapter_2 <- city1_road_depot       // city1_road_depot
coord_chapter_3 <- coord_fac_2            // Saw mill
coord_chapter_4 <- ship_depot             // ship_depot
coord_chapter_5 <- coord_fac_8            // Coal power station
coord_chapter_6 <- city1_halt_airport[0]  // airport road stop
coord_chapter_7 <- city3_tow              // city 3 townhall

/**
 *  coord to arrea
 *
 */
ch4_curiosity <- coord(185,135)
