---
layout: default-post
title: Update&#58; On Assignment with the Girl Scouts
tags:
- integer programming
- optimization
- YALMIP
- Matlab
- Gurobi
- Mosek
- CPLEX
- assignment
- fun
---

Update: On Assignment with the Girl Scouts
==========================================

![Girl Scouts logo]({{ site.url }}/2015-05-15-girl-scouts/girl-scouts.gif)

In a [previous post]({% post_url 2015-05-15-girl-scouts %}), I discussed
an assignment problem inspired by the Girls Scouts. From the modeling
point of view, it was a little tricky because I needed to linearize some
quadratic constraints over binary variables. From the software point of
view, I used [YALMIP](http://users.isy.liu.se/johanl/yalmip/)---which
always makes my optimization life easier.

Recently, Johan L&ouml;fberg, the developer of YALMIP, emailed a few
ways to improve my use of YALMIP. In particular, he suggested the use of
multidimensional arrays for storing my YALMIP variables---something I
didn't know you could do but is extremely helpful in this case. He also
mentioned YALMIP's `binmodel` command, which automatically linearizes
nonlinear constraints over binary variables. What an excellent,
time-saving command!

One other side advantage: the model setup time decreased from
1.1 seconds to 0.2 seconds, and the solver time decreased
from 0.4 seconds down to (essentially) 0.0 seconds.

Johan definitely deserves two free boxes of cookies!

* Download the updated [Matlab/YALMIP source code]({{ site.url }}/2015-05-15-girl-scouts/main_loefberg.m).
