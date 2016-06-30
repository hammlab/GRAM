%/*      
%          File:    GRAM_DirectRegistrationForComparison
%          Date:    $Date: $
%          Version: $Revision: $
%          Author:  $Author: $
%          ID:      $Id: $
%      
%          File Description
%           function [dMSE,dHE] =GRAM_DirectRegistrationForComparison
%           (dirSubject,dirResult,gmean,Directiter,Directsmoothing)
%           Direct Demon Registration for comparison purpose
%           dirSubject: Folder with subject files. Assume subject file is nifti file format (.nii)  
%           dirResult: The folder where the result will be saved
%           gmean: geodesic mean template. See GRAM_GeodesicPath
%           Directiter: iteration paramter for demons registration (default: 15x10x5)
%           Directsmoothing: regularization parameter for registration (default: 1.5)
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

function [dMSE,dHE] = GRAM_DirectRegistrationForComparison(dirSubject,dirResult,gmean,Directiter,Directsmoothing)

%% Initialization
f = dir([dirSubject,'/*.nii']);
if (isempty(f))
    error('No Nifti file (.nii)');
end
N = length(f);

if ~exist(dirResult,'dir')
    mkdir(dirResult);
end

if nargin < 4
    Directiter = '10x10x10';
end

if nargin <5
    Directsmoothing = '1.5';
end

Template = gmean;

dMSE = zeros(N,1);
dHE = zeros(N,1);

Fix = f(Template).name(1:end-4);
FixedImage = [dirSubject,'/',f(Template).name];

dirWarpedDirect = [dirResult,'/Warped'];
if ~exist(dirWarpedDirect,'dir')
    mkdir(dirWarpedDirect);
end

dirJacobianDirect = [dirResult,'/Jacobian'];
if ~exist(dirJacobianDirect,'dir')
    mkdir(dirJacobianDirect);
end

dirField = [dirResult,'/Field/'];
if ~exist(dirField,'dir')
    mkdir(dirField);
end

%% Direct Registration
if ~exist([dirResult,'/dMSE.mat'],'file') || ~exist([dirResult,'/dHE.mat'],'file') 
    for s = 1:N
        if s~=Template                
            Mov = f(s).name(1:end-4);
            MovingImage = [dirSubject,'/',f(s).name];
            WarpedImage = [dirWarpedDirect,'/',Mov,'To',Fix,'.nii'];            
            FixToMov = [dirField,'/',Fix,'to',Mov,'-def.nii'];
                        
            cmd = ['DemonsRegistration_dong_n -f ',FixedImage,' -m ',MovingImage,' -o ',WarpedImage,' -O ',FixToMov,' -i ',Directiter,' -s ',Directsmoothing,' -d'];
            [~,result] = dos(cmd);
            idx = strfind(result,' ');
            dMSE(s,1) = str2double(result(1:idx(1)-1));
            dHE(s,1) = str2double(result(idx(1)+1:idx(2)-1));        
        end

    end
   save([dirResult,'/dMSE'],'dMSE');
   save([dirResult,'/dHE'],'dHE');
   movefile([dirWarpedDirect,'/*jac.nii'],dirJacobianDirect);
else
   load([dirResult,'/dMSE']);
   load([dirResult,'/dHE']);
end



