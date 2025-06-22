/*
 *  "New York City" scenario
 *
 *  tested with nightly r6288 and pak128 2.2.0 r1140
 *  Can NOT be used in network game !
 */

const version = 4                  // version of script
map.file = "new_york_city.sve"     // specify the savegame to load

scenario.short_description = "New York City (beta version)"    // short description to be shown in finance window
scenario.author = "ny911 (scripting by Dwachs & ny911)"        // author of map and script
scenario.version = "0." + (version + 1)                        // make a version number
scenario.translation <- "no translation yet"                   // list of translation authors

startcash <- [ 2, 8, 5 ]           // startcash in million for player HUMAN, PUPLIC, UNESCO
play_with_bonus <- true            // true or false for "bonus stuff"
city_pos <- {x = 398, y = 421}     // position of the city "Midtown"
const target_pax = 95              // target ratio pax
const traffic_level = 10           // level for puplic road traffic
const separator = ","              // thousands separator

governors_island <- { x1 = 418, x2 = 437, y1 = 617, y2 = 650 }

airports <- {                      // just save positions of all airports; halt handles might get invalid, if player makes own halt public
        jfk = { x =  968, y =  494 }
        lag = { x =  601, y =  265 }
        new = { x =  207, y =  731 }
        tet = { x =  163, y =  283 }
        lin = { x =  136, y =  964 }
        non = { x = 1013, y = 1013 }
        }

const tax_start = 1965             // year of first tax
const tax_rate = 10                // tax amount in X of 100

const jfk_max_unhappy = 5          // maximum of allowed unhappy
const jfk_cash = 10                // factor for each passanger arrived

const charity_min = 100000000      // minimum net wealth for charity
const charity_rate = 2             // charity amount in X of thousandth, max=9

const tourism_cash = 20            // factor for each happy passanger
tourism_list <- {
           ellis_island   = { pos = {x = 374, y = 630, z = -2}, happy = 500, unhappy = 0, text = "Ellis Island" }
           liberty_island = { pos = {x = 377, y = 656, z = -2}, happy = 500, unhappy = 0, text = "Liberty Island" }
           central_park   = { pos = {x = 400, y = 350, z =  1}, happy = 800, unhappy = 0, text = "Central Park" }
           winter_skiing  = { pos = {x = 480, y =  87, z =  2}, happy = 300, unhappy = 0, text = "Skiing Resort" }
           }

const chicken_min = 550            // minimum of meat consumed a month
const chicken_growth = 10          // number to divide consumed for growth
chicken_list <- {                  // pos of store, pos of city
           downtown  = { pos = {x = 414, y = 587}, city = {x = 419, y = 580} }
           midtown   = { pos = {x = 409, y = 404}, city = {x = 398, y = 421} }
           greenwich = { pos = {x = 411, y = 452}, city = {x = 398, y = 455} }
           harlem    = { pos = {x = 391, y = 230}, city = {x = 376, y = 255} }
           inwood    = { pos = {x = 346, y =  77}, city = {x = 359, y = 132} }
           lag       = { pos = {x = 593, y = 266}, city = {x = 578, y = 317} }
           new       = { pos = {x = 204, y = 724}, city = {x =  99, y = 681} }
           jfk_1     = { pos = {x = 956, y = 492}, city = {x = 830, y = 502} }
           jfk_2     = { pos = {x = 956, y = 496}, city = {x = 985, y = 617} }
           }

const waste_level = 1200           // minimum of waste to be delivered
waste_list <- {                    // position of garbage dump
           midtown_west    = {x = 357, y = 410}
           midtown_east    = {x = 438, y = 435}
           lower_east_side = {x = 458, y = 487}
           downtown        = {x = 410, y = 552}
           ellis_island    = {x = 373, y = 629}
           liberty_island  = {x = 377, y = 657}
           }

const electro_level = 2200         // minimum of electronics to sell
electro_pos <- {x = 391, y = 488}  // position of factory
electro_cities <- {                // list of cities
           hoboken   = {x = 335, y = 497}
           soho      = {x = 397, y = 522}
           lowereast = {x = 451, y = 515}
           }

const refinery_gasoline = 7000     // minimum gasoline production
refinery_pos <- {x = 399, y = 827} // position of factory

const harlem_level = 11000         // minimum beer & food production
harlem_pos_beer <- {x = 406, y = 250}
harlem_pos_food <- {x = 359, y = 250}

const mail_level = 60              // minimum mail service rate / 100

const overdraft_rate = 1           // monthly bank account overdraft rate/100

const babyboom = 99                // minimum level of pax&mail for babyboom
const babyboom_growth = 100        // amount of citzens for babyboom

