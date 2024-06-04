function overweight = overwcount(caroads, X, Y, Tlast)
% Calculate the number of overweight occurrences
% Inputs:
% caroads - AGV paths
% X - Unloading task points
% Y - Loading task points
% Tlast - AGV constraints, including weight limits
% Outputs:
% overweight - Number of overweight occurrences

% Initialize the overweight count
wrongcountw = 0;

% Get the number of AGVs
rowcar = size(caroads, 1);

% Extract container weights and weight limits
Weightx = X(:, 6); % Container weight at unloading points
Weighty = Y(:, 6); % Container weight at loading points
limit = Tlast(:, 2); % Weight limits for AGVs

% Extract task point IDs
X = X(:, 1);
Y = Y(:, 1);

% Calculate the number of overweight occurrences for each AGV path
for i = 1:rowcar
    roads = caroads{i};
    if isempty(roads) % Check if the path is empty
        continue
    end
    len = size(roads, 2); % Length of the task sequence in the path
    for j = 1:len
        % Calculate the impact of weight
        if ismember(roads(j), X) % If it is an unloading task point
            if limit(i) < Weightx(roads(j))
                wrongcountw = wrongcountw + 1;
            end
        else % If it is a loading task point
            if limit(i) < Weighty(roads(j) - length(X)) % Adjust index for loading points
                wrongcountw = wrongcountw + 1;
            end
        end
    end
end

% Return the total number of overweight occurrences
overweight = wrongcountw;

end
