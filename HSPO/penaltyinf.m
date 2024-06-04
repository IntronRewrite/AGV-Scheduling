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
pop = 100; % Initial population size
gg = 0.9; % Generation gap
pc = 0.9; % Crossover probability
pm = 0.9; % Mutation probability
pr = 0.9; % Reversal probability
pf = 1000000; % Full load penalty factor
pw = 10000; % Weight penalty factor
pql = 1000; % Earliest quay crane penalty factor
pqr = 10000; % Latest quay crane penalty factor
py = 1000; % Yard crane penalty factor
maxgen = 200; % Number of iterations
num_experiments = 5; % Number of experiments

total_points_unsatisfied = zeros(num_experiments, 7); % Store the number of unsatisfied task points in each experiment
total_times = zeros(num_experiments, 1); % Store the total time in each experiment

for exp_index = 1:num_experiments
    %% HSPO
    % Encode mapping
    Map = [X; Y];
    Xmat = X;
    Ymat = Y;
    Xmat(:, 1) = 1:size(Xmat, 1);
    Ymat(:, 1) = 1 + size(Xmat, 1):size(Xmat, 1) + size(Ymat, 1);
    
    % Construct initial solution
    Chrom = InitPop(Xmat, Ymat, m, pop);
    
    % Calculate fitness
    FitnV = Fitness(Chrom, Pos, Xmat, Ymat, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
    
    % Initialize optimization variables
    [value, index] = min(FitnV(:, 1));
    CurrentBest = Chrom; % Current individual best
    GlobalBest = Chrom(index, :); % Global best
    recordCB = inf * ones(1, pop); % Record of individual bests
    recordGB = value; % Record of global best
    New = Chrom;
    gen = 1; % Current iteration number
    
    while gen <= maxgen
        %% Calculate fitness
        FitnV = Fitness(Chrom, Pos, Xmat, Ymat, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
        Path(gen) = min(FitnV(:, 1));
        
        for i = 1:pop
            if FitnV(i, 1) < recordCB(i)
                recordCB(i) = FitnV(i, 1);
                CurrentBest(i, :) = Chrom(i, :);
            end
            if FitnV(i, 1) < recordGB
                recordGB = FitnV(i, 1);
                GlobalBest = Chrom(i, :);
            end
        end
        
        % Perform individual crossover
        New = Cross(New, CurrentBest);
        NewFit = Fitness(New, Pos, Xmat, Ymat, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
        
        for i = 1:pop
            if FitnV(i, 1) > NewFit(i, 1)
                Chrom(i, :) = New(i, :);
            end
        end
        
        % Perform global crossover
        New = CrossG(New, GlobalBest);
        NewFit = Fitness(New, Pos, Xmat, Ymat, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
        
        for i = 1:pop
            if FitnV(i, 1) > NewFit(i, 1)
                Chrom(i, :) = New(i, :);
            end
        end
        
        % Perform mutation
        New = variation(New);
        NewFit = Fitness(Chrom, Pos, Xmat, Ymat, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
        
        for i = 1:pop
            if FitnV(i, 1) > NewFit(i, 1)
                Chrom(i, :) = New(i, :);
            end
        end
        
        %% Update iteration number
        gen = gen + 1;
    end
    
    %% Count the number of unsatisfied task points
    [~, index] = min(FitnV(:, 1)); % Find the index of the chromosome with the minimum fitness value
    total_points_unsatisfied(exp_index, :) = FitnV(index, 1:7); % Store the number of unsatisfied task points
    
    %% Calculate and store total time
    caroads = Outputroads(Chrom(index, :), Xmat, Ymat, Map, Tlast);
    [time, ~, ~] = costime(caroads, Xmat, Ymat, Map, Tlast, Pos, tload, v, pql, pqr, py);
    total_times(exp_index) = time;
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

toc;
