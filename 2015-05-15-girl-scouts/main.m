% Clear workspace

clear;

% Setup data

num_jobs = 4;
num_meals = 4;
num_girls = 9;
num_girls_per_job = 3;
num_ghosts = num_jobs*num_girls_per_job - num_girls;
num_workers = num_girls + num_ghosts;

% Setup binary variables and auxiliary variables

for(k = 1:num_meals)
    x{k} = binvar(num_workers, num_jobs);
    for(j = 1:num_jobs)
        y{k,j} = binvar(num_girls, num_girls, 'symmetric');
    end
end

% Setup constraints

con = [];

for(k = 1:num_meals)
    con = [ con ; sum(x{k} ) == 3 ];
    con = [ con ; sum(x{k}') == 1 ];
end

num_times_per_job = sdpvar(num_girls, num_jobs);

for(i = 1:num_girls)
    ntpj = zeros(1,num_jobs);
    for(k = 1:num_meals)
        ntpj = ntpj + x{k}(i,:);
    end
    con = [ con ; num_times_per_job(i,:) == ntpj ];
end

con = [ con ; num_times_per_job(:) <= 1 ];
con = [ con ; num_times_per_job(:,1) >= 1 ];

for(k = 1:num_meals)
    con = [ con ; sum(x{k}(1:num_girls, 1)) >= 2 ];
end

Y = zeros(num_girls);
for(k = 1:num_meals)
    for(j = 1:num_jobs)
        Y = Y + y{k,j};
    end
end

con = [ con ; Y(:) <= 1 ];

% Linearize quadratic terms

for(k = 1:num_meals)
    for(j = 1:num_jobs)
        for(i1 = 1:num_girls)
            con = [ con ; y{k,j}(i1,i1) == 0 ];
            for(i2 = 1:(i1-1))
                con = [ con ; y{k,j}(i1,i2) <= x{k}(i1,j) ];
                con = [ con ; y{k,j}(i1,i2) <= x{k}(i2,j) ];
                con = [ con ; y{k,j}(i1,i2) >= 0 ];
                con = [ con ; y{k,j}(i1,i2) >= x{k}(i1,j) + x{k}(i2,j) - 1 ];
            end
        end
    end
end

% Break symmetry

con = [ con ; x{1}(1:3,1) == 1 ];
con = [ con ; x{1}(4:5,2) == 1 ];
con = [ con ; x{1}(6:7,3) == 1 ];
con = [ con ; x{1}(8:9,4) == 1 ];

% Solve

solvesdp(con, sum(sum(Y)))

