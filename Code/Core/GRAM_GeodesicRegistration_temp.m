%/*      
%          File:    GRAM_GeodesicRegistration.m
%          Date:    $Date: $
%          Version: $Revision: $
%          Author:  $Author: $
%          ID:      $Id: $
%      
%          File Description
%         function GRAM_GeodesicRegistration(dirSubject,dirFinalField,gpath,gmean,NNiter,NNsmoothing)
%         Geodesic Registration in anatomical manifold
%         dirSubject: Subject Folder. Assume 'nii' file format
%         dirResult: The folder where the result will be saved
%         gpath: geodesic path. See GRAM_GeodesicPath
%         gmean: geodesic mean template. See GRAM_GeodesicPath
%         NNiter: iteration paramter for demons registration between neighborhood
%         (default: 15x10x5)
%         NNsmoothing: regularization parameter for registration between
%         neighborhood (default: 1.5)
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

function GRAM_GeodesicRegistration_temp(dirSubject,dirFinalField,gpath,gmean,NNiter,NNsmoothing)


%% Initialziation
f = dir([dirSubject,'/*.nii']);
if (isempty(f))
    error('No Nifti file (.nii)');
end
N = length(f);

if nargin < 5
    NNiter = '10x10x10';
end

if nargin < 6
    NNsmoothing = '1.5';
end

if ~exist(dirFinalField,'dir')
    mkdir(dirFinalField);
end

cursor = strfind(dirFinalField,'/');
dirResult = dirFinalField(1:cursor(end)-1);

%% Registration between neighborhood nodes  

%Folder for neighborhood registration 
dirNNField = [dirResult,'/NNField'];
if ~exist(dirNNField,'dir')
    mkdir(dirNNField);
end      
% 
% path = gpath;               
% 
% for s = 1:N
%     sPath = path{s};
% 
%     for i = length(sPath):-1:2
%         Fix = f(sPath(i)).name(1:end-4);
%         Mov = f(sPath(i-1)).name(1:end-4);
% 
%         FixedImage = [dirSubject,'/',f(sPath(i)).name];
%         MovingImage = [dirSubject,'/',f(sPath(i-1)).name];
% 
%         FixToMov = [dirNNField,'/',Fix,'to',Mov,'-def.nii'];
% 
%         if ~exist(FixToMov,'file')
%             cmd = ['DemonsRegistration_dong -f ',FixedImage,' -m ',MovingImage,' -O ',FixToMov,' -i ',NNiter,' -s ',NNsmoothing,' -e'];
%             dos(cmd);
%         end                
%     end
% end
%% Registration via geodesic path
dirComposedField = [dirFinalField,'/TempField'];
if ~exist(dirComposedField,'dir')
    mkdir(dirComposedField);
end

path = gpath;

Fix = f(gmean).name(1:end-4);
for s = 1:N
    if ~exist([dirFinalField,'/',Fix,'to',f(s).name(1:end-4),'-def.nii'],'file') || s == gmean
        sPath = path{s};

        % If length of path is 2, no composition.
        if length(sPath) == 2
            Mov = f(sPath(1)).name(1:end-4);
            copyfile([dirNNField,'/',Fix,'to',Mov,'-def.nii'],[dirFinalField,'/',Fix,'to',Mov,'-def.nii']);


        % If length of path is greater than 3, compose the deformation fields
        % alogn path
        elseif length(sPath) >= 3

            for i = length(sPath):-1:3
                Inter = f(sPath(i-1)).name(1:end-4);
                Mov = f(sPath(i-2)).name(1:end-4);

                if i == length(sPath)
                    FixToInter = [dirNNField,'/',Fix,'to',Inter,'-def.nii'];
                else
                    FixToInter = [dirComposedField,'/',Fix,'to',Inter,'-def.nii'];
                end

                InterToMov = [dirNNField,'/',Inter,'to',Mov,'-def.nii'];

                if i == 3
                    FixToMov = [dirFinalField,'/',Fix,'to',Mov,'-def.nii'];
                else
                    FixToMov = [dirComposedField,'/',Fix,'to',Mov,'-def.nii'];
                end

                % Check Dong's ConcatenateFields

                cmd = ['ConcatenateFields ',FixToInter,' ',InterToMov,' ',FixToMov];
                [status,result]=dos(cmd); if status~=0, warning(cmd); error(result); end

            end
            delete([dirComposedField,'/*.nii']);
        end 
    end
end
rmdir(dirComposedField);
