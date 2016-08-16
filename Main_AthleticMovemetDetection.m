
%% Athletic movement detection algorithm

% made by Terry Taewoong Um (terry.t.um@gmail.com, http://terryum.io)
% Adaptive Systems Lab, University of Waterloo

% Please cite the below paper if you reuse the codes for your research

% "An unsupervised approach to detecting and isolating athletic movements",
% Terry T. Um and Dana Kuli?,In 38th Annual International Conference of the 
% IEEE Engineering in Medicine and Biology Society (EMBC), 2016.

close all;  clearvars; 

%% Directions

% 0. Download Terry's Lie group library from the below and set their path  
% (Home - Set path - Add with subfolders - choose the downloaded folders)
% https://github.com/terryum/Human-Robot-Motion-Simulator-based-on-Lie-Group

% 1. Chooses one of exercises you want to analyse among the belows
% 'jump' 'soccer' 'baseball' 'golf' 'nonsporting1' 'nonsporting2'
% (Note that you can experiment with more mocapdata from http://mocap.cs.cmu.edu/)
myExerciseName = 'baseball';

% 2. Set the mixture ratio for pre-stretch & stretch measures
% (Please refer to the eq. (13) from the paper. It will blend as
%  myMeasure =(pre-strectch)^(beta)*(stretch)^(1-beta) )
beta = 0.5;

% 3. Set the half window size (15 -> 0.125s half window size)
nLocalCheck = 15;

% 4. Set the threshold from [0,1]
Threshold = 0.5;

% 5. Run all


%% Main Code

[AsfFilename, AmcFilename] = GetFileNames(myExerciseName); 

nFiles = size(AmcFilename,1);   % The number of files (movements)
nData = zeros(nFiles,1);        % will contain the length of each motion

% mdl_subject{kk,1} : cell{root, torso, rightArm, leftArm, rlightLeg, leftLeg}
mdl_subject = cell(nFiles,1);       nBody = 6;
myManiRatio = cell(nFiles,1);       
maxID = zeros(nFiles, nBody);   minID = zeros(nFiles, nBody);

Conv = cell(nFiles,6);              
Conv_MagDelta = cell(nFiles,6);     Conv_MagDelta = cell(nFiles,6);

for ii_file = 1:nFiles 
    % Load a human model and motions from asf and amc files, repectively
    mdl_subject{ii_file,1} = LoadFromAsf(AsfFilename);       
    [mdl_subject{ii_file,1} nData(ii_file,1)] = LoadFromAmc(AmcFilename(ii_file,:), mdl_subject{ii_file,1});

    % Calculate manipulability for detecting pre-stretch poses
    [myManiRatio{ii_file,1} maxID(ii_file,:) minID(ii_file,:)]= GetManipulability(mdl_subject{ii_file,1});
    
    % Calculate kinematic synergys by using BCH formula
    mdl_subject{ii_file,1} = GetLieParameters(mdl_subject{ii_file,1});
    for kk=3:nBody
        [Conv_MagDelta{ii_file,kk}] = LieConvolution(mdl_subject{ii_file,1}{kk,1}, [1 nData(ii_file,1)-2]);    
    end
    
    eigRatio = zeros(nData(ii_file,1),nBody);
    distRatio = zeros(nData(ii_file,1),nBody);

    
    % We will set the arm's endpoint as wrist and leg's as ankle.
    % In other words, we will calculate the kinematic synergy at the writs and ankles
    
    % Submanifold detection from the kinematic synergy for capturing coherency
    
    myTitle = cell(4,1);
    myTitle{1,1} = 'Right Arm';
    myTitle{2,1} = 'Left Arm';
    myTitle{3,1} = 'Right Leg';
    myTitle{4,1} = 'Left Leg';
    for kk=3:nBody
        if kk==3|4
            targetConv = 3;     % Wrist
        else
            targetConv = 2;     % Ankle
        end

        % Calculating the maximum range of points for scaling
        [eigVal eigVec] = MyPCA(Conv_MagDelta{ii_file,kk}(:,:,targetConv),3);
        dataOnPC = Conv_MagDelta{ii_file,kk}(:,:,targetConv)*eigVec(:,1);
        maxDist = max(dataOnPC)-min(dataOnPC);
        
        % Applying PCA for windowed data for measuring coherency of stretch motions
        nIdx_PlotStart = nLocalCheck+1;
        nIdx_PlotEnd = nData(ii_file,1)-nLocalCheck-2;
        nLocalCheck_Half = round(nLocalCheck/2);
        for ii=nIdx_PlotStart:nIdx_PlotEnd
            [eigVal eigVec] = MyPCA(Conv_MagDelta{ii_file,kk}(ii-nLocalCheck:ii+nLocalCheck,:,targetConv),3);
            eigRatio(ii,kk) = (eigVal(1,1)+eigVal(2,1))/(eigVal(1,1)+eigVal(2,1)+eigVal(3,1));
            dataOnPC_Part = Conv_MagDelta{ii_file,kk}(ii-nLocalCheck:ii+nLocalCheck,:,targetConv)*eigVec(:,1);
            maxDist_Part = max(dataOnPC_Part)-min(dataOnPC_Part);
            distRatio(ii,kk) = maxDist_Part/maxDist;
            myLieMetric(ii,kk) = eigRatio(ii,kk)*distRatio(ii,kk);
        end    
        nLocalCheck_Half = round(nLocalCheck/2);
        
        % Blend the measures for pre-stretch & stretch with beta          
        for ii=nIdx_PlotStart:nIdx_PlotEnd-nLocalCheck
            myFinalMetric(ii+nLocalCheck,kk) = (myManiRatio{ii_file,1}(ii,kk))^(beta)*(myLieMetric(ii+nLocalCheck,kk))^(1-beta);
        end
        
        max_myFinalMetric(ii_file,kk) = max(myFinalMetric(:,kk));
        
        % Plot the measures (fig1: rightArm, fig2: leftArm, fig3: rightLeg, fig4: leftLeg)
        figure(); 
        f1 = plot(nIdx_PlotStart:nIdx_PlotEnd,myManiRatio{ii_file,1}(nIdx_PlotStart:nIdx_PlotEnd,kk), 'c'); hold on;
        f2 = plot(nIdx_PlotStart:nIdx_PlotEnd, myLieMetric(nIdx_PlotStart:nIdx_PlotEnd,kk), 'b'); hold on;
        f3 = plot(nIdx_PlotStart:nIdx_PlotEnd, myFinalMetric(nIdx_PlotStart:nIdx_PlotEnd,kk), 'r', 'LineWidth', 2); hold on;
        f4 = plot(0:nData(ii_file,1), ones(1,nData(ii_file,1)+1)*Threshold, 'k--'); hold off;
        axis([0 nData(ii_file,1) 0 1]);
        legend([f1,f2,f3,f4], 'pre-stretch', 'stretch', 'blended', 'threshold');
        title(myTitle{kk-2});
    end
    
%   Display the motion capture data using plot3
    bShowFrame = 0;     % 1:Show the frames  0: Do not show them
    bEETraj = [0 0 0 0 0 0];      % 1: Show the end-effector trajectories  0 : Do not show them 
%   bEETraj: [1_root, 2_torso, 3_rightArm, 4_leftArm, 5_rightLeg, 6_leftLeg]
    axisRange = FindAxisRange(mdl_subject{ii_file,1});             % Find appropriate axes for plotting motion                 
    DisplayModel(mdl_subject{ii_file,1}, axisRange, bShowFrame, bEETraj);   % Display the motion
end


