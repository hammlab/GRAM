%/*      
%          File:    GRAM_Montage.m
%          Date:    $Date: $
%          Version: $Revision: $
%          Author:  $Author: $
%          ID:      $Id: $
%      
%          File Description
%             function GRAM_Montage(dirData,SliceNum)
%             Display Montage Plot
%          
%          Copyright 2011 Jihun Hamm and Donghye Ye
%
%          This software is distributed WITHOUT ANY WARRANTY; without even
%          the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
%          PURPOSE.  See the above copyright notices for more information.
%*/
function GRAM_Montage(dirData,SliceNum,ncols)
%Dispaly Montage Plot

f = dir([dirData '/*.nii']);
if (isempty(f))
    error('No Nifti file (.nii)');
end

if nargin < 2
    SliceNum = 1;
end

N = length(f);

nii = load_nii([dirData '/' f(1).name]);
img = nii.img;

I = zeros(size(img,2),size(img,1),1,N);

for i = 1:N
    nii = load_nii([dirData '/' f(i).name]);
    img = nii.img;
%     size(img)
%     size(flipud(fliplr(rot90(img(:,:,SliceNum),-1))))
%     pause
    I(1:size(img,2),1:size(img,1),1,i) = double(flipud(fliplr(rot90(img(:,:,SliceNum),-1))));
end

figure;montagesc(I,'Size',[NaN ncols]);
