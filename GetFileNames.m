
%% Get the filenames of the mocap data

% made by Terry Taewoong Um (terry.t.um@gmail.com)
% Adaptive Systems Lab., University of Waterloo

function [AsfFilename AmcFilename] = GetFileNames(str)
    
    % Jump : trial #2 is presented in the figure of the paper    
    if strcmp(str, 'jump')         
        AsfFilename = 'MocapData\118.asf';
        AmcFilename = [];
        for ii_file=1:30
            if ii_file<10
                AmcFileName_temp = ['MocapData\118_0' int2str(ii_file) '.amc'];
            else
                AmcFileName_temp = ['MocapData\118_' int2str(ii_file) '.amc'];
            end
            AmcFilename = [AmcFilename; AmcFileName_temp];
        end
    
    % Soccer Kicking : trial #2 is presented in the figure of the paper       
    elseif strcmp(str, 'soccer')   
        AmcFilename = [];
        AsfFilename = 'MocapData\10.asf';
        AmcFilename = ['MocapData\10_01.amc'; 'MocapData\10_02.amc';'MocapData\10_03.amc'; ...
                        'MocapData\10_05.amc'; 'MocapData\10_06.amc'];
                    
    % BaseBall : trial #1 is presented in the figure of the paper                
    elseif strcmp(str, 'baseball')     
        AmcFilename = [];
        AsfFilename = 'MocapData\124.asf';
        AmcFilename = ['MocapData\124_01.amc'; 'MocapData\124_02.amc';'MocapData\124_03.amc'];
    
    % Golf : trial #1 is presented in the figure of the paper 
    elseif strcmp(str, 'golf')
        AmcFilename = [];
        AsfFilename = 'MocapData\64.asf';
        for ii_file=1:9
             AmcFileName_temp = ['MocapData\64_0' int2str(ii_file) '.amc'];
             AmcFilename = [AmcFilename; AmcFileName_temp];
        end
        AmcFilename = [AmcFilename; ['MocapData\64_10.amc']];
    
    % wash windows, paint figure eights; hand signals
    elseif strcmp(str, 'nonsporting1')  
        AmcFilename = [];
        AsfFilename = 'MocapData\15.asf';
        AmcFilename = ['MocapData\15_11.amc'];
   
    % walk, jump, etc.
    elseif strcmp(str, 'nonsporting2')
        AmcFilename = [];
        AsfFilename = 'MocapData\86.asf';
        AmcFilename = ['MocapData\86_02.amc'];
    
    else
        fprintf('Fail to load the filename');
        return;
    end
end
