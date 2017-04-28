%% Public parameters
% System
SIZE_ASN = 8; SIZE_GRF = 32; % Size of ASN and GRF
RES_SPATIAL = 0.3;  % Spatial resolution of GRF, km
RES_TIME = 5; % Time resolution of dynamic, min
SPEED_ASN = 3.6; % Speed of ASN's motion, km/h
NUM_EC = 1; NUM_BS = 1; % Number of base station and energy center
locationVec = genLocationVec(SIZE_GRF); % A vecotor of coordinates
distMin = 1;

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

%% Experiements

numExp = 25;
timeMax = 100;
RMSE = zeros(timeMax, numExp);


parfor indexExp = 1:numExp
    %% Initialization
    
    % Initial states of the GRF
    % x0(:, indexExp) = mvnrnd(zeros(SIZE_GRF^2, 1), SIGMA_u)';
    x0 = mvnrnd(zeros(SIZE_GRF^2, 1), SIGMA_u)';
    % Intitial positions of the ASN
    positionVec = initPositionVec(SIZE_ASN, NUM_BS, RES_SPATIAL, locationBS, a2gParVec);
    % Initial sensing matrix
    H = genSensingMat(positionVec, SIZE_GRF, SIZE_ASN);
    
    % Predictive distribution
    MU_pre = x0;
    COV_pre = 0 + SIGMA_u;
    
    tic
    %% Iterations
    for time = 1:100
        % Connecivity matrix
        [linkCap, linkMat] = linkConnectOneHop(SIZE_ASN, NUM_BS, RES_SPATIAL, a2gParVec, positionVec, locationBS);
        % [linkCap, linkMat] = linkConnectMultiHop(SIZE_ASN, NUM_BS, RES_SPATIAL, a2gParVec, a2aParVec, positionVec, locationBS);
        
        % Dynamic
        if time == 1
            x = A*x0 + mvnrnd(zeros(SIZE_GRF^2, 1), SIGMA_u)';
            x_pre = x;
        else
            x = A*x_pre + mvnrnd(zeros(SIZE_GRF^2, 1), SIGMA_u)';
            x_pre = x;
        end
        
        % Sensing
        y = H*x + mvnrnd(zeros(SIZE_ASN, 1), SIGMA_e)';
        
        % Filtering
        MU = MU_pre + COV_pre*H'*(H*COV_pre*H' + SIGMA_e)^-1*(y - H*MU_pre);
        COV = COV_pre - COV_pre*H'*(H*COV_pre*H' + SIGMA_e)^-1*H*COV_pre;
        
        SCOV = sum(sum(COV));
        SVAR = sum(diag(COV));
        
        % Predicting
        MU_pre = A*MU;
        COV_pre = A*COV*A' + SIGMA_u;
        
        % Next position
        flagMotion = ones(5, SIZE_ASN);
        positionVecNew = positionVec;
        positionVecOld = positionVec;
        for n = 1:SIZE_ASN
            % Constraints
            flagMotion(:, n) = constraintMotion(flagMotion(:, n), positionVec(:, n), SIZE_GRF);
            flagMotion(:, n) = constraintConnecivity(n, flagMotion(:, n), positionVec, linkMat(n, :), NUM_BS, locationBS, SIZE_ASN, RES_SPATIAL, a2gParVec, a2aParVec);
            
            % Utility function
            positionVecNew(:, n) = utilityMaxMI(SIZE_GRF, flagMotion(:, n), positionVec(:, n), COV, positionVecNew(:, n));
            
            positionVec = positionVecNew;         
        end
        
        H = genSensingMat(positionVecNew, SIZE_GRF, SIZE_ASN);
        
        % RMSE
        RMSE(time, indexExp) = sqrt(mean((MU - x).^2));
    end
    
    disp(['Experiment ', num2str(indexExp), ' finished.'])
    toc
end




