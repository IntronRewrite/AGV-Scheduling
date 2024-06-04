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
pf = 1000000; % Full load penalty factor
pw = 10000; % Weight penalty factor
pql = 1000; % Earliest quay crane penalty factor
pqr = 10000; % Latest quay crane penalty factor
py = 1000; % Yard crane penalty factor
maxgen = 200; % Number of iterations

%% HSPO Initialization
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

% Initialize optimization variables
[value, index] = min(FitnV(:, 1));
CurrentBest = Chrom; % Current individual best
GlobalBest = Chrom(index, :); % Global best
recordCB = inf * ones(1, pop); % Record of individual bests
recordGB = value; % Record of global best
New = Chrom;

%% Optimization
gen = 1; % Current iteration number
figure;
hold on;
box on;
xlim([0, maxgen]);
title('Optimization Process');
xlabel('Iterations');
ylabel('Current Best Value');
Path_HSPO = zeros(maxgen, 1);

while gen <= maxgen
    %% Calculate fitness
    FitnV = Fitness(Chrom, Pos, X, Y, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
    Path_HSPO(gen) = min(FitnV(:, 1));
    
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
    NewFit = Fitness(New, Pos, X, Y, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
    
    for i = 1:pop
        if FitnV(i, 1) > NewFit(i, 1)
            Chrom(i, :) = New(i, :);
        end
    end
    
    % Perform global crossover
    New = CrossG(New, GlobalBest);
    NewFit = Fitness(New, Pos, X, Y, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
    
    for i = 1:pop
        if FitnV(i, 1) > NewFit(i, 1)
            Chrom(i, :) = New(i, :);
        end
    end
    
    % Perform mutation
    New = variation(New);
    NewFit = Fitness(Chrom, Pos, X, Y, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
    
    for i = 1:pop
        if FitnV(i, 1) > NewFit(i, 1)
            Chrom(i, :) = New(i, :);
        end
    end
    
    %% Update iteration number
    gen = gen + 1;
end

%% Output results
plot(Path_HSPO);
[~, index] = min(FitnV(:, 1));
disp(['Optimized population fitness: ', num2str(FitnV(1, 1))]);
disp(['Unsatisfied yard crane latest time points: ', num2str(FitnV(1, 2)), ', Unsatisfied quay crane latest time points: ', num2str(FitnV(1, 3))]);
disp(['Unsatisfied yard crane earliest time points: ', num2str(FitnV(1, 4)), ', Unsatisfied quay crane earliest time points: ', num2str(FitnV(1, 5))]);
disp(['Unsatisfied full load points: ', num2str(FitnV(1, 6)), ', Unsatisfied weight limit points: ', num2str(FitnV(1, 7))]);

caroads = Outputroads(Chrom(index, :), X, Y, Map, Tlast);
[time, ~, ~] = costime(caroads, X, Y, Map, Tlast, Pos, tload, v, pql, pqr, py);
disp(['Total time: ', num2str(time)]);
toc;
