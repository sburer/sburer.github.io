---
layout: default-post
title: Daily Temperature Swings in the United States
---

Daily Temperature Swings in the United States
=============================================

People seem to dislike when the weather changes abruptly, as if it's a
cruel joke played by Mother Nature, and I get the impression that
everyone thinks there own weather is more unpredictable than others'.
Nate Silver and Reuben Fischer-Baum of [fivethirtyeight.com](http://fivethirtyeight.com) 
recently analyzed temperature, precipitation, and severe weather
data from [Weather Underground](http://weatherunderground.com)
to determine [which city has the most unpredictable weather](
http://fivethirtyeight.com/features/which-city-has-the-most-unpredictable-weather/
) in the United States. They concluded that the Great Plains and the
Upper Midwest have the most unpredictable weather, while Florida,
the west coast, and Hawaii are at the other end of the spectrum.

I wanted to reproduce their basic analysis but with a simpler approach
and easier-to-obtain data set, and I also wanted to complete the full
analysis in R.

First off, I collected data from the [Average Daily Temperature
Archive]( http://academic.udayton.edu/kissock/http/Weather/) at the
[University of Dayton](https://www.udayton.edu). For over 150 locations
in the United States, including Hawaii, Alaska, and Puerto Rico, the
data set gives the average daily temperature at each location
for every day since January 1, 1995. For simplicity, I call this
measurement just the *temperature*.

To measure the weather changes on a day-by-day basis, I calculate at
each location the *average daily temperature swing*. For example, if
the temperature in Des Moines is 67 on Monday and 72 on Tuesday, then
the daily temperature change is 5. If the temperature then drops to 50
on Wednesday, the second daily temperature change is 22. (Note that
I measure the change in positive values even if the temperature goes
down.) For those two days, the average daily temperature swing is (5 +
22)/2 = 13.5. For every location, the average is calculated for all days
in the data set, roughly 7,300 days for each location.

The figure below shows the average daily temperature swings across the
United States. Greater swings are indicated by bigger plot points and
with more intense reds, while smaller swings are small and green.
Hawaii was calculated but couldn't be shown well in this figure;
it is tiny and green.

![Average Daily Temperature Swings]({{ site.url }}/2015-05-10-temperature-swings/temperature-swings-web.png)

Overall, I reach the same conclusion as Silver and Fischer-Baum: if you
like predictable weather, then head towards Florida, the west coast,
Hawaii, and Puerto Rico. On the other hand, if you desire excitement in
your life, then the Great Plains and Upper Midwest are where you should
be.

* Download the [high-resolution image]({{ site.url }}/2015-05-10-temperature-swings/temperature-swings.png).
* Download the [R source code]({{ site.url }}/2015-05-10-temperature-swings/main.R).

<!-- Start of StatCounter Code for Default Guide -->
<script type="text/javascript">
var sc_project=9547853; 
var sc_invisible=1; 
var sc_security="c1c61c74"; 
var scJsHost = (("https:" == document.location.protocol) ?
"https://secure." : "http://www.");
document.write("<sc"+"ript type='text/javascript' src='" +
scJsHost+
"statcounter.com/counter/counter.js'></"+"script>");
</script>
<noscript><div class="statcounter"><a title="web analytics"
href="http://statcounter.com/" target="_blank"><img
class="statcounter"
src="http://c.statcounter.com/9547853/0/c1c61c74/1/"
alt="web analytics"></a></div></noscript>
<!-- End of StatCounter Code for Default Guide -->
