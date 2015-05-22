---
layout: default-post-leaflet
title: The Fastest Parade of Homes Ever
tags:
- R
- leaflet
- TSP 
- Concorde
- fun
- Iowa
- R-bloggers
---

The Fastest Parade of Homes Ever
================================

|houses[tour, 1]                            |
|:------------------------------------------|
|2826 120th St, Shueyville, IA              |
|Majestic Oak Ridge, Solon, IA              |
|718 Raymond Dr, Solon, IA                  |
|704 Raymond Dr, Solon, IA                  |
|1000 Wood Lily Rd, Solon, IA               |
|1925 Silver Maple Trail, North Liberty, IA |
|2020 Silver Maple Trail, North Liberty, IA |
|395 Radcliffe Dr, North Liberty, IA        |
|2095 Dempster Dr, Coralville, IA           |
|1981 Ollinger Dr, Coralville, IA           |
|9 Chad Ct, Coralville, IA                  |
|3017 Woodland Ridge Dr NE, Iowa City, IA   |
|946 Canton St, Iowa City, IA               |
|775 Barber Place, Iowa City, IA            |
|603 River St, Iowa City, IA                |
|1324 E Davenport St., Iowa City, IA        |
|1317 Rochester Ave, Iowa City, IA          |
|1802  Winston Dr, Iowa City, IA            |
|401 Garden St, Iowa City, IA               |
|1824 G St, Iowa City, IA                   |
|631 Second Ave, Iowa City, IA              |
|192 Lindemann Dr, Iowa City, IA            |
|4721 Chandler Ct, Iowa City, IA            |
|208 Brady St, Hills, IA                    |
|3070 Vine Valley Dr, Riverside, IA         |
|1048 Bluegrass Dr, Riverside, IA           |
|1426 Walter Mapp Dr, Riverside, IA         |
|1915 Calvin Ave, Iowa City, IA             |
|1610 Dunley Ct, Iowa City, IA              |
|903 Tipperary Rd, Iowa City, IA            |
|802 Ryan Ct, Iowa City, IA                 |
|1266 Eagle Place, Iowa City, IA            |
|1059 Camp Cardinal Rd, Iowa City, IA       |
|408 Dogwood Lane, Tiffin, IA               |

<p><div id="htmlwidget-6970" style="width:720px;height:480px;" class="leaflet"></div>
<script type="application/json" data-for="htmlwidget-6970">{"x":{"calls":[{"method":"addTiles","args":["http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,{"minZoom":0,"maxZoom":18,"maxNativeZoom":null,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"continuousWorld":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":null,"unloadInvisibleTiles":null,"updateWhenIdle":null,"detectRetina":false,"reuseTiles":false,"attribution":"&copy; <a href=\"http://openstreetmap.org\">OpenStreetMap</a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>"}]},{"method":"addCircles","args":[[41.8478012,41.74797,41.7682995,41.7681931,41.8068888,41.8042198,41.8042198,41.7987348,41.7139207,41.7153502,41.7145734,41.7173,41.6704609,41.669524,41.6667656,41.6455052,41.6509853,41.6769076,41.6755277,41.663643,41.6603734,41.5076062,41.4925353,41.4464019,41.701928,41.65385,41.667263,41.665892,41.666835,41.656296,41.6529979,41.649842,41.649333,41.553627],[-91.6534914,-91.5882795,-91.5919466,-91.5897007,-91.4870328,-91.4835781,-91.4835781,-91.4833871,-91.5405055,-91.5913289,-91.5884344,-91.6611,-91.5976217,-91.5987852,-91.6006026,-91.6052944,-91.5857484,-91.5585152,-91.557447,-91.5160159,-91.4778227,-91.5429689,-91.5430129,-91.5303996,-91.590729,-91.567684,-91.54736,-91.516301,-91.509629,-91.509879,-91.503846,-91.508569,-91.466745,-91.533959],750,null,{"lineCap":null,"lineJoin":null,"clickable":true,"pointerEvents":null,"className":"","stroke":true,"color":"#03F","weight":1,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.5,"dashArray":null},["2826 120th St, Shueyville, IA","395 Radcliffe Dr, North Liberty, IA","1925 Silver Maple Trail, North Liberty, IA","2020 Silver Maple Trail, North Liberty, IA","Majestic Oak Ridge, Solon, IA","704 Raymond Dr, Solon, IA","718 Raymond Dr, Solon, IA","1000 Wood Lily Rd, Solon, IA","3017 Woodland Ridge Dr NE, Iowa City, IA","2095 Dempster Dr, Coralville, IA","1981 Ollinger Dr, Coralville, IA","408 Dogwood Lane, Tiffin, IA","1266 Eagle Place, Iowa City, IA","1059 Camp Cardinal Rd, Iowa City, IA","802 Ryan Ct, Iowa City, IA","1610 Dunley Ct, Iowa City, IA","903 Tipperary Rd, Iowa City, IA","775 Barber Place, Iowa City, IA","946 Canton St, Iowa City, IA","1317 Rochester Ave, Iowa City, IA","192 Lindemann Dr, Iowa City, IA","3070 Vine Valley Dr, Riverside, IA","1048 Bluegrass Dr, Riverside, IA","1426 Walter Mapp Dr, Riverside, IA","9 Chad Ct, Coralville, IA","1915 Calvin Ave, Iowa City, IA","603 River St, Iowa City, IA","1324 E Davenport St., Iowa City, IA","1802  Winston Dr, Iowa City, IA","401 Garden St, Iowa City, IA","631 Second Ave, Iowa City, IA","1824 G St, Iowa City, IA","4721 Chandler Ct, Iowa City, IA","208 Brady St, Hills, IA"]]},{"method":"addPolylines","args":[[[{"lng":[-91.6534914,-91.6611,-91.5987852,-91.5976217,-91.6006026,-91.5857484,-91.6052944,-91.567684,-91.5303996,-91.5430129,-91.5429689,-91.533959,-91.466745,-91.4778227,-91.503846,-91.508569,-91.509879,-91.509629,-91.5160159,-91.516301,-91.54736,-91.5585152,-91.557447,-91.5405055,-91.590729,-91.5884344,-91.5913289,-91.5882795,-91.5897007,-91.5919466,-91.4833871,-91.4835781,-91.4835781,-91.4870328,-91.6534914],"lat":[41.8478012,41.7173,41.669524,41.6704609,41.6667656,41.6509853,41.6455052,41.65385,41.4464019,41.4925353,41.5076062,41.553627,41.649333,41.6603734,41.6529979,41.649842,41.656296,41.666835,41.663643,41.665892,41.667263,41.6769076,41.6755277,41.7139207,41.701928,41.7145734,41.7153502,41.74797,41.7681931,41.7682995,41.7987348,41.8042198,41.8042198,41.8068888,41.8478012]}]],null,{"lineCap":null,"lineJoin":null,"clickable":true,"pointerEvents":null,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":false,"fillColor":"red","fillOpacity":0.2,"dashArray":null,"smoothFactor":1,"noClip":false},null]}],"limits":{"lat":[41.4464019,41.8478012],"lng":[-91.6611,-91.466745]}},"evals":[]}</script></p>

* Download the [R source code]({{ site.url }}/2015-05-20-parade-of-homes/main.R).
