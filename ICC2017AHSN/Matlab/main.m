% A simulation script for ASN path palnning in GRF with connectivity and
% energy constraints.

%% Parameters
% System
SIZE_ASN = 9; SIZE_GRF = 32; % Size of ASN and GRF
RES_SPATIAL = 0.3;  % Spatial resolution of GRF, km
RES_TIME = 5; % Time resolution of dynamic, min
SPEED_ASN = 3.6; % Speed of ASN's motion, km/h
NUM_EC = 1; NUM_BS = 1; % Number of base station and energy center
locationVec = genLocationVec(SIZE_GRF); % A vecotor of coordinates

% Dynamic
% x(k+1) = A*x(k) + u(k);
% y(k) = H*x(k) + e(k);
A = 0.9*eye(SIZE_GRF^2, SIZE_GRF^2);
hypSpatialCov = [.1, .1*10^2];
noiseSensor = 0.1;
SIGMA_u = genSpatialCovMat(locationVec, locationVec, hypSpatialCov);
SIGMA_e = noiseSensor*eye(SIZE_ASN, SIZE_ASN);

% Communication
locationBS = genLocationBS(NUM_BS, SIZE_GRF);
% A2G links, a radius~=6 circle center at the location of BS
a2gB = 10 * 10^6; % Bandwidth, in Hz
a2gPtx = 23; % in dBm
a2gGrx = 11.5; % in dBi
a2gPi = 8; % in dB
a2gPn = -115; % in dBm
a2gLf = 10; % in dB
a2gParVec = [a2gB, a2gPtx, a2gGrx, a2gPi, a2gPn, a2gLf];
% A2A links:
a2aB = 10 * 10^6; % Bandwidth, in Hz
a2aPtx = 23; % in dBm
a2aGrx = 0; % in dBi
a2aPi = 8; % in dB
a2aPn = -115; % in dBm
a2aLf = 10; % in dB
a2aParVec = [a2aB, a2aPtx, a2aGrx, a2aPi, a2aPn, a2aLf];

%% Initialization
% Initial states of the GRF
x0 = mvnrnd(zeros(SIZE_GRF^2, 1), SIGMA_u)';
% Intitial positions of the ASN
positionVec = initPositionVec(SIZE_ASN, NUM_BS, RES_SPATIAL, locationBS, a2gParVec);
% positionVec = [12 13 13 16 16 19 19 20; 16 13 19 12 20 13 19 16];

% Initial sensing matrix
H = genSensingMat(positionVec, SIZE_GRF, SIZE_ASN);

% Visualization
figure;
X = reshape(x0, SIZE_GRF, SIZE_GRF);
field = imagesc(1:SIZE_GRF, 1:SIZE_GRF, X, [-1 1]);
field.CData = X;
ax = gca;
ax.XAxisLocation = 'top';
colorbar;
hold on
for n = 1:SIZE_ASN
    plot(positionVec(2, n), positionVec(1, n), 'or', 'MarkerSize', 10, ...
        'LineWidth', 2);
end
for n = 1:NUM_BS
    plot(locationBS(2, n), locationBS(1, n), '^k', 'MarkerSize', 15, ...
        'LineWidth', 2);
end
hold off

% % Initial states as the previous states
% x_pre = x0;
% Using the known initial states to compose the predictive distribution
MU_pre = x0;
COV_pre = 0 + SIGMA_u;

% Time End
timeEnd = 50;

% Pre-allocation
x = zeros(SIZE_GRF^2, timeEnd);
prex = zeros(SIZE_GRF^2, 20);
y = zeros(SIZE_ASN, timeEnd);
MU = zeros(SIZE_GRF^2, timeEnd);
RMSE = zeros(1, timeEnd);

for pretime = 1:5
    if pretime == 1
        prex(:, pretime) = A*x0 + mvnrnd(zeros(SIZE_GRF^2, 1), SIGMA_u)';
    else
        prex(:, pretime) = A*prex(:, pretime-1) + mvnrnd(zeros(SIZE_GRF^2, 1), SIGMA_u)';
    end
    
end

x0 = prex(:, 20);


