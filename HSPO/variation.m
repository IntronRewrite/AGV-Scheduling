function New = variation(New)
% Mutation operation
% Inputs:
% New - New individual values
% Outputs:
% New - Individual values after mutation

% Get the size of the New matrix
[row, col] = size(New);

% Perform mutation for each individual
for i = 1:row
    % Generate two different mutation points
    c1 = unidrnd(col - 1);
    c2 = unidrnd(col - 1);
    while c1 == c2
        c1 = unidrnd(col - 1);
        c2 = unidrnd(col - 1);
    end
    
    % Swap the values at the mutation points
    temp = New(i, c1);
    New(i, c1) = New(i, c2);
    New(i, c2) = temp;
end

end
