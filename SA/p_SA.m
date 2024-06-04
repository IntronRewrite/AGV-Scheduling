clear;
clc;
close all;
tic;

%% Initialize parameters
load Pos; % Position matrix
load X; % Unloading task points and time windows
load Y; % Loading task points and time windows
load Tlast; % AGV return time

m = size(Tlast, 1); % Number of AGVs
tload = 120; % Loading time for AGV
v = 6; % AGV speed
pop = 1; % Initial population size for simulated annealing
pf = 1000000; % Full load penalty factor
pw = 10000; % Weight penalty factor
pql = 1000; % Earliest quay crane penalty factor
pqr = 10000; % Latest quay crane penalty factor
py = 1000; % Yard crane penalty factor
maxgen = 200; % Number of iterations
t0 = 2000; % Initial temperature
tend = 1e-3; % End temperature
loop = 200; % Number of iterations per temperature (chain length)
tv = 0.9; % Cooling rate
num_experiments = 200; % Number of experiments
Path_SA = inf(400, 1); % Store the best path
total_points_unsatisfied = zeros(num_experiments, 7); % Store the number of unsatisfied task points in each experiment
total_times = zeros(num_experiments, 1); % Store the total time in each experiment

for exp_index = 1:num_experiments
    %% Simulated Annealing
    % Encode mapping
    Map = [X; Y];
    Xmat = X;
    Ymat = Y;
    Xmat(:, 1) = 1:size(Xmat, 1);
    Ymat(:, 1) = 1 + size(Xmat, 1):size(Xmat, 1) + size(Ymat, 1);
    
    % Construct initial solution
    S1 = InitPop(X, Y, m, pop);
    [cow, rol] = size(S1);
    
    % Calculate fitness
    FitnV = Fitness(S1, Pos, Xmat, Ymat, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
    
    % Calculate number of iterations
    syms x;
    time = ceil(double(solve(t0 * (tv)^x == tend, x)));
    count = 0; % Iteration count
    Ans = zeros(time, 1); % Initialize objective matrix
    Track = zeros(time, rol); % Initialize the best route matrix for each generation
    bestans = ones(1, 7); % Retain the best fitness values
    
    %% Optimization
    while t0 > tend
        count = count + 1;
        temp = zeros(loop, rol + 1);
        RR = zeros(loop, 7);
        
        for k = 1:loop
            %% Generate new solution
            S = NewAnswer(S1);
            
            %% Use Metropolis criterion to determine if the new solution is accepted
            FitS1 = Fitness(S1, Pos, Xmat, Ymat, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
            FitS = Fitness(S, Pos, Xmat, Ymat, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
            [S1, R] = Metropolis(FitS, FitS1, S, S1, t0);
            RR(k, :) = R;
            temp(k, :) = [S1 R(1)]; % Record the next route and its distance
        end
        
        [d0, index] = min(temp(:, end)); % The best route at the current temperature
        
        if count == 1 || d0 < Ans(count - 1)
            Ans(count) = d0;
            bestans = RR(index, :);
        else
            Ans(count) = Ans(count - 1);
        end
        
        Track(count, :) = temp(index, 1:end-1); % Record the best route at the current temperature
        t0 = tv * t0; % Cooling
    end
    
    %% Update the best fitness and path
    if min(Ans) < min(Path_SA)
        Path_SA = Ans;
    end
    
    %% Count the number of unsatisfied task points
    [~, index] = min(Ans(:, 1)); % Find the index of the chromosome with the minimum fitness value
    total_points_unsatisfied(exp_index, :) = bestans(1:7); % Store the number of unsatisfied task points
    
    %% Calculate and store total time
    caroads = Outputroads(Track(index, :), Xmat, Ymat, Map, Tlast);
    [time, ~, ~] = costime(caroads, Xmat, Ymat, Map, Tlast, Pos, tload, v, pql, pqr, py);
    total_times(exp_index) = time;
    
    % Clear temporary variables
    Ans = [];
    bestans = [];
    Track = [];
end

%% Calculate averages
average_unsatisfied_points = mean(total_points_unsatisfied);
average_total_time = mean(total_times);

disp(['Average total time: ', num2str(average_total_time)]);
disp(['Average optimized population fitness: ', num2str(average_unsatisfied_points(1))]);
disp(['Average number of tasks not satisfying full load constraint: ', num2str(average_unsatisfied_points(6))]);
disp(['Average number of tasks not satisfying weight constraint: ', num2str(average_unsatisfied_points(7))]);
disp(['Average number of tasks not satisfying earliest quay crane time: ', num2str(average_unsatisfied_points(5))]);
disp(['Average number of tasks not satisfying latest quay crane time: ', num2str(average_unsatisfied_points(3))]);
disp(['Average number of tasks not satisfying earliest yard crane time: ', num2str(average_unsatisfied_points(4))]);
disp(['Average number of tasks not satisfying latest yard crane time: ', num2str(average_unsatisfied_points(2))]);

save('Path_SA.mat', 'Path_SA');
toc;
