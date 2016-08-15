%% Calculate manipulability for detecting pre-stretch poses 

% made by Terry Taewoong Um (terry.t.um@gmail.com)
% Adaptive Systems Lab., University of Waterloo

function [myManiRatio maxID minID] = GetManipulability(myModel)
    
    nData = size(myModel{1,1}.T_Moving_Local, 4);
    nBody = size(myModel,1);
    myManipulability = zeros(nData,3,nBody);
    nTemp = 1;
    maxID = zeros(1,nBody);     minID = zeros(1,nBody);

    % Calculate manipulability for the all limbs (not for the torso)
    for kk=2:nBody
        Jacobian = zeros(6, myModel{kk,1}.nLink);
        for ii=1:nData
            for jj=2:myModel{kk,1}.nLink
                Jacobian(1:3,jj) = log_SO3(myModel{kk,1}.T_Moving_Abs(1:3,1:3,jj,ii));
                Jacobian(4:6,jj) = cross(myModel{kk,1}.T_Moving_Abs(1:3,4,jj,ii),Jacobian(1:3,jj));               
            end

            [U S V] = svd(Jacobian(4:6,:));
            
            % Among the various definitions of manipulability, 
            % we use myManipulability(ii,2,kk)
            
            if kk == 5 | 6
                [U S V] = svd(Jacobian(4:6,1:3));
                sigma = sort([S(1,1) S(2,2)]);
                myManipulability(ii,1,kk) = sigma(1);
                myManipulability(ii,2,kk) = sigma(1)/sigma(2); 
                myManipulability(ii,3,kk) = sigma(1)*sigma(2);
            else
                [U S V] = svd(Jacobian(4:6,:));
                sigma = sort([S(1,1) S(2,2) S(3,3)]);
                myManipulability(ii,1,kk) = sigma(1);
                myManipulability(ii,2,kk) = sigma(1)/sigma(3); 
                myManipulability(ii,3,kk) = sigma(1)*sigma(2)*sigma(3);
            end
        end
    end
    
    % Report maximum and minimum manipulability values
    for kk=2:nBody
        [maxVal maxID(1,kk)] = max(myManipulability(:,2,kk));
        [minVal minID(1,kk)] = min(myManipulability(:,2,kk));
    end
    myManiRatio = squeeze(myManipulability(:,2,:));
  
end