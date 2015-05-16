---
layout: default-post
title: On Assignment with the Girl Scouts
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

On Assignment with the Girl Scouts
==================================

![Girl Scouts logo]({{ site.url }}/2015-05-15-girl-scouts/girl-scouts.gif)

My wife and daughter are at Girl Scout camp for one night this weekend.
There are a total of 9 girls together for 4 meals, and each meal has 4
jobs (cooking, table setup, dish washing, and table takedown). In order
to be fair and balanced, my wife wanted to schedule the girls so that
every girl does each job once and no two girls work together more than
once (plus a few miscellaneous constraints). Is this possible?

It seemed like it might be easy. We weren't sure, so we tried on paper
for a little while. Then I decided it would just be easier---at least
for me---to write an integer programming model. My model involved
introducing 3 "ghost girls" (appropriate for camp) to give a total of 12
girls, and then it assigned girls to the 4 jobs in groups of 3 for all 4
meals. The tough part was introducing nonconvex, quadratic constraints
to enforce the requirement that no two girls work together more than
once---and then linearizing those constraints. Breaking symmetry was
important, too. The final model solved in a few seconds.

It turns out it is possible:

![Girl Scouts logo]({{ site.url }}/2015-05-15-girl-scouts/answer.png)

I deserve a free box of cookies, right?

* Download the [Matlab/YALMIP source code]({{ site.url }}/2015-05-15-girl-scouts/main.m).
