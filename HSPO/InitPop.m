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

% Get the number of unloading points
xlength = size(X, 1);
% Get the number of loading points
ylength = size(Y, 1);
% Calculate the chromosome length
len = xlength + ylength + m - 1;
% Initialize the population
Chrom = zeros(pop, len);

% Generate AGV identifiers
cars = xlength + ylength + 1 : xlength + ylength + m - 1;

% Generate initial population
for i = 1:pop
    Chrom(i, :) = [Task cars];
end

end