const bank_credit = 8000000        // credit amount
const bank_start = 1963            // year of credit allocation, must be bevor tax_start
const bank_end = 1973              // year to payback completely
const bank_assets = 1000000        // maximum allowed net wealth

const mining_start = -3            // first level to get decision
const mining_max = -5              // last level which will be allowed
const mining_level = 11000         // product units/year for each level
mining_pos1 <- {x = 254, y = 866}
mining_pos2 <- {x = 731, y = 800}

const car_level = 2600             // minimum of production for bonus
const car_cash = 200               // bonus cash for each car
const car_fine = 2500              // fine for each car if production decrease
const car_traffic = 15             // if any car is sold, set new traffic
car_pos <- {x = 312, y = 480}

const wholesale_level = 500        // minimum of goods in storage
const wholesale_growth = 50        // extra growth of cities
wholesale_pos <- {x = 356, y = 232}
wholesale_cities <- {              // list of cities
        a = {x = 313, y = 230}
        b = {x = 318, y = 287}
        c = {x = 368, y = 182}
        }

persistent.version <- version      // stores version of script
persistent.citizen <- 0            // stores citizens at startgame time
persistent.bankrupt <- false       // stores bankrupt; changes only one time
persistent.bonus <- null           // stores bonus stuff
persistent.counter <- 0            // stores the loops in each month
persistent.last_month <- -1        // stores lastmonth default -1
persistent.last_payed <- 0         // stores the amount of "vehicle earnings" after tax
persistent.percentage <- 0         // stores last percentage of scenario message
forbid_tools_list <- {
      hudson_river = {
             modus = "rect",
             waytyp= wt_all,
             tools = [tool_build_bridge, tool_build_tunnel, tool_raise_land, tool_setslope],
             error = ["No new bridge allowed across Hudson River.",
                      "No new tunnel allowed under Hudson River.",
                      "No terraforming allowed on Hudson River. It would destroy the legendary view.",
                      "No terraforming allowed across Hudson River. The mayor does not like to view ledgers from his office."
                     ],
             list  = [ [ {x = 320, y =   0}, {x = 327, y = 200} ],
                       [ {x = 328, y = 190}, {x = 350, y = 260} ],
                       [ {x = 340, y = 261}, {x = 350, y = 490} ],
                       [ {x = 351, y = 480}, {x = 360, y = 520} ],
                       [ {x = 361, y = 510}, {x = 375, y = 560} ],
                       [ {x = 376, y = 550}, {x = 390, y = 622} ],
                       [ {x = 384, y = 623}, {x = 410, y = 730} ]
                     ]
                     }
      central_park = {
             modus = "cube",
             waytyp= wt_all,
             tools = [tool_build_bridge, tool_build_way, tool_remover, tool_build_station, tool_lower_land, tool_raise_land, tool_setslope],
             error = ["No new ways in the Central Park.",
                      "No new ways in the Central Park.",
                      "The citizens want to keep their trees in the Central Park.",
                      "No new buildings after city council decision.",
                      "No terraforming allowed at Central Park.",
                      "No terraforming allowed at Central Park.",
                      "No terraforming allowed at Central Park."
                     ],
             list  = [ [ {x = 409, y = 399, z = 3}, {x = 391, y = 351, z = 0} ],
                       [ {x = 409, y = 349, z = 3}, {x = 391, y = 301, z = 0} ]
                     ]
                     }
      no_canal     = {
             modus = "rect",
             waytyp= wt_water,
             tools = [tool_build_bridge, tool_build_way],
             error = ["No canal crossing of Manhattan.",
                      "No canal crossing of Manhattan."
                     ],
             list  = [ [ {x = 408, y = 231}, {x = 410, y = 591} ],
                       [ {x = 366, y = 251}, {x = 410, y = 231} ],
                       [ {x = 364, y =  70}, {x = 366, y = 251} ]
                     ]
                     }
      }      // end of forbid_tools_list

// END of declarations



function start()
{
        create_bonus_table()
        // set start cash for players
        for (local i=0; i<startcash.len();i++)
            player_x(i).book_cash( ( (startcash[i] * 1000000) - player_x(i).get_cash()[0]) * 100)
        persistent.citizen = world.get_citizens()[0]
        forbid_tools(0, forbid_tools_list)
        resume_game()
}


function get_about_text(pl)
{
        local about = ttextfile("about.txt")
        about.short_description =  scenario.short_description
        about.version =  scenario.version
        about.author =  scenario.author
        about.translation = scenario.translation
        return about
}


