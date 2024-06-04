function Chrom = InitPop(X, Y, m, pop)
% Initialize the population based on left time windows
% Inputs:
% X - Unloading area
% Y - Loading area
% m - Number of AGVs (Automated Guided Vehicles)
% pop - Population size
% Outputs:
% Chrom - Initial population solutions

% Combine task points and sort by the left time window
Task = [X; Y];
Task = sortrows(Task, 2);
Task = Task(:, 1)';

% Get the number of unloading and loading points
xlength = size(X, 1); % Number of unloading points
ylength = size(Y, 1); % Number of loading points
len = xlength + ylength + m - 1; % Length of chromosome

% Initialize the population
Chrom = zeros(pop, len);

% Generate AGV identifiers
cars = xlength + ylength + 1 : xlength + ylength + m - 1;

% Generate initial population
for i = 1:pop
    Chrom(i, :) = [Task, cars]; % Combine task points and AGV identifiers
end

end
