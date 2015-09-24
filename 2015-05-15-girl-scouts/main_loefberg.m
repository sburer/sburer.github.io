% Clear workspace

clear;

% Setup data

num_jobs = 4;
num_meals = 4;
num_girls = 9;
num_girls_per_job = 3;
num_ghosts = num_jobs*num_girls_per_job - num_girls;
num_workers = num_girls + num_ghosts;

% Setup binary variables

x = binvar(num_workers, num_jobs, num_meals, 'full');

% Initialize constraints

con = [];

%
% Setup constraints
%

% Each job at each meal has exactly 3 girls assigned.
% Each girl at each meal has exactly 1 job.
% Each girl does each job at most once.

con = [ con ; sum(x,1) == num_girls_per_job ];
con = [ con ; sum(x,2) == 1 ];
con = [ con ; sum(x,3) <= 1 ];

% Each (real, non-ghost) girl gets to do job #1 (cooking, the fun job).

con = [ con ; sum(x(1:num_girls,1,:),3) >= 1 ];

% Job #1 (cooking) always has at least 2 (real, non-ghost) girls
% assigned to it

con = [ con ; sum(x(1:num_girls,1,:),1) >= 2 ];

% Ensure every pair of (real, non-ghost) girls works together at most
% once. This is quadratic!

for(i1 = 1:num_girls)
    for(i2 = 1:(i1-1))
        con = [ con ; sum(sum( x(i1,:,:) .* x(i2,:,:) )) <= 1 ];
    end
end

% Linearize quadratic terms

con = binmodel(con);

% Break symmetry (indices are hard-coded)

con = [ con ; x(1:3,1,1) == 1 ];
con = [ con ; x(4:5,2,1) == 1 ];
con = [ con ; x(6:7,3,1) == 1 ];
con = [ con ; x(8:9,4,1) == 1 ];

% Solve

optimize(con)

% Display solution

double(x)
