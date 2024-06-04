function [runtime, wrongtime, wrongcountyl, wrongcountyr, wrongcountql, wrongcountqr] = costime(caroads, X, Y, Map, Tlast, Pos, tload, v, pql, pqr, py)
% Calculate the total running time of the AGVs for each path
% Inputs:
% caroads - AGV paths
% X - Unloading task points
% Y - Loading task points
% Map - Mapping function
% Tlast - Latest return time
% Pos - Distance matrix
% tload - Loading time
% v - AGV travel speed
% pql - Penalty factor for earliest crane
% pqr - Penalty factor for latest crane
% py - Penalty factor for yard crane
% Outputs:
% runtime - Total running time of the AGVs
% wrongtime - Penalty time for violating time windows
% wrongcountyl - Count of violations of yard crane left time window
% wrongcountyr - Count of violations of yard crane right time window
% wrongcountql - Count of violations of quay crane left time window
% wrongcountqr - Count of violations of quay crane right time window

% Initialize penalty times and counts
wrongtime = 0;
wrongcountyl = 0;
wrongcountyr = 0;
wrongcountql = 0;
wrongcountqr = 0;
runtime = 0;

% Get the number of AGVs
rowcar = size(caroads, 1);

% Extract time window information
Tlqx = X(:, 2); % Earliest time for unloading task at quay crane
Trqx = X(:, 3); % Latest time for unloading task at quay crane
Tlyx = X(:, 4); % Earliest time for unloading task at yard crane
Tryx = X(:, 5); % Latest time for unloading task at yard crane
Tlyy = Y(:, 2); % Earliest time for loading task at yard crane
Tryy = Y(:, 3); % Latest time for loading task at yard crane
Tlqy = Y(:, 4); % Earliest time for loading task at quay crane
Trqy = Y(:, 5); % Latest time for loading task at quay crane

% Extract mapping points
Map = Map(:, 1);
X = X(:, 1);
Y = Y(:, 1);