function get_info_text(pl)
{
        local info = ttextfile("info.txt")
        info.startyear = settings.get_start_time().year
        info.citizen = integer_to_string(persistent.citizen)
        info.startcash =  money_to_string(startcash[0] * 1000000)
        info.airports = airports.len()              // only airports in list
        info.factories = world.get_factories()[0]   // well, that's the current amount
        info.towns = world.get_towns()[0]           // well, that's the current amount
        return info
}


function get_rule_text(pl)
{
        local rule = ttextfile("rule.txt")
        rule.tax_start = tax_start
        rule.tax_rate = tax_rate
        rule.charity_rate = charity_rate
        rule.charity_min = money_to_string(charity_min)
        rule.tourism_cash = money_to_string(tourism_cash)
        local places = ""
        foreach (p in tourism_list)
             {
              local p2 = p.pos.x+","+p.pos.y
              places+= " " + ttext("min_happy") + "=" + integer_to_string(p.happy)
              places+= " " + ttext("max_unhappy") + "=" + integer_to_string(p.unhappy)
              places+= " <a href=\"("+p2+")\">" + ttext(p.text)+"</a>"
              places+= " ("+p2+","+p.pos.z +")<br>"
             }
        rule.tourism_places = places
        rule.jfk_cash = money_to_string(jfk_cash)
        rule.jfk_max_unhappy = jfk_max_unhappy
        rule.jfk_pos = "(" + airports.jfk.x + "," + airports.jfk.y + ")"
        rule.lag_pos = "(" + airports.lag.x + "," + airports.lag.y + ")"
        rule.new_pos = "(" + airports.new.x + "," + airports.new.y + ")"
        rule.refinery_gasoline = refinery_gasoline
        rule.refinery_name = give_factory_link(refinery_pos)
        rule.harlem_level = harlem_level
        rule.harlem_name_food = give_factory_link(harlem_pos_food)
        rule.harlem_name_beer = give_factory_link(harlem_pos_beer)
        rule.overdraft_rate = overdraft_rate
        rule.bank_credit = money_to_string(bank_credit)
        rule.bank_month = (bank_end - bank_start) * 12
        rule.bank_start = bank_start
        rule.bank_assets = money_to_string(bank_assets)
        local level = ""
        for (local i = mining_start; i >= mining_max; i--)
            { level+= i + " = " + integer_to_string(-i * mining_level) + "<br>" }
        rule.mining_levels = level
        rule.mining_max = mining_max
        rule.mining_name1 = give_factory_link(mining_pos1)
        rule.mining_name2 = give_factory_link(mining_pos2)
        places = ""
        foreach (p in waste_list)
             {
              places+= give_factory_link(p)
              places+= " " + ttext("at") + " (" + p.x + "," + p.y + ")<br>"
             }
        rule.waste_list = places.slice(0,-4)
        rule.waste_level = integer_to_string(waste_level)
        rule.chicken_min = integer_to_string(chicken_min)
        places = ""
        foreach (p in chicken_list)
             {
              places+= " <a href\"("+p.pos.x+","+p.pos.y+")\">"
              places+= ttext("SFC store")+"</a> " + ttext("at")
              places+= " <a href=\"("+p.city.x+","+p.city.y+")\">"
              places+= city_x(p.city.x,p.city.y).get_name()+"</a><br>"
             }
        rule.chicken_list = places.slice(0,-4)
        rule.car_level = integer_to_string(car_level)
        rule.car_cash = money_to_string(car_cash)
        rule.car_fine = money_to_string(car_fine)
        rule.car_name = give_factory_link(car_pos)
        rule.electro_level = integer_to_string(electro_level)
        rule.electro_name = give_factory_link(electro_pos)
        rule.wholesale_level = integer_to_string(wholesale_level)
        rule.wholesale_growth = integer_to_string(wholesale_growth)
        rule.wholesale_name = give_factory_link(wholesale_pos)
        rule.cityname = city_x(city_pos.x,city_pos.y).get_name()
        rule.mail_level = mail_level
        rule.babyboom_level = babyboom
        return rule
}


function get_goal_text(pl)
{
        local goal = ttextfile("goal.txt")
        goal.target_pax_ratio = target_pax
        goal.cityname = city_x(city_pos.x,city_pos.y).get_name()
        goal.citypos = city_pos.x + "," + city_pos.y
        return goal
}


