function NewChrIx = Sus(FitnV, Nsel)
% Stochastic Universal Sampling (SUS) function
% Inputs:
% FitnV - Fitness values of individuals
% Nsel - Number of individuals to select
% Outputs:
% NewChrIx - Indices of selected individuals

% Identify the population size (Nind)
[Nind, ~] = size(FitnV);

% Perform stochastic universal sampling
cumfit = cumsum(FitnV); % Cumulative fitness values
trials = cumfit(Nind) / Nsel * (rand + (0:Nsel-1)'); % Generate equally spaced points

% Replicate the cumulative fitness values and trials for comparison
Mf = cumfit(:, ones(1, Nsel));
Mt = trials(:, ones(1, Nind))';

% Find the indices of the selected individuals
[NewChrIx, ~] = find(Mt < Mf & [zeros(1, Nsel); Mf(1:Nind-1, :)] <= Mt);

% Shuffle the new population
[~, shuf] = sort(rand(Nsel, 1));
NewChrIx = NewChrIx(shuf);

end
