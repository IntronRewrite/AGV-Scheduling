function New = CrossG(New, Cur)
% Global crossover operation
% Inputs:
% New - New individual values
% Cur - Current best values
% Outputs:
% New - Individual values after crossover

% Get the size of the New matrix
[cow, rol] = size(New);

% Perform global crossover for each individual
for i = 1:cow
    % Generate two different crossover points
    c1 = unidrnd(rol - 1);
    c2 = unidrnd(rol - 1);
    while c1 == c2
        c1 = unidrnd(rol - 1);
        c2 = unidrnd(rol - 1);
    end
    
    % Determine the start and end points for crossover
    st = min(c1, c2);
    ed = max(c1, c2);
    
    % Extract the crossover segment from the current best values
    cros = Cur(st:ed);
    
    % Remove the crossover segment from the new individual and append the segment
    temp = setdiff(New(i, :), cros, 'stable');
    temp = [temp, cros];
    
    % Update the new individual with the crossover result
    New(i, :) = temp;               
end
end
