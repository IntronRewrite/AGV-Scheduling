function caroads = Outputroads(Chrom, X, Y, Map, Tlast)
% Output the paths for AGVs
% Inputs:
% Chrom - Individual chromosome
% X - Unloading task points
% Y - Loading task points
% Map - Mapping matrix
% Tlast - Latest arrival time for AGVs
% Outputs:
% caroads - AGV paths

% Get the number of unloading points
lengthx = size(X, 1);
% Get the number of loading points
lengthy = size(Y, 1);
% Get the number of AGVs
cars = size(Tlast, 1);

% Extract unloading and loading task points
X = X(:, 1);
Y = Y(:, 1);
Map = Map(:, 1);

% Decode the chromosome to obtain each AGV path
caroads = deroad(Chrom, lengthx, lengthy, cars);

% Output the paths for each AGV
for i = 1:cars
    if isempty(caroads{i})
        disp(['AGV ', num2str(i), ' did not transport any containers'])
        continue
    end
    
    path = ['AGV ', num2str(i), ' path: 1'];
    roads = caroads{i};
    len = size(roads, 2);
    
    for j = 1:len
        if j ~= 1 && (ismember(roads(j), X) || (ismember(roads(j), Y) && ismember(roads(j-1), Y)))
            path = [path, '->1->', num2str(Map(roads(j)))];
        else
            path = [path, '->', num2str(Map(roads(j)))];
        end
    end
    
    path = [path, '->1'];
    disp(path)
end
end
