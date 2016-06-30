%/*      
%          File:    GRAM_PairwiseDistance.m
%          Date:    $Date: $
%          Version: $Revision: $
%          Author:  $Author: $
%          ID:      $Id: $
%      
%          File Description
%             function [pdist,pMSE,pHE] = GRAM_PairwiseDistance(dirSubject,w,dirResult)
%             Calculate Pairwise Distance between subjects
%             dirSubject: Folder with subject files. Assume subject file is nifti file format (.nii)  
%             w: weight between MSE and HE
%             dirResult: Folder where MSE and HE will be saved
%          
%      
%          Copyright (c)
%          
%          Contact : sbia-software@uphs.upenn.edu
%
%          This software is distributed WITHOUT ANY WARRANTY; without even
%          the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
%          PURPOSE.  See the above copyright notices for more information.
%*/
function [pdist,pMSE,pHE] = GRAM_PairwiseDistance(dirBin,dirSubject,w,dirResult,Piter,Psmoothing)

% Find the list of subject file
f = dir([dirSubject '/*.nii']);
if (isempty(f))
    error('No Nifti file (.nii)');
end
N = length(f);

% Initialization
% pMSE: pairwise MSE
% pHE: pairwise HE
pMSE = zeros(N,N);
pHE = zeros(N,N);

%% Perform N(N-1)/2 times Pairwise Registration
% If precomputed MSE and HE exists in result folder (dirResult), reuse
if ~exist([dirResult,'/pMSE.mat'],'file') || ~exist([dirResult,'/pHE.mat'],'file')
    for i = 1:N
        for j = i+1:N                                        
            fixed = [dirSubject '/' f(j).name];
            moving = [dirSubject '/' f(i).name];            
            % Check Dong's  Version
            %command = [dirBin,'/DemonsRegistration_dong -f ',fixed,' -m ',moving,' -o output.mha -d -e -s 1'];
            cmd = [dirBin,'/DemonsRegistration_dong -f ',fixed,' -m ',moving,' -i ',Piter,' -s ',Psmoothing',' -e -d 1'];            
            %cmd = [dirBin,'/DemonsRegistration_dong -f ',FixedImage,' -m ',MovingImage,' -O ',FixToMov,' -i ',NNiter,' -s ',NNsmoothing,' -e'];
            [~,result] = dos(cmd);
            idx = strfind(result,' ');
            pMSE(i,j) = str2double(result(1:idx(1)-1));
            pHE(i,j) = str2double(result(idx(1)+1:idx(2)-1));  
        end
    end
    
    %Symmetrize
    pMSE = max(pMSE,pMSE');
    pHE = max(pHE,pHE');

    %Normalize
    pMSE = pMSE./norm(pMSE,'fro');
    pHE = pHE./norm(pHE,'fro');
    
    save([dirResult,'/pMSE'],'pMSE');
    save([dirResult,'/pHE'],'pHE');
else
    load([dirResult,'/pMSE.mat']);
    load([dirResult,'/pHE.mat']);
    
    if (sum(double(isnan(pMSE(:)))) ~=0 || sum(double(isnan(pHE(:)))) ~=0)
        delete([dirResult,'/pMSE.mat']);
        delete([dirResult,'/pHE.mat']);
        error('Check your binary path. This will remove pMSE and pHE. Retry');        
    end
end

%% Pairwise Distance: weighted sume of normalized MSE and HE
pdist = w * pMSE + (1-w) * pHE;

%% ETC-Delete temporary files
if exist('output.mha','file')
    delete('output.mha');
end

if exist('output-jac.nii','file')
    delete('output-jac.nii');
end
