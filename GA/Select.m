% Selection operation
% Inputs:
% Chrom - Population
% FitnV - Fitness values
% GGAP - Selection probability (generation gap)
% Outputs:
% SelCh - Selected individuals

% Convert fitness values to selection probabilities
FitnV = FitnV(:, 1);
FitnV = 1 ./ FitnV;

% Get the number of individuals in the population
NIND = size(Chrom, 1);

% Calculate the number of individuals to select
NSel = max(floor(NIND * GGAP + 0.5), 2);

% Perform stochastic universal sampling (SUS) to select individuals
ChrIx = Sus(FitnV, NSel);

% Extract the selected individuals from the population
SelCh = Chrom(ChrIx, :);

end

% Stochastic Universal Sampling (SUS) function
% Inputs:
% FitnV - Fitness values (inverted)
% NSel - Number of individuals to select
% Outputs:
% ChrIx - Indices of selected individuals
function ChrIx = Sus(FitnV, NSel)
% Calculate the cumulative sum of the fitness values
cumFitnV = cumsum(FitnV);
% Generate equally spaced points
step = cumFitnV(end) / NSel;
start = rand * step;
points = start:step:(start + step * (NSel - 1));
% Select individuals based on the points
ChrIx = arrayfun(@(x) find(cumFitnV >= x, 1), points);

end
