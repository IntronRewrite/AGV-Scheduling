function SelCh1 = Reverse(SelCh, pr)
% Reverse mutation function
% Inputs:
% SelCh - Selected individuals
% pr - Probability of reversal
% Outputs:
% SelCh1 - Individuals after evolutionary reversal

% Get the number of rows and columns in SelCh
[row, col] = size(SelCh);
% Initialize the output as a copy of the input
SelCh1 = SelCh;

for i = 1:row
    % Decide whether to perform reversal based on probability
    if rand() < pr
        % Randomly select two positions
        r1 = randsrc(1, 1, [1:col]);
        r2 = randsrc(1, 1, [1:col]);
        
        % Ensure r1 is less than or equal to r2
        mininverse = min([r1, r2]);
        maxinverse = max([r1, r2]);
        
        % Reverse the segment between the selected positions
        SelCh1(i, mininverse:maxinverse) = SelCh1(i, maxinverse:-1:mininverse);
    end
end

end
