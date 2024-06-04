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

%% Genetic Algorithm
% Encode mapping
Map = [X; Y];
X(:, 1) = 1:size(X, 1);
Y(:, 1) = 1 + size(X, 1):size(X, 1) + size(Y, 1);

% Construct initial solution
Chrom = InitPop(X, Y, m, pop);

% Calculate fitness
FitnV = Fitness(Chrom, Pos, X, Y, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
disp(['Initial population fitness: ', num2str(FitnV(1, 1))]);
disp(['Unsatisfied yard crane latest time points: ', num2str(FitnV(1, 2)), ', Unsatisfied quay crane latest time points: ', num2str(FitnV(1, 3))]);
disp(['Unsatisfied yard crane earliest time points: ', num2str(FitnV(1, 4)), ', Unsatisfied quay crane earliest time points: ', num2str(FitnV(1, 5))]);
disp(['Unsatisfied full load points: ', num2str(FitnV(1, 6)), ', Unsatisfied weight limit points: ', num2str(FitnV(1, 7))]);

%% Optimization process
gen = 1; % Current iteration number
figure;
hold on;
box on;
xlim([0, maxgen]);
title('Optimization Process');
xlabel('Iterations');
ylabel('Current Best Value');
Path_GA = zeros(maxgen, 1);

while gen <= maxgen
    %% Calculate fitness
    FitnV = Fitness(Chrom, Pos, X, Y, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
    Path_GA(gen) = min(FitnV(:, 1)); % Save the best individual
    
    %% Selection
    SelCh = Select(Chrom, FitnV, gg);
    
    %% Crossover operation
    SelCh = Recombin(SelCh, pc);
    
    %% Mutation
    SelCh = Mutate(SelCh, pm);
    
    %% Reversal operation
    SelCh1 = Reverse(SelCh, pr);
    
    %% Select the best replacements
    FitS1 = Fitness(SelCh1, Pos, X, Y, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
    FitS = Fitness(SelCh, Pos, X, Y, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
    FitS1 = FitS1(:, 1);
    FitS = FitS(:, 1);
    index = FitS1 < FitS;
    SelCh(index, :) = SelCh1(index, :);
    
    %% Reinsert offspring into the new population
    Chrom = Reins(Chrom, SelCh, FitnV);
    
    %% Update iteration number
    gen = gen + 1;
end

%% Output results
plot(Path_GA);
[~, index] = min(FitnV(:, 1));
disp(['Optimized population fitness: ', num2str(FitnV(index, 1))]);
disp(['Unsatisfied yard crane latest time points: ', num2str(FitnV(index, 2)), ', Unsatisfied quay crane latest time points: ', num2str(FitnV(index, 3))]);
disp(['Unsatisfied yard crane earliest time points: ', num2str(FitnV(index, 4)), ', Unsatisfied quay crane earliest time points: ', num2str(FitnV(index, 5))]);
disp(['Unsatisfied full load points: ', num2str(FitnV(index, 6)), ', Unsatisfied weight limit points: ', num2str(FitnV(index, 7))]);

caroads = Outputroads(Chrom(index, :), X, Y, Map, Tlast);
[time, ~, ~, ~, ~, ~] = costime(caroads, X, Y, Map, Tlast, Pos, tload, v, pql, pqr, py);
disp(['Total time: ', num2str(time)]);
toc;
