---
layout: default-post-leaflet
title: The Fastest Parade Ever
tags:
- R
- leaflet
- TSP 
- Concorde
- fun
- Iowa
- R-bloggers
---

The Fastest Parade Ever
=======================

Every June, homebuilders and home remodelers in the Iowa City area
have a "Parade of Homes" to showcase their new homes
and remodeling projects. Anyone can buy a ticket to the parade and
visit the homes. The [2015 Parade of Homes](http://iowacityhomes.thegazette.com)
is sponsored by the [Greater Iowa City Area Home Builders Association](http://www.iowacityhomes.com) and showcases 24 new homes and 10 remodeling projects.

I'm not sure if anyone actually plans to visit all 34 homes---hey, why
not?! If someone did do this, I wondered: *which route visiting all 34
homes minimizes total driving time?*

This type of problem is known as the [*traveling salesman problem*](http://www.math.uwaterloo.ca/~bico/) and 
has a long history in business, computer science, and mathematics.
And it has many practical applications. For example, [UPS](http://ups.com) and
[FedEx](http://fedex.com)
solve it every day when delivering packages. It even got some [recent
attention from the Washington Post](http://knowmore.washingtonpost.com/2015/03/10/data-geniuses-have-figured-out-what-the-ultimate-u-s-road-trip-looks-like/).

I coded up a completely automated calculation of the
fastest route using [R](http://www.r-project.org), [Google
Maps](http://maps.google.com), [Leaflet](http://leafletjs.com), and the
[Concorde TSP solver](http://www.math.uwaterloo.ca/tsp/concorde/). Concorde
code just a split second, but the
minimum drive time is 3 hours and 46 minutes. The route is depicted
here (with corresponding table below):

<p><div id="htmlwidget-6970" style="width:720px;height:480px;" class="leaflet"></div>
<script type="application/json" data-for="htmlwidget-6970">{"x":{"calls":[{"method":"addTiles","args":["http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,{"minZoom":0,"maxZoom":18,"maxNativeZoom":null,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"continuousWorld":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":null,"unloadInvisibleTiles":null,"updateWhenIdle":null,"detectRetina":false,"reuseTiles":false,"attribution":"&copy; <a href=\"http://openstreetmap.org\">OpenStreetMap</a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>"}]},{"method":"addCircles","args":[[41.8478012,41.74797,41.7682995,41.7681931,41.8068888,41.8042198,41.8042198,41.7987348,41.7139207,41.7153502,41.7145734,41.7173,41.6704609,41.669524,41.6667656,41.6455052,41.6509853,41.6769076,41.6755277,41.663643,41.6603734,41.5076062,41.4925353,41.4464019,41.701928,41.65385,41.667263,41.665892,41.666835,41.656296,41.6529979,41.649842,41.649333,41.553627],[-91.6534914,-91.5882795,-91.5919466,-91.5897007,-91.4870328,-91.4835781,-91.4835781,-91.4833871,-91.5405055,-91.5913289,-91.5884344,-91.6611,-91.5976217,-91.5987852,-91.6006026,-91.6052944,-91.5857484,-91.5585152,-91.557447,-91.5160159,-91.4778227,-91.5429689,-91.5430129,-91.5303996,-91.590729,-91.567684,-91.54736,-91.516301,-91.509629,-91.509879,-91.503846,-91.508569,-91.466745,-91.533959],750,null,{"lineCap":null,"lineJoin":null,"clickable":true,"pointerEvents":null,"className":"","stroke":true,"color":"#03F","weight":1,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.5,"dashArray":null},["2826 120th St, Shueyville    ","395 Radcliffe Dr, North Liberty    ","1925 Silver Maple Trail, North Liberty    ","2020 Silver Maple Trail, North Liberty    ","Majestic Oak Ridge, Solon    ","704 Raymond Dr, Solon    ","718 Raymond Dr, Solon    ","1000 Wood Lily Rd, Solon    ","3017 Woodland Ridge Dr NE, Iowa City    ","2095 Dempster Dr, Coralville    ","1981 Ollinger Dr, Coralville    ","408 Dogwood Lane, Tiffin    ","1266 Eagle Place, Iowa City    ","1059 Camp Cardinal Rd, Iowa City    ","802 Ryan Ct, Iowa City    ","1610 Dunley Ct, Iowa City    ","903 Tipperary Rd, Iowa City    ","775 Barber Place, Iowa City    ","946 Canton St, Iowa City    ","1317 Rochester Ave, Iowa City    ","192 Lindemann Dr, Iowa City    ","3070 Vine Valley Dr, Riverside    ","1048 Bluegrass Dr, Riverside    ","1426 Walter Mapp Dr, Riverside    ","9 Chad Ct, Coralville    ","1915 Calvin Ave, Iowa City    ","603 River St, Iowa City    ","1324 E Davenport St., Iowa City    ","1802  Winston Dr, Iowa City    ","401 Garden St, Iowa City    ","631 Second Ave, Iowa City    ","1824 G St, Iowa City    ","4721 Chandler Ct, Iowa City    ","208 Brady St, Hills    "]]},{"method":"addPolylines","args":[[[{"lng":[-91.6534914,-91.6611,-91.5987852,-91.5976217,-91.6006026,-91.5857484,-91.6052944,-91.567684,-91.5303996,-91.5430129,-91.5429689,-91.533959,-91.466745,-91.4778227,-91.503846,-91.508569,-91.509879,-91.509629,-91.5160159,-91.516301,-91.54736,-91.5585152,-91.557447,-91.5405055,-91.590729,-91.5884344,-91.5913289,-91.5882795,-91.5897007,-91.5919466,-91.4833871,-91.4835781,-91.4835781,-91.4870328,-91.6534914],"lat":[41.8478012,41.7173,41.669524,41.6704609,41.6667656,41.6509853,41.6455052,41.65385,41.4464019,41.4925353,41.5076062,41.553627,41.649333,41.6603734,41.6529979,41.649842,41.656296,41.666835,41.663643,41.665892,41.667263,41.6769076,41.6755277,41.7139207,41.701928,41.7145734,41.7153502,41.74797,41.7681931,41.7682995,41.7987348,41.8042198,41.8042198,41.8068888,41.8478012]}]],null,{"lineCap":null,"lineJoin":null,"clickable":true,"pointerEvents":null,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":false,"fillColor":"red","fillOpacity":0.2,"dashArray":null,"smoothFactor":1,"noClip":false},null]}],"limits":{"lat":[41.4464019,41.8478012],"lng":[-91.6611,-91.466745]}},"evals":[]}</script></p>

|House |Address                                |Type             |
|:-----|:--------------------------------------|:----------------|
|1     |2826 120th St, Shueyville              |New Construction |
|12    |408 Dogwood Lane, Tiffin               |New Construction |
|14    |1059 Camp Cardinal Rd, Iowa City       |New Construction |
|13    |1266 Eagle Place, Iowa City            |New Construction |
|15    |802 Ryan Ct, Iowa City                 |New Construction |
|17    |903 Tipperary Rd, Iowa City            |New Construction |
|16    |1610 Dunley Ct, Iowa City              |New Construction |
|B     |1915 Calvin Ave, Iowa City             |Remodel          |
|24    |1426 Walter Mapp Dr, Riverside         |New Construction |
|23    |1048 Bluegrass Dr, Riverside           |New Construction |
|22    |3070 Vine Valley Dr, Riverside         |New Construction |
|J     |208 Brady St, Hills                    |Remodel          |
|I     |4721 Chandler Ct, Iowa City            |Remodel          |
|21    |192 Lindemann Dr, Iowa City            |New Construction |
|G     |631 Second Ave, Iowa City              |Remodel          |
|H     |1824 G St, Iowa City                   |Remodel          |
|F     |401 Garden St, Iowa City               |Remodel          |
|E     |1802 Winston Dr, Iowa City             |Remodel          |
|20    |1317 Rochester Ave, Iowa City          |New Construction |
|D     |1324 E Davenport St, Iowa City         |Remodel          |
|C     |603 River St, Iowa City                |Remodel          |
|18    |775 Barber Place, Iowa City            |New Construction |
|19    |946 Canton St, Iowa City               |New Construction |
|9     |3017 Woodland Ridge Dr NE, Iowa City   |New Construction |
|A     |9 Chad Ct, Coralville                  |Remodel          |
|11    |1981 Ollinger Dr, Coralville           |New Construction |
|10    |2095 Dempster Dr, Coralville           |New Construction |
|2     |395 Radcliffe Dr, North Liberty        |New Construction |
|4     |2020 Silver Maple Trail, North Liberty |New Construction |
|3     |1925 Silver Maple Trail, North Liberty |New Construction |
|8     |1000 Wood Lily Rd, Solon               |New Construction |
|7     |718 Raymond Dr, Solon                  |New Construction |
|6     |704 Raymond Dr, Solon                  |New Construction |
|5     |Majestic Oak Ridge, Solon              |New Construction |

* Download the [R source code]({{ site.url }}/2015-05-20-parade-of-homes/main.R).
* I used [these instructions](http://davidsjohnson.net/TSPcourse/mac-install-concorde.txt)
to install Concorde on my Mac.

