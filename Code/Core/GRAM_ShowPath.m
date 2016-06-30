%/*      
%          File:    GRAM_ShowPath.m
%          Date:    $Date: $
%          Version: $Revision: $
%          Author:  $Author: $
%          ID:      $Id: $
%      
%          File Description
%          GRAM_ShowPath(dirSubject,onepath)displays images from dirSubject on the
%          given path (onepath).
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

function GRAM_ShowPath(dirSubject,onepath)

f = dir([dirSubject,'/*.nii']);

nii = load_nii([dirSubject,'/',f(1).name]);
[r,c,s] = size(nii.img);

disp_slice = zeros(c,r,1,length(onepath),'uint8');

for i=1:length(onepath)
    sliceNum = round(s/2);
    fileName = [dirSubject,'/',f(onepath(i)).name];
    nii = load_nii(fileName);
    if 1%size(nii.img,1) == size(nii.img,2)
        %disp_slice(:,:,1,i) = uint8(rot90((nii.img(:,:,sliceNum))));
        disp_slice(:,:,1,i) = flipud(fliplr(rot90(nii.img(:,:,sliceNum),-1)));        
    %else
    %    disp_slice(:,:,1,i) = uint8((nii.img(:,:,sliceNum)));
    end
end
figure;
montage(disp_slice,'Size',[1 NaN]);title(num2str(onepath));
