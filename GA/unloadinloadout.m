function unlilo = unloadinloadout(caroads, X, Y)
% Calculate the number of violations of "unload before load" constraints
% Inputs:
% caroads - AGV paths
% X - Unloading task points
% Y - Loading task points
% Outputs:
% unlilo - Number of violations

% Extract the task point IDs
X = X(:, 1);
Y = Y(:, 1);

% Initialize the count of violations
unlilo = 0;

% Get the number of AGVs
car = size(caroads, 1);

% Check each AGV's path for violations
for i = 1:car
    roads = caroads{i};
    if isempty(roads) % Skip if the path is empty
        continue
    end
    % Identify the locations of unloading and loading points in the path
    locx = ismember(roads, X);
    locy = ismember(roads, Y);
    len = size(roads, 2);
    
    % Check for violations in the path
    for j = 1:len
        if mod(j, 2) == 1 && locy(j) % Odd-indexed positions should not be loading points
            unlilo = unlilo + 1;
        elseif mod(j, 2) == 0 && locx(j) % Even-indexed positions should not be unloading points
            unlilo = unlilo + 1;
        end
    end
    
    % Check if the length of the path is odd
    if mod(len, 2) == 1
        unlilo = unlilo + 1;
    end
end

end