function get_result_text(pl)
{
        if (persistent.bankrupt)
           { return ttext("<st>You lost!</st><br><br>You are bankrupt, and the mayor is very disappointed by you.") }
        local result = ttextfile("result.txt")
        local city = city_x(city_pos.x,city_pos.y)
        switch(hq_level(pl) ) {
                case 0: result.hq_text = ttext("You did not build a headquarter yet. Go earn more money.")
                        break
                case 1: result.hq_text = ttext("You build only a small headquarter.")
                        break
                case 2: result.hq_text = ttext("You build a luxurious headquarter.")
                        break
                default:
                        break
        }
        result.cityname = city_x(city_pos.x,city_pos.y).get_name()
        result.ratio_scenario = is_scenario_completed(pl)
        result.ratio_pax = get_pax_ratio(city)
        result.ratio_mail = get_mail_ratio(city)
        result.airports = get_served_airports()
        result.bonus_tourism = money_to_string(persistent.bonus.tourism)
        result.bonus_jfk = money_to_string(persistent.bonus.jfk)
        result.bonus_car = money_to_string(persistent.bonus.cars[1])
        // persistent.bonus.cars[0] amount of cars
        result.tax_to_pay = money_to_string(persistent.bonus.tax)
        result.tax_rate = tax_rate
        result.charity_to_pay = money_to_string(persistent.bonus.charity)
        result.charity_rate = charity_rate
        result.refinery_gasoline = persistent.bonus.refinery
        result.harlem_food_beer =  persistent.bonus.harlem[0] + " & " + persistent.bonus.harlem[1]
        result.overdraft_rate = overdraft_rate
        result.overdraft_to_pay = money_to_string(persistent.bonus.overdraft)
        result.bank_credit = money_to_string(persistent.bonus.bank)
        if (persistent.bonus.bank == -1) { result.bank_credit = ttext("has been repaid") }

        result.mining_units =  persistent.bonus.mining
        result.waste = (persistent.bonus.waste == waste_list.len()) ? money_to_string(result.bonus_tourism) : money_to_string(0)
        result.chicken_growth = persistent.bonus.chicken
        result.electro_growth = (persistent.bonus.electro > electro_level) ? "1" : "0"
        result.wholesale_growth = persistent.bonus.wholesale

        result.bonus_aktiv = ""
        if (!play_with_bonus)
           {
            result.bonus_aktiv = "<br>" + ttext("<st>bonus stuff is not aktiv.</st><br><br>to change look in file scenario.nut") + "<br><br>"
           }
        return result + script_development(pl).tostring()
}



function give_factory_link(pos)
{
        local text = "<a href=\"(" + pos.x + "," + pos.y + ")\">"
        text+= translate( factory_x(pos.x,pos.y).get_name() ) + "</a>"
        return text
}


function sum(a,b)
{
        return a+b
}


function script_development(pl)
{
        local s = ""
        // first infos about player; NO translation text
        s = "<br><em>script development informations</em><br><br>"
        s+= "this month transported :<br>pax={transported_pax} mail={transported_mail} "
        s+= "goods={transported_goods} all={transported_all}<br>"
        s+= "You used {convoys} convoys and ??? lines.<br>"
        s = ttext(s)
        s.transported_pax = player_x(pl).get_transported_pax()[0]
        s.transported_mail = player_x(pl).get_transported_mail()[0]
        s.transported_goods = player_x(pl).get_transported_goods()[0]
        s.transported_all = player_x(pl).get_transported()[0]
        s.convoys = player_x(pl).get_convoys()[0]
        // that's it - in the moment
        return s
}


function hq_level(pl)
{
        local level = player_x(pl).get_headquarter_level()
        local pos = player_x(pl).get_headquarter_pos()
        if ( !(pos.x >= 0) ) { level = 0 }
        return level
}


function get_served_airports()
{
        local served = 0
        foreach(airp in airports) {
                local halt = square_x( airp.x, airp.y ).halt
                local flying_pax = halt.happy.reduce( sum )
                if (flying_pax > 0) { served ++ }
        }
        return served
}


function get_pax_ratio(city)
{
        local pax_generated = city.generated_pax.reduce(sum)
        local pax_transported = city.transported_pax.reduce(sum)
        return (pax_transported*100) / pax_generated
}


function get_mail_ratio(city)
{
        local mail_generated = city.generated_mail.reduce(sum)
        local mail_transported = city.transported_mail.reduce(sum)
        return (mail_transported*100) / mail_generated
}


function bonus_tourism(pl)
{
        // transport passanger for tourism committee
        local tourism_done  = 0
        local tourism_happy = 0
        foreach(point in tourism_list)
                 {
                  local halt = tile_x( point.pos.x, point.pos.y, point.pos.z ).get_halt()
                  if (! (halt == null))
                     {
                      if (halt.get_unhappy()[1] <= point.unhappy && halt.get_happy()[1] >= point.happy)
                         {
                          tourism_done++
                          tourism_happy+= halt.get_happy()[1]
                         }
                     }
                 }
        persistent.bonus.tourism = 0
        if ( tourism_done != tourism_list.len() ) return
        persistent.bonus.tourism = tourism_happy * tourism_cash
        player_x(pl).book_cash( persistent.bonus.tourism * 100 )
}


