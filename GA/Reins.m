function Chrom = Reins(Chrom, SelCh, ObjV)
% Reinsert offspring into the new population
% Inputs:
% Chrom - Parent population
% SelCh - Offspring population
% ObjV - Fitness values of the parent population
% Outputs:
% Chrom - New population combining parents and offspring

% Get the number of individuals in the parent and offspring populations
NIND = size(Chrom, 1);
NSel = size(SelCh, 1);

% Extract the fitness values of the parent population
ObjV = ObjV(:, 1);

% Sort the parent population based on fitness values (ascending order)
[~, index] = sort(ObjV);

% Combine the top individuals from the parent population with the offspring
Chrom = [Chrom(index(1:NIND-NSel), :); SelCh];

end
