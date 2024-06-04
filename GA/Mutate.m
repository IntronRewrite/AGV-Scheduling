function SelCh = Mutate(SelCh, Pm)
% Mutation operation
% Inputs:
% SelCh - Selected individuals for mutation
% Pm - Mutation probability
% Outputs:
% SelCh - Mutated individuals

% Get the number of selected individuals and their length
[NSel, L] = size(SelCh);

% Perform mutation for each individual
for i = 1:NSel
    % Check if mutation should be applied
    if Pm >= rand
        % Generate a random permutation of indices
        R = randperm(L);
        % Swap two randomly chosen genes
        SelCh(i, R(1:2)) = SelCh(i, R(2:-1:1));
    end
end
end