function bonus_jfk(pl)
{
        // JFK airport managment likes to be bigger then the airports
        // LAG and NEW together by departed (counts pax, mail and goods)
        local jfk = square_x( airports.jfk.x, airports.jfk.y ).halt
        local lag = square_x( airports.lag.x, airports.lag.y ).halt
        local new = square_x( airports.new.x, airports.new.y ).halt
        local jfk_pax = jfk.get_departed()[1]
        local other_pax = lag.get_departed()[1] + new.get_departed()[1]
        persistent.bonus.jfk = 0
        if (jfk_pax > other_pax && jfk.get_unhappy()[1] <= jfk_max_unhappy)
           {
            persistent.bonus.jfk = (jfk_pax - other_pax) * jfk_cash
            player_x(pl).book_cash( persistent.bonus.jfk * 100 )
           }
}


function bonus_charity(pl)
{
        // with an amount of X net wealth you have to donate
        persistent.bonus.charity = 0
        if (player_x(pl).get_net_wealth()[1] < charity_min) return
        persistent.bonus.charity = player_x(pl).get_net_wealth()[1] * charity_rate / 1000
        player_x(pl).book_cash( persistent.bonus.charity * -100)
}


function bonus_refinery(pl)
{
        // take care that the plant can produce a minimum of X gasoline
        // write Gasoline not gasoline !!!
        local refinery = factory_x(refinery_pos.x,refinery_pos.y).output
        persistent.bonus.refinery = refinery.Gasoline.get_produced()[1]
        if (persistent.bonus.refinery >= refinery_gasoline)
             { rules.allow_way_tool(pl, tool_build_way, wt_air) }
        else { rules.forbid_way_tool(pl, tool_build_way, wt_air) }
}


function bonus_mail(pl)
{
        // reach post service X to get Taxiway and Runway (or use refinery to get it)
        local city = city_x(city_pos.x,city_pos.y)
        persistent.bonus.mail = get_mail_ratio(city)
        if (persistent.bonus.mail > mail_level)
             { rules.allow_way_tool(pl, tool_build_way, wt_air) }
        else { rules.forbid_way_tool(pl, tool_build_way, wt_air) }
}


function bonus_harlem(pl)
{
        // take care that the two plants can produce a minimum of X
        // than it's possible to uses tram ways in Harlem and East Harlem
        local text = ttext("No tram in Harlem and East Harlem! There is to much crime.")
        local beer = factory_x(harlem_pos_beer.x,harlem_pos_beer.y).output.beer.get_produced()[1]
        local food = factory_x(harlem_pos_food.x,harlem_pos_food.y).output.food.get_produced()[1]
        persistent.bonus.harlem = [ beer, food ]
        if (beer >= harlem_level && food >= harlem_level)
             { rules.allow_way_tool_cube(pl, tool_build_way, wt_tram, {x=350,y=221,z=1},{x=447,y=300,z=-1} ) }
        else { rules.forbid_way_tool_cube(pl, tool_build_way, wt_tram, {x=350,y=221,z=1},{x=447,y=300,z=-1} , text ) }
}


function bonus_electro(pl)
{
        // sell electronics to stop city growth
        local growth = true
        persistent.bonus.electro = factory_x(electro_pos.x,electro_pos.y).input.electronics.get_consumed()[1]
        if (persistent.bonus.electro >= electro_level)
           {
            growth = false
            local text = ttext("No city growth this month in {cities}.")
            local text2 = ""
            foreach (city in electro_cities)
                    text2+= city_x(city.x,city.y).get_name() + ", "
            text.cities = text2.slice(0,-2)
            gui.add_message( text.tostring() )
           }
        foreach (city in electro_cities)
                 city_x(city.x,city.y).set_citygrowth_enabled(growth)
}