% Calculate the total running time and penalties for each AGV path
for i = 1:rowcar
    roads = caroads{i};
    if isempty(roads) % Check if the path is empty
        continue
    end
    len = size(roads, 2); % Length of the task sequence in the path
    time = 0; % Initialize running time for this path

    for j = 1:len
        if j == 1 % If it is the first task point
            if ismember(roads(j), X) % If it is an unloading task point
                time = Tlqx(roads(j)); % Start time is the earliest time for the first unloading task
                tlyx = Tlyx(X == roads(j)); % Left time window for arriving at the yard crane
                trun = distance(Pos, 1, Map(roads(j))) / v; % Travel time from quay crane to yard crane
                
                if time + trun < tlyx % If arrival time is earlier than the left time window
                    wrongtime = wrongtime + (tlyx - time - trun) * py;
                    wrongcountyl = wrongcountyl + 1;
                    time = tlyx; % Wait until the left time window
                else
                    time = time + trun; % Calculate arrival time
                    tryx = Tryx(X == roads(j)); % Right time window for arriving at the yard crane
                    if time > tryx % If arrival time is later than the right time window
                        wrongtime = wrongtime + (time - tryx) * py;
                        wrongcountyr = wrongcountyr + 1;
                    end
                end
            else % If it is a loading task point
                trun = distance(Pos, 1, Map(roads(j))) / v; % Travel time from quay crane to yard crane
                time = trun;
                tlyy = Tlyy(Y == roads(j)); % Left time window for arriving at the yard crane
                tryy = Tryy(Y == roads(j)); % Right time window for arriving at the yard crane
                if time < tlyy % If arrival time is earlier than the left time window
                    wrongtime = wrongtime + (tlyy - time) * py;
                    wrongcountyl = wrongcountyl + 1;
                    time = tlyy; % Wait until the left time window
                else
                    if time > tryy % If arrival time is later than the right time window
                        wrongtime = wrongtime + (time - tryy) * py;
                        wrongcountyr = wrongcountyr + 1;
                    end
                end
                time = time + tload + trun; % Loading time and travel back to quay crane
                tlqy = Tlqy(Y == roads(j)); % Left time window for arriving at the quay crane
                trqy = Trqy(Y == roads(j)); % Right time window for arriving at the quay crane
                if time < tlqy % If arrival time is earlier than the left time window
                    wrongtime = wrongtime + (tlqy - time) * pql;
                    wrongcountql = wrongcountql + 1;
                    time = tlqy; % Wait until the left time window
                else
                    if time > trqy % If arrival time is later than the right time window
                        wrongtime = wrongtime + pqr;
                        wrongcountqr = wrongcountqr + 1;
                    end
                end
            end
        else % If it is not the first task point
            if ismember(roads(j), X) % If it is an unloading task point
                if ismember(roads(j - 1), X) % If the previous task point is also an unloading task point
                    time = time + distance(Pos, Map(roads(j - 1)), 1) / v; % Return to quay crane
                end
                % If the previous task point is a loading task point, no need to return to quay crane
                tlqx = Tlqx(X == roads(j)); % Left time window for arriving at the quay crane
                trqx = Trqx(X == roads(j)); % Right time window for arriving at the quay crane
                tlyx = Tlyx(X == roads(j)); % Left time window for arriving at the yard crane
                tryx = Tryx(X == roads(j)); % Right time window for arriving at the yard crane
                if time < tlqx 
                    wrongtime = wrongtime + (tlqx - time) * pql;
                    wrongcountql = wrongcountql + 1;
                    time = tlqx; % Wait until the left time window
                else
                    if time > trqx % If arrival time is later than the right time window
                        wrongtime = wrongtime + pqr;
                        wrongcountqr = wrongcountqr + 1;
                    end
                end
                time = time + tload; % Load the container from the ship
                time = time + distance(Pos, Map(roads(j)), 1) / v; % Travel time to the yard crane
                if time < tlyx % If arrival time is earlier than the left time window
                    wrongtime = wrongtime + (tlyx - time) * py;
                    wrongcountyl = wrongcountyl + 1;
                    time = tlyx;
                else   
                    if time > tryx % If arrival time is later than the right time window
                        wrongtime = wrongtime + (time - tryx) * py;
                        wrongcountyr = wrongcountyr + 1;
                    end
                end
            else % If it is a loading task point
                if ismember(roads(j - 1), X) % If the previous task point is an unloading task point
                    time = time + distance(Pos, Map(roads(j - 1)), Map(roads(j))) / v; % Move from the previous yard to the current yard
                else % If the previous task point is a loading task point
                    time = time + distance(Pos, 1, Map(roads(j))) / v; % Move from quay crane to the current yard
                end 
                tlqy = Tlqy(Y == roads(j)); % Left time window for arriving at the quay crane
                trqy = Trqy(Y == roads(j)); % Right time window for arriving at the quay crane
                tlyy = Tlyy(Y == roads(j)); % Left time window for arriving at the yard crane
                tryy = Tryy(Y == roads(j)); % Right time window for arriving at the yard crane
                if time < tlyy % If arrival time is earlier than the left time window
                    wrongtime = wrongtime + (tlyy - time) * py;
                    wrongcountyl = wrongcountyl + 1;
                    time = tlyy;
                else
                    if time > tryy % If arrival time is later than the right time window
                        wrongtime = wrongtime + (time - tryy) * py;
                        wrongcountyr = wrongcountyr + 1;
                    end
                end
                time = tload + time; % Load the container at the yard crane
                time = time + distance(Pos, Map(roads(j)), 1) / v; % Travel time to quay crane
                if time < tlqy % If arrival time is earlier than the left time window
                    wrongtime = wrongtime + (tlqy - time) * pql;
                    wrongcountql = wrongcountql + 1;
                    time = tlqy;
                else
                    if time > trqy % If arrival time is later than the right time window
                        wrongtime = wrongtime + pqr;
                        wrongcountqr = wrongcountqr + 1;
                    end
                end
            end
        end
    end
    % Final return task point check
    if ismember(roads(end), X)
        time = time + distance(Pos, 1, Map(roads(end))) / v;
    end
    if time > Tlast(i)
        wrongcountqr = wrongcountqr + 1;
        wrongtime = wrongtime + pqr;
    end
    runtime = max(runtime, time);
end
end