%% Iterations begin
for time = 1:timeEnd
    % ASN connections: one-hop or multi-hop
    % [linkCap, linkMat] = linkConnectOneHop(SIZE_ASN, NUM_BS, RES_SPATIAL, a2gParVec, positionVec, locationBS);
    % [linkCap, linkMat] = linkConnectMultiHop(SIZE_ASN, NUM_BS, RES_SPATIAL, a2gParVec, a2aParVec, positionVec, locationBS);
    
    % Dynamic
    if time == 1
        x(:, time) = A*x0 + mvnrnd(zeros(SIZE_GRF^2, 1), SIGMA_u)';
    else
        x(:, time) = A*x(:, time-1) + mvnrnd(zeros(SIZE_GRF^2, 1), SIGMA_u)';
    end
    
    % Sensing
    y(:, time) = H*x(:, time) + mvnrnd(zeros(SIZE_ASN, 1), SIGMA_e)';
    
    % Filtering
    MU(:, time) = MU_pre + COV_pre*H'*(H*COV_pre*H' + SIGMA_e)^-1*(y(:, time) - H*MU_pre);
    COV = COV_pre - COV_pre*H'*(H*COV_pre*H' + SIGMA_e)^-1*H*COV_pre;
    
    % Predicting
    MU_pre = A*MU(:, time);
    COV_pre = A*COV*A' + SIGMA_u;
    
    % Motion constraint
    flagMotion = ones(5, SIZE_ASN);
    positionVecOld = positionVec;
    positionVecNew = positionVec;
    indexes = [];
    for n = 1:SIZE_ASN
        %% Constraints
        flagMotion = constraintMotion(n, flagMotion, positionVec, SIZE_GRF);
        % flagMotion(:, n) = constraintConnecivity(n, flagMotion(:, n), positionVec, linkMat(n, :), NUM_BS, locationBS, SIZE_ASN, RES_SPATIAL, a2gParVec, a2aParVec);
        
        %% Utility function
        % positionVecNew = utilityMaxMInew(n, flagMotion, positionVec, positionVecNew, locationVec, SIZE_GRF, hypSpatialCov);
        % positionVecNew(:, n) = utilityMaxEntropy(SIZE_GRF, flagMotion(:, n), positionVec(:, n), COV, positionVecNew(:, n));
        
        [ positionVecNew, indexes, flagMotion ] = utilityMaxInfoGain(n, SIZE_GRF, indexes, flagMotion, positionVecNew, COV);
        
        positionVec = positionVecNew;        
    end
    
    % Update sensing matrix
    H = genSensingMat(positionVecNew, SIZE_GRF, SIZE_ASN);
    
    % Visualization
    X = reshape(x(:, time), SIZE_GRF, SIZE_GRF);
    
    set(field, 'CData', X);
    drawnow;
    
    hold on
    for n = 1:SIZE_ASN
        plot([positionVecOld(2, n) positionVecNew(2, n)], ...
            [positionVecOld(1, n) positionVecNew(1, n)], 'r-', ...
            'LineWidth', 2);
    end
    hold off
    
    % RMSE
    RMSE(time) = sqrt(mean((MU(:, time) - x(:, time)).^2));
    
end

%% Finally
% Visualization
hold on
for n = 1:SIZE_ASN
    plot(positionVec(2, n), positionVec(1, n), 'dk', 'MarkerSize', 10, ...
        'LineWidth', 2);
    %     if sum(linkMat(n, SIZE_ASN+1:end)) > 0
    %         connectToBSid = find(linkMat(n, SIZE_ASN+1:end));
    %         plot([positionVec(2, n) locationBS(2, connectToBSid)], ...
    %             [positionVec(1, n) locationBS(1, connectToBSid)], 'k-', ...
    %             'LineWidth', 2);
    %     else
    %         connectToRelayid = find(linkMat(n, 1:SIZE_ASN));
    %         plot([positionVec(2, n) positionVec(2, connectToRelayid)], ...
    %             [positionVec(1, n) positionVec(1, connectToRelayid)], 'k--', ...
    %             'LineWidth', 2);
    %     end
end
voronoi(positionVec(2, :), positionVec(1, :));
hold off

aveRMSE = mean(RMSE);
disp(['Average RMSE = ', num2str(aveRMSE)]);