function bonus_bank(pl)
{
        // does the player need a credit to continue the scenario
        // or check if it's time to pay back
        if (world.get_time().year == bank_start && world.get_time().month == 0)
           {
            if (player_x(pl).get_net_wealth()[0] < bank_assets)     // use this month
               {
                persistent.bonus.bank = bank_credit
                player_x(pl).book_cash( persistent.bonus.bank * 100)
                local text = ttext("You recieve the credit in the amount of {credit}.")
                text.credit = money_to_string(persistent.bonus.bank)
                gui.add_message( text.tostring() )
               }
           }
        if (world.get_time().year == bank_end && world.get_time().month == 0)
           {
            if (persistent.bonus.bank == bank_credit)
               {
                player_x(pl).book_cash( persistent.bonus.bank * -100)
                local text = ttext("You pay off the credit in the amount of {credit}.")
                text.credit = money_to_string(persistent.bonus.bank)
                gui.add_message( text.tostring() )
                persistent.bonus.bank = -1
               }
           }
}


function bonus_mining(pl)
{
        // take care that the two mines produce a minimum of X in last 12 month
        // for X you get decision for level -Y to do underground work
        local cube = [ {x=0,y=0,z=-7} , {x=1023,y=1023,z=mining_start} ]
        local text_1 = ttext("Underground workings below the waterline are not possible yet.")
        local text_2 = ttext("Underground workings below level {mining_level} are not possible yet.")
        local factory_1 = factory_x(mining_pos1.x, mining_pos1.y).output.Kohle.get_produced().reduce(sum)
        local factory_2 = factory_x(mining_pos2.x, mining_pos2.y).output.Kohle.get_produced().reduce(sum)
        local cube_level_old = -persistent.bonus.mining / mining_level
        persistent.bonus.mining = factory_1 + factory_2
        local cube_level = -persistent.bonus.mining / mining_level
        if (cube_level <= mining_start)
             {
              for (local i = mining_max; i <= mining_start; i++)
                  {
                   cube[1].z = i
                   rules.allow_way_tool_cube(pl, tool_build_tunnel, wt_all, cube[0], cube[1] )
                  }
              if (cube_level < mining_max) { cube_level = mining_max }
              cube[1].z = cube_level -1            // forbid levels below
              text_2.mining_level = cube_level     // give user info about level
              rules.forbid_way_tool_cube(pl, tool_build_tunnel, wt_all, cube[0], cube[1] , text_2 )
              if (cube_level != cube_level_old)
                 {
                  local text = ttext("You have obtained permission for underground workings until level {level}.")
                  text.level = cube_level
                  gui.add_message( text.tostring() )
                 }
             }
        else
             { rules.forbid_way_tool_cube(pl, tool_build_tunnel, wt_all, cube[0], cube[1] , text_1 ) }
}


function bonus_chicken(pl)
{
        // support the stores of SFC with meat, city growth increase
        local consumed = 0
        local growth = 0
        local citylist = ""
        local city = null
        persistent.bonus.chicken = 0         // Number of cities with extra growth
        foreach (store in chicken_list)
            {
             consumed = factory_x(store.pos.x,store.pos.y).input.meat.get_consumed()[1]
             if (consumed >= chicken_min)    // increase city growth
                {
                 growth = consumed / chicken_growth
                 city = city_x(store.city.x,store.city.y)
                 city.change_size(growth)
                 persistent.bonus.chicken++
                 citylist+= city.get_name() + " " + growth + ", "
                }
            }
        if (citylist == "") return
        local text = ttext("SFC additional city growth: {citylist} citizen.")
        text.citylist = citylist.slice(0,-2)
        gui.add_message( text.tostring() )
}


function bonus_cars(pl)
{
        // start car production, give bonus, pay fine if production decrease
        persistent.bonus.cars = [0,0]
        local cars = factory_x(car_pos.x, car_pos.y).output.Autos.get_produced()[1]
        if (cars >= car_level && cars >= persistent.bonus.cars[0])
           { persistent.bonus.cars[1] = cars * car_cash }
        if (cars < persistent.bonus.cars[0])
           { persistent.bonus.cars[1]+= (persistent.bonus.cars[0] - cars) * -car_fine }
        persistent.bonus.cars[0] = cars
        player_x(pl).book_cash( persistent.bonus.cars[1] * 100)
        if (cars > 0)
             { settings.set_traffic_level(car_traffic) }
        else { settings.set_traffic_level(traffic_level) }
}


function bonus_wholesale(pl)
{
        // material wholesale goods storage; city growth increase
        local growth = true
        persistent.bonus.wholesale = 0
        foreach(key,value in factory_x(wholesale_pos.x, wholesale_pos.y).input)
               if (value.get_storage()[1] > wholesale_level)
                   { persistent.bonus.wholesale++ }
        if (persistent.bonus.wholesale == 3)
           {
            growth = false
            local text = ttext("No city growth this month in {cities}.")
            local text2 = ""
            foreach (city in electro_cities)
                    text2+= city_x(city.x,city.y).get_name() + ", "
            text.cities = text2.slice(0,-2)
            gui.add_message( text.tostring() )
           }
        foreach (city in electro_cities)
                city_x(city.x, city.y).set_citygrowth_enabled(wholesale_growth)
}


