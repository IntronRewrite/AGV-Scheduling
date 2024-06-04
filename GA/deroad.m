function caroads = deroad(Chrom, lengthx, lengthy, rowcar)
% Decompose chromosome into individual AGV paths
% Inputs:
% Chrom - Chromosome
% lengthx - Number of unloading areas
% lengthy - Number of loading areas
% rowcar - Number of AGVs
% Outputs:
% caroads - AGV paths

% Find the positions of the AGVs in the chromosome
carindex = find(Chrom > lengthx + lengthy);
% Initialize the AGV paths
caroads = cell(rowcar, 1);

% Decompose each AGV's path
for j = 1:rowcar
    if j == 1
        thefirst = 1;
        thelast = carindex(j) - 1;
    elseif j == rowcar
        thefirst = carindex(j - 1) + 1;
        thelast = lengthx + lengthy + rowcar - 1;
    else
        thefirst = carindex(j - 1) + 1;
        thelast = carindex(j) - 1;
    end
    
    if thefirst <= thelast
        caroads{j} = Chrom(thefirst:thelast);
    end
end

end
