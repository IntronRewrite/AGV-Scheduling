function [S, R] = Metropolis(FS, FS1, S, S1, T)
% Metropolis criterion for simulated annealing
% Inputs:
% FS - Fitness of the current solution
% FS1 - Fitness of the perturbed new solution
% S - Current solution
% S1 - New solution
% T - Current temperature
% Outputs:
% S - Next current solution
% R - Fitness of the next current solution

% Calculate the change in fitness
dC = FS(1) - FS1(1);

% Apply the Metropolis criterion
if dC < 0
    R = FS; % Retain the current solution
elseif exp(-dC / T) >= rand
    R = FS; % Accept the new solution probabilistically
else
    S = S1; % Update to the new solution
    R = FS1; % Update the fitness to the new solution's fitness
end

end
