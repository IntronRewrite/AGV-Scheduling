function dis = distance(Pos, a, b)
% Distance function
% Inputs:
% Pos - Position matrix
% a, b - Task points
% Outputs:
% dis - Distance between task points a and b

% Calculate the Manhattan distance between points a and b
dis = abs(Pos(a, 1) - Pos(b, 1)) + abs(Pos(a, 2) - Pos(b, 2));

end