function bonus_babyboom(pl)
{
        // if reached level babyboom in all towns of cities
        local city = city_x(city_pos.x,city_pos.y)
        if (get_pax_ratio(city) < babyboom || get_mail_ratio(city) < babyboom) return
        foreach (boomcity in city_list_x() )
               { boomcity.change_size(babyboom_growth)  }
        local text = ttext("Excellent pax and mail service! Baby boom in all towns.")
        gui.add_message( text.tostring() )
}


function bonus_waste(pl)
{
        // transport X waste each month and get trourism_payed again
        local waste = 0
        persistent.bonus.waste = 0
        foreach (place in waste_list)
            {
             waste = factory_x(place.x,place.y).output.waste.get_delivered()[1]
             if (waste >= waste_level) { persistent.bonus.waste++ }
            }
        if ( persistent.bonus.waste == waste_list.len() )     // pay again tourism bonus
            { player_x(pl).book_cash( persistent.bonus.tourism * 100 ) }
}


function bonus_tax(pl)
{
        // pay sales tax for this month
        // control the income it can be below zero
        local time = world.get_time()
        persistent.bonus.tax = 0
        if (time.year < tax_start) return
        if (time.year == tax_start && time.month == 0) return   // don't pay for december in first year
        local income = player_x(pl).get_income()[1]        // vehicle earnings
        income+= player_x(pl).get_powerline()[1]           // powerline earnings
        income+= -persistent.last_payed                    // add last month paying
        if (income < 0) return
        persistent.bonus.tax = income * tax_rate / 100
        player_x(pl).book_cash( persistent.bonus.tax * -100)
}


function bonus_overdraft(pl)
{
        // pay sales tax for this month
        // control the income it can be below zero
        local cash = player_x(pl).get_cash()[1]
        persistent.bonus.overdraft = 0
        if (cash > 0) return
        persistent.bonus.overdraft = cash * overdraft_rate / -100
        player_x(pl).book_cash( persistent.bonus.overdraft * -100)
}


function do_bonus(pl,percentage)
{
        if (persistent.counter == 2)             // use switch option
            {
             if (player_x(pl).get_net_wealth()[0] < 0)    // never be bankrupt
                {
                 persistent.bankrupt = true
                 return 0                                 // give percentage zero
                }
             bonus_tourism(pl)
             bonus_jfk(pl)
             bonus_waste(pl)
             bonus_cars(pl)
             bonus_tax(pl)                            // calculate tax at last
             bonus_charity(pl)                        // after tax
             bonus_overdraft(pl)                      // pay overdraft after tax
             bonus_bank(pl)                           // sure, credit without tax
             persistent.last_payed = player_x(pl).get_income()[0]
             if (persistent.last_payed > 0) { persistent.last_payed = 0 }
             if (persistent.bonus.tax > 0 || persistent.bonus.overdraft > 0 || persistent.bonus.charity > 0)
                {
                 local text = ttext("You payed for the last month: {tax} sales tax, {donate} donation, {overdraft} overdraft charge")
                 text.tax = money_to_string(persistent.bonus.tax)
                 text.donate = money_to_string(persistent.bonus.charity)
                 text.overdraft = money_to_string(persistent.bonus.overdraft)
                 gui.add_message( text.tostring() )
                }
            }
        if (persistent.counter == 3)           // take care off bonus tools
               {
                bonus_refinery(pl)
                bonus_mail(pl)
                bonus_harlem(pl)
                bonus_mining(pl)
               }
        if (persistent.counter == 4)           // extra growth on/off can bee done later
               {
                bonus_electro(pl)
                bonus_chicken(pl)
                bonus_wholesale(pl)
               }
        if (persistent.counter == 6)           // this takes very much time
               {
                bonus_babyboom(pl)
               }
        // make update of screen here ; method needed
        return percentage
}


