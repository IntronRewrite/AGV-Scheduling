function X = NewAnswer(S1)
% Generate a new solution by swapping two random positions in the current solution
% Inputs:
% S1 - Current solution
% Outputs:
% X - New solution

N = length(S1); % Length of the current solution
X = S1; % Initialize the new solution with the current solution

% Generate two random positions to swap
a = round(rand(1, 2) * (N - 1) + 1);

% Swap the elements at the two positions
W = X(a(1));
X(a(1)) = X(a(2));
X(a(2)) = W;

end
