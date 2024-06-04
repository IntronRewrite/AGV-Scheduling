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
tv = 0.95; % Cooling rate

%% Simulated Annealing
% Encode mapping
Map = [X; Y];
X(:, 1) = 1:size(X, 1);
Y(:, 1) = 1 + size(X, 1):size(X, 1) + size(Y, 1);

% Construct initial solution
S1 = InitPop(X, Y, m, pop);
[cow, rol] = size(S1);

% Calculate fitness
FitnV = Fitness(S1, Pos, X, Y, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
disp(['Initial population fitness: ', num2str(FitnV(1, 1))]);
disp(['Unsatisfied yard crane latest time points: ', num2str(FitnV(1, 2)), ', Unsatisfied quay crane latest time points: ', num2str(FitnV(1, 3))]);
disp(['Unsatisfied yard crane earliest time points: ', num2str(FitnV(1, 4)), ', Unsatisfied quay crane earliest time points: ', num2str(FitnV(1, 5))]);
disp(['Unsatisfied full load points: ', num2str(FitnV(1, 6)), ', Unsatisfied weight limit points: ', num2str(FitnV(1, 7))]);

% Calculate number of iterations
syms x;
time = ceil(double(solve(t0 * (tv)^x == tend, x)));
count = 0; % Iteration count
Path_SA = zeros(time, 1); % Initialize objective matrix
Track = zeros(time, rol); % Initialize the best route matrix for each generation
bestans = ones(1, 7); % Retain the best fitness values

%% Optimization
figure;
hold on;
box on;
xlim([0, maxgen]);
title('Optimization Process');
xlabel('Iterations');
ylabel('Current Best Value');

while t0 > tend
    count = count + 1;
    temp = zeros(loop, rol + 1);
    RR = zeros(loop, 7);
    
    for k = 1:loop
        %% Generate new solution
        S = NewAnswer(S1);
        
        %% Use Metropolis criterion to determine if the new solution is accepted
        FitS1 = Fitness(S1, Pos, X, Y, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
        FitS = Fitness(S, Pos, X, Y, Map, Tlast, pf, pw, pql, pqr, py, tload, v);
        [S1, R] = Metropolis(FitS, FitS1, S, S1, t0);
        RR(k, :) = R;
        temp(k, :) = [S1 R(1)]; % Record the next route and its distance
    end
    
    [d0, index] = min(temp(:, end)); % The best route at the current temperature
    
    if count == 1 || d0 < Path_SA(count - 1)
        Path_SA(count) = d0;
        bestans = RR(index, :);
    else
        Path_SA(count) = Path_SA(count - 1);
    end
    
    Track(count, :) = temp(index, 1:end-1); % Record the best route at the current temperature
    t0 = tv * t0; % Cooling
end

%% Output results
plot(Path_SA);
[~, index] = min(Path_SA(:, 1));
disp('Optimized population fitness and details:');
disp(['Best fitness value: ', num2str(bestans(1))]);
disp(['Unsatisfied yard crane latest time points: ', num2str(bestans(2)), ' Unsatisfied quay crane latest time points: ', num2str(bestans(3))]);
disp(['Unsatisfied yard crane earliest time points: ', num2str(bestans(4)), ' Unsatisfied quay crane earliest time points: ', num2str(bestans(5))]);
disp(['Unsatisfied full load points: ', num2str(bestans(6)), ' Unsatisfied weight limit points: ', num2str(bestans(7))]);

caroads = Outputroads(Track(index, :), X, Y, Map, Tlast);
[time, ~, ~] = costime(caroads, X, Y, Map, Tlast, Pos, tload, v, pql, pqr, py);
disp(['Total time: ', num2str(time)]);
toc;