function is_scenario_completed(pl)
{
        if (pl != 0) return 0                        // other player get only 0%
        local percentage = 0
        local city = city_x(city_pos.x,city_pos.y)   // don't move! Why? I don't know!

        percentage = min( get_pax_ratio(city), 95 )  // transported passengers up to 95% to have 5% space left
        percentage = 95 * percentage / target_pax    // change for lower targets
        if (hq_level(pl) >= 1)  percentage ++        // headquarter gives up to 2%
        if (hq_level(pl) == 2)  percentage ++
        percentage+= min(get_served_airports(),6)/2  // this gives up to 3%
        if (percentage == 100) { gui.add_message("You won the scenario!") }

        persistent.counter++
        if (persistent.last_month != world.get_time().month)
            {
             persistent.last_month = world.get_time().month
             persistent.counter = 0                  // new month, set counter = 0
             // give other players cash for maintenance
             player_x(1).book_cash( (player_x(1).get_maintenance()[0] + 1) * -100 )
             player_x(2).book_cash( (player_x(2).get_maintenance()[0] + 1) * -100 )
             if (persistent.percentage != percentage && percentage % 5 == 0 && percentage < 100)
                {
                 local text = ttext("The scenario is up to {ratio_scenario}% complete.")
                 text.ratio_scenario = percentage
                 gui.add_message_at( text.tostring(), city_pos )
                 persistent.percentage = percentage          // save only here
                }
            }
        if (play_with_bonus) percentage = do_bonus(pl,percentage)
        return percentage
}


function create_bonus_table()
{
 persistent.bonus <- {           // stores bonus stuff
    jfk = 0, tourism = 0, cars = [0,0], waste = 0,      // effect earn money
    refinery = 0, mail = 0, harlem = [0,0], mining = 0, // effect tools or ways
    chicken = 0, electro = 0, wholesale = 0,            // effect city growth
    tax = 0, bank = 0, charity = 0, overdraft = 0       // effect loan or pay money
    }
}


function resume_game()
{
        local pl = 0                               // player default 0
        if ( !("version" in persistent) ) { persistent.version <- 0 }
        if ( !("bankrupt"in persistent) ) { persistent.bankrupt <- 0 }
        if ( !("citizen" in persistent) ) { persistent.citizen <- world.get_citizens()[0] }
        if ( !("counter" in persistent) ) { persistent.counter <- 0 }
        if ( !("bonus"   in persistent) ) { create_bonus_table() }
        if ( !("last_payed"in persistent)){ persistent.last_payed <- 0 }
        if ( !("percentage"in persistent)){ persistent.percentage <- 0 }
        if ( !("last_month"in persistent)){ persistent.last_month <- -1 }

        // check for script version and compatibility, then use update
        if ( persistent.version < version )
             { update() }                          // do update old versions
        else { gui.open_info_win() }               // show scenario window

        persistent.version = version

        // correct settings of savegame
        settings.set_industry_increase_every(0)    // no industries will be created
        settings.set_traffic_level(traffic_level)  // set traffic level again, to be sure
        rules.forbid_tool(pl, tool_add_city )      // no extra city

        if (play_with_bonus)           // bonus stuff for tools/ways
           {
            bonus_mining(pl)
            bonus_refinery(pl)
            bonus_mail(pl)
            bonus_harlem(pl)
           }
}


function is_work_allowed_here(pl, tool_id, pos)
{
        if (tool_id == tool_headquarter){      // headquarter only on governors island
                if (pos.x<governors_island.x1  ||  governors_island.x2<pos.x || pos.y<governors_island.y1  ||  governors_island.y2<pos.y) {
                    return ttext("According to the contract with the city, you have to build your headquarter on Governors Island.")
                   }
                }
        return null                            // null is equivalent to 'allowed'
}


function forbid_tools(pl, list)
{
        foreach(j in list) {
            if (j.modus == "rect") {
                for (local i=0; i < j.tools.len(); i++) {
                     for (local e=0; e < j.list.len(); e++) {
                         rules.forbid_way_tool_rect(pl, j.tools[i], j.waytyp, j.list[e][0], j.list[e][1], ttext(j.error[i]) )
                         }
                     }
               }
            else {
                for (local i=0; i < j.tools.len(); i++) {
                     for (local e=0; e < j.list.len(); e++) {
                         rules.forbid_way_tool_cube(pl, j.tools[i], j.waytyp, j.list[e][0], j.list[e][1], ttext(j.error[i]) )
                         }
                     }
               }
           }
}


function update()         // update for older versions
{
 local text = ttext("Savegame has a different {more_info} script version! Maybe, it will work.")
 text.more_info = "(0." + persistent.version + ")"
 gui.add_message( text.tostring() )

 // version 1 : NO support, map places, bridges,... doesn't fit any more (sorry)
 if (persistent.version <= 1) { gui.add_message("Version 0.1 does not work!") }

 // version 2 : Overwrite bonus_table again, even if it exists !!!
 if (persistent.version == 2) { create_bonus_table() }

 // version 3 : do same as in version 2
 if (persistent.version == 3) { create_bonus_table() }

 // version X

 // -- my developer help --
}

// END OF FILE