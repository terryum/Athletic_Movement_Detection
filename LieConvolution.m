
%% Convolution (Applying BCH formula) for SO3 values

% made by Terry Taewoong Um (terry.t.um@gmail.com)
% Adaptive Systems Lab., University of Waterloo

function [Conv_MagDelta] = LieConvolution(model, IdxTrain)

%     [nJoint ig nTraining nFiles] = size(input_LieVec);
%     LieParam3 = zeros(nTraining,3); 
    [nJoint nDim3 nData] = size(model.LieVec);
    nTrain = IdxTrain(1,2)-IdxTrain(1,1)+1;
    nConv = 0;
    for ii=1:nJoint-1
        nConv = nConv+ii;
    end
    
    % Convolution with (LieVec(i)*delta_theta(i))
    Conv_MagDelta = zeros(nTrain, 3, nConv);
    ii_Conv = 1;
    for kk=1:nJoint-1
        MagDelta2 = (model.LieMag(:,IdxTrain(1,1)+1:IdxTrain(1,2)+1)-model.LieMag(:,IdxTrain(1,1):IdxTrain(1,2)));
        LieParam1_MagDelta2 = (squeeze(model.LieVec(1,:,IdxTrain(1,1):IdxTrain(1,2))).*(ones(3,1)*MagDelta2(1,:)))';         
         for mm = kk:nJoint-1
            LieParam2_MagDelta2 = (squeeze(model.LieVec(mm+1,:,IdxTrain(1,1):IdxTrain(1,2))).*(ones(3,1)*MagDelta2(mm+1,:)))';
            for ii=1:nTrain
                LieParam3_MagDelta2(ii,:) = LieParam1_MagDelta2(ii,:)+LieParam2_MagDelta2(ii,:) + 0.5*cross(LieParam1_MagDelta2(ii,:),LieParam2_MagDelta2(ii,:)) + ...
                    1/12*(cross(LieParam1_MagDelta2(ii,:),cross(LieParam1_MagDelta2(ii,:),LieParam2_MagDelta2(ii,:)))+cross(LieParam2_MagDelta2(ii,:),cross(LieParam2_MagDelta2(ii,:),LieParam1_MagDelta2(ii,:))));
            end
            LieParam1_MagDelta2 = LieParam3_MagDelta2;
            Conv_MagDelta(:,:,ii_Conv) = LieParam3_MagDelta2;
            ii_Conv = ii_Conv+1;
         end
    end
       
end
