---
layout: default-post
title: Where in the World are Trader Joe's Warehouses?
tags:
- R
- ggplot2
- ggmap
- weather
- USA
- R-bloggers
---

Where in the World are Trader Joe's Warehouses?
===============================================

![Trader Joe's Logo]({{ site.url }}/2015-05-26-Trader-Joes/TJ.png)

[Trader Joe's](http://traderjoes.com) is a popular grocery chain in the
United States. Owned by [Aldi Nord](http://www.aldi-nord.de) of Germany,
Trader Joe's has the reputation for being tight-lipped
about its business strategy and plans. [This Fortune article](http://archive.fortune.com/2010/08/20/news/companies/inside_trader_joes_full_version.fortune/index.htm) provides
a good backgound.

As of June 2015, Trader Joe's has about 450 stores, and in my
hometown of Iowa City, there are often rumors about whether a new
Trader Joe's will be opening soon. Search on the web, and you'll
find that lots of people want more stores. Trader Joe's also has
[a website for people to request a new location in their own
city](http://www.traderjoes.com/contact-us/location-request).

Undoubtedly, choosing the next store location is a
critical business decision for Trader Joe's. The [above Fortune
article](http://archive.fortune.com/2010/08/20/news/companies/inside_trader_joes_full_version.fortune/index.htm)
discusses how the distribution network (of vendors, warehouses, and
stores) plays a role in choosing the next location. It makes sense that
a good location would be fairly close to an existing warehouse.

So, if one wanted to predict where Trader Joe's might open their next
store, it is logical to first figure out the locations of its
warehouses. However, Trader Joe's does not make this information public
(at least as far as I can tell). You can find clues on the web. For
example, there appear to be warehouses in the following cities:

* Stockton, CA ([evidence via Google Maps](https://www.google.com/maps/place/Trader+Joe's+Distribution+Center/@37.910789,-121.243112,17z/data=!4m7!1m4!3m3!1s0x80906cbe9fa2b1eb:0x3e602d559cac5cab!2sTrader+Joe's+Distribution+Center!3b1!3m1!1s0x80906cbe9fa2b1eb:0x3e602d559cac5cab))
* Daytona Beach, FL ([evidence via online news](http://www.news-journalonline.com/article/20150218/BUSINESS/150219409))
* Suwanee, GA ([evidence via LinkedIn profile](https://www.linkedin.com/in/seanpatrickrooney))
* Minooka, IL ([evidence via online news](http://www.chicagobusiness.com/realestate/20121105/CRED03/121109881/trader-joes-building-distribution-facilities-in-minooka))
* Bath, PA ([evidence via Facebook group](https://www.facebook.com/pages/Trader-Joes-Warehouse/117493291642892?rf=161281113892897))
* Irving, TX ([evidence via online news](http://texas.justgoodnews.biz/2013/05/10/trader-joes-bags-irving-warehouse/))

Besides scouring the Internet for evidence, *is it possible to
intelligently guess the locations of Trader Joe's warehouses?*

Starting with [the definitive list of Trader Joe's
stores](http://www.traderjoes.com/pdf/Trader-Joes-Stores.pdf), I
extracted the street addresses of all 451 stores and retrieved the
latitude and longitude of each store. Then I used *k*-means clustering
to group the 451 stores into 22 clusters, each with its own center.
These 22 centers are my best guess as to where the warehouses might be.

Why 22 groups? Trader Joe's does not even announce how many warehouses
it has. To apply *k*-means clustering, one has to guess a number of
warehouses---or clusters. I chose 22 because this is approximately the
square root of 451, which means that each warehouse would serve on
average about 22 stores. This seemed like a balanced guess, but it is
just a guess.

The following map shows all 451 stores in blue, the 22 guessed
warehouses in red, and the groups via black lines. Also shown in green
are the 6 known warehouses listed above. Note that the actual warehouses
are not too far from guessed warehouses. Not bad!

![Trader Joe's Predicted Warehouse Locations]({{ site.url }}/2015-05-26-Trader-Joes/TJ-DCs-web.png)

* Download the [high-resolution image]({{ site.url }}/2015-05-26-Trader-Joes/TJ-DCs.png).
* Download the [R source code]({{ site.url }}/2015-05-26-Trader-Joes/main.R).
