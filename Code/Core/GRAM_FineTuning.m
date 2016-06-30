%/*      
%          File:    GRAM_FineTuning
%          Date:    $Date: $
%          Version: $Revision: $
%          Author:  $Author: $
%          ID:      $Id: $
%      
%          File Description
%           function [gMSE,gHE] = GRAM_FineTuning(dirSubject,dirFinalField,gpath,gmean,Fineiter,Finesmoothing)
%           Fineiter: iteration parameter for fine tuning registration (default: 5)
%           Finesmoothing: regularization parameter for fine tuning registration
%           (default: 1.5)
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

function [gMSE,gHE] = GRAM_FineTuning(dirBin,dirSubject,dirFinalField,gpath,gmean,Fineiter,Finesmoothing)

f = dir([dirSubject,'/*.nii']);
if (isempty(f))
    error('No Nifti file (.nii)');
end
N = length(f);

if nargin < 5
    Fineiter = '5';
end

if nargin < 6
    Finesmoothing = '1.5';
end

cursor = strfind(dirFinalField,'/');
dirResult = dirFinalField(1:cursor(end)-1);
                
%% Fine-tune composed deformation field
gMSE = zeros(N,1);
gHE = zeros(N,1);

if ~exist([dirResult,'/gMSE.mat'],'file') || ~exist([dirResult,'/gHE.mat'],'file')

    dirWarped = [dirFinalField(1:end-6),'/Warped'];
    if ~exist(dirWarped,'dir')
        mkdir(dirWarped);
    end

    dirJacobian = [dirFinalField(1:end-6),'/Jacobian'];
    if ~exist(dirJacobian,'dir')
        mkdir(dirJacobian);
    end

    path = gpath; 

    giMSE = zeros(N,1);
    giHE = zeros(N,1);

    for s = 1:N
        if s~=gmean
            sPath = path{s};

            Fix = f(sPath(length(sPath))).name(1:end-4);
            Mov = f(sPath(1)).name(1:end-4);

            FixedImage = [dirSubject,'/',f(sPath(length(sPath))).name];
            MovingImage = [dirSubject,'/',f(sPath(1)).name];

            FixToMov = [dirFinalField,'/',Fix,'to',Mov,'-def.nii'];

            WarpedImage = [dirWarped,'/',Mov,'to',Fix,'.nii'];
            Jacobian = [dirJacobian,'/',Fix,'to',Mov,'-jac.nii'];

            if length(sPath) == 2
                %copyfile([dirComposedField,'/',Fix,'to',Mov,'-def.nii'],FixToMov);
                cmd = [dirBin,'/WarpImage ',FixedImage,' ',MovingImage,' ',FixToMov,' ',WarpedImage,' 0 1'];
                [~,r] = dos(cmd);
                giMSE(s,1) = str2double(r);
                cmd = [dirBin,'/JacobianField ',FixToMov,' ',Jacobian];
                [~,r] = dos(cmd);
                idx = strfind(r,' ');
                giHE(s,1) = str2double(r(1:idx(1)));
            else
                cmd = [dirBin,'/DemonsRegistration_dong_n -f ',FixedImage,' -m ',MovingImage,' -b ',FixToMov,' -o ',WarpedImage,' -i ',Fineiter,' -s ',Finesmoothing,' -d'];
                [~,result] = dos(cmd);
                idx = strfind(result,' ');
                giMSE(s,1) = str2double(result(1:idx(1)-1));
                giHE(s,1) = str2double(result(idx(1)+1:idx(2)-1));                   
            end

        end
    end
    gMSE = giMSE;
    gHE = giHE;
    save([dirResult,'/gMSE.mat'],'gMSE');
    save([dirResult,'/gHE.mat'],'gHE');
    movefile([dirWarped,'/*jac.nii'],dirJacobian);
else
    load([dirResult,'/gMSE.mat']);
    load([dirResult,'/gHE.mat']);
end

