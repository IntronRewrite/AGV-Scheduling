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
gg = 0.6; % Generation gap
pc = 0.6; % Crossover probability
pm = 0.6; % Mutation probability
pr = 0.6; % Reversal probability
pf = 1000000; % Full load penalty factor
pw = 10000; % Weight penalty factor
pql = 1000; % Earliest quay crane penalty factor
pqr = 10000; % Latest quay crane penalty factor
py = 1000; % Yard crane penalty factor
maxgen = 200; % Number of iterations
num_experiments = 200; % Number of experiments

total_points_unsatisfied = zeros(num_experiments, 7); % Store the number of unsatisfied task points in each experiment
total_times = zeros(num_experiments, 1); % Store the total time in each experiment

for exp_index = 1:num_experiments
    %% Genetic Algorithm
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
    
    gen = 1; % Current iteration number
    
    while gen <= maxgen
        %% Calculate fitness
        FitnV = Fitness(Chrom, Pos, Xmat, Ymat, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
        
        %% Selection
        SelCh = Select(Chrom, FitnV, gg);
        
        %% Crossover operation
        SelCh = Recombin(SelCh, pc);
        
        %% Mutation
        SelCh = Mutate(SelCh, pm);
        
        %% Reversal operation
        SelCh1 = Reverse(SelCh, pr);
        
        %% Select the best replacements
        FitS1 = Fitness(SelCh1, Pos, Xmat, Ymat, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
        FitS = Fitness(SelCh, Pos, Xmat, Ymat, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
        FitS1 = FitS1(:, 1);
        FitS = FitS(:, 1);
        index = FitS1 < FitS;
        SelCh(index, :) = SelCh1(index, :);
        
        %% Reinsert offspring into the new population
        Chrom = Reins(Chrom, SelCh, FitnV);
        
        %% Update iteration number
        gen = gen + 1;
    end
    
    %% Count the number of unsatisfied task points
    [~, index] = min(FitnV(:, 1)); % Find the index of the chromosome with the minimum fitness value
    total_points_unsatisfied(exp_index, :) = FitnV(index, 1:7); % Store the number of unsatisfied task points
    
    %% Calculate and store total time
    caroads = Outputroads(Chrom(index, :), Xmat, Ymat, Map, Tlast);
    [time, ~, ~, ~, ~, ~] = costime(caroads, Xmat, Ymat, Map, Tlast, Pos, tload, v, pql, pqr, py);
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
