function New = variation(New)
% Mutation operation
% Inputs:
% New - Current population matrix
% Outputs:
% New - Population matrix after mutation

[row, col] = size(New); % Get the dimensions of the population matrix

for i = 1:row
    % Generate two different mutation points
    c1 = unidrnd(col - 1);
    c2 = unidrnd(col - 1);
    while c1 == c2
        c1 = unidrnd(col - 1);
        c2 = unidrnd(col - 1);
    end
    
    % Swap the elements at the mutation points
    temp = New(i, c1);
    New(i, c1) = New(i, c2);
    New(i, c2) = temp;
end

end
