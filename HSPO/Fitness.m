function Fit = Fitness(Chrom, Pos, X, Y, Map, Tlast, pf, pw, pql, pqr, py, tload, v)
% Calculate the fitness of the population using penalty functions
% Inputs:
% Chrom - Population (chromosomes)
% Pos - Coordinate points
% X - Unloading area and time window
% Y - Loading area and time window
% Map - Mapping function
% Tlast - Latest time for AGVs
% pf - Penalty factor for "unload before load" constraint
% pw - Penalty factor for overweight
% pql - Penalty factor for earliest quay crane time window
% pqr - Penalty factor for latest quay crane time window
% py - Penalty factor for yard crane time window
% tload - Loading time
% v - AGV travel speed
% Outputs:
% Fit - Fitness values of the population

% Get the number of AGVs
rowcar = size(Tlast, 1);
% Get the number of chromosomes
rowchrom = size(Chrom, 1);
% Get the number of unloading points
lengthx = size(X, 1);
% Get the number of loading points
lengthy = size(Y, 1);

% Initialize fitness values
Fit = zeros(rowchrom, 7);

for i = 1:rowchrom
    % Decode the chromosome to obtain each AGV path
    caroads = deroad(Chrom(i, :), lengthx, lengthy, rowcar);
    
    % Calculate individual vehicle runtime, time window penalties,
    % the number of violations for quay crane and yard crane time windows
    [runtime, wrongtime, wrongcountyl, wrongcountyr, wrongcountql, wrongcountqr] = costime(caroads, X, Y, Map, Tlast, Pos, tload, v, pql, pqr, py);
    
    % Calculate the number of violations for "unload before load"
    unlilo = unloadinloadout(caroads, X, Y);
    
    % Calculate the overweight count
    overweight = overwcount(caroads, X, Y, Tlast);
    
    % Calculate the fitness value considering penalties
    Fit(i, 1) = runtime + wrongtime + unlilo * pf + overweight * pw;
    Fit(i, 2) = wrongcountyr;
    Fit(i, 3) = wrongcountqr;
    Fit(i, 4) = wrongcountyl;
    Fit(i, 5) = wrongcountql;
    Fit(i, 6) = unlilo;
    Fit(i, 7) = overweight;
end

end
