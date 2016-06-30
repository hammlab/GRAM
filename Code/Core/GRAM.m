function [pdist,K,gpath,gmean,gdist,gMSE,gHE,dMSE,dHE]=GRAM(dirSubject,dirResult,dirDirectResult,w,NNiter,NNsmoothing,Fineiter,Finesmoothing,Directiter,Directsmoothing)
% function [pdist,gpath,gmean,gdist,gMSE,gHE,dMSE,dHE]=GRAM
% (dirSubject,dirResult,dirDirectResult,
% w,NNiter,NNsmoothing,Fineiter,Finesmoothing,Directiter,Directsmoothing)
%
% GRAM does the following things: 1) performs pairwise registration of all image to analyze the
% structure of data, 2) finds the geodesic mean template and the geodesic
% paths, 3) performs the proposed geodesic registration of all images to the
% template, and 4) performs direct registration of all images to the
% template for comparison.
%
% %Dependencies:
% GRAM uses the following four binaries for registration of images and manipulation of
% deformation fields:
% ConcatenateFields, WarpImage, JacobianField, DemonsRegistration_dong, DemonsRegistration_dong_n
% GRAM uses matlab_nifti toolbox to read and write .nii images.
% GRAM uses matlab_bgl toolbox to compute shortest-paths.
%
% % Output parameters
% pdist : distance between all pairs of images computed from pairwise registration
% K : minimum size of the connected k-nearest-neighbor graph
% gpath : shortest-paths from all images to the template
% gmean : template number chosen from the dataset. 
% gdist : geodesic distances between all images
% gMSE : Mean-squared error resulting from geodesic registration
% gHE : Harmonic Energy resulting from geodesic registration
% dMSE : Mean-squared error resulting from direct registration
% dHE : Harmonic Energy resulting from direct registration
% 
% % Input parameters
% dirSubject: directory for storing image dataset
% dirResult: directory for storing registration results from geodesic
% method. gHE.mat, gMSE.mat, pHE.mat, and pMSE.mat files are created. 
% Inside dirResult, four subdirectories are created:
%   Field: stores deformation field from the template to each image
%   Jacobian: stores Jacobian of the fields
%   NNField: intermediate deformation fields along the geodesic paths
%   Warped: stores warped(=registered) images
% dirDirectResult: directory for storing registration results from 
% direct method. dHE.mat and dMSE.mat files are created.
% Inside dirDirectResult, three subdirectories are created similarly to
% dirResult directory:
%   Field: stores deformation field from the template to each image
%   Jacobian: stores Jacobian of the fields
%   Warped: stores warped(=registered) images
% w: weight between MSE and HE in distance definition
% NNiter: iteration number of NN registration
% NNsmoothing: regularization parameter for NN registration
% Fineiter: iteration number for fine tuning Finesmoothing: regularization parameter for fine tuning
% Directiter: iteration number for Diffeomorphic Demons
% Directsmoothing: regularization parameter for Diffeomorphic Demons
%
%/*      
%          File:    test.m
%          Date:    $Date: $
%          Version: $Revision: $
%          Author:  $Author: $
%          ID:      $Id: $
%      
%          File Description: refer to the descriptions above.
%
%          Copyright 2011 Jihun Hamm and Donghye Ye
%
%          This software is distributed WITHOUT ANY WARRANTY; without even
%          the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
%          PURPOSE.  See the above copyright notices for more information.
%*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create directories for saving intermediate results.

dirFinalField = [dirResult,'/Field'];
if ~exist(dirResult,'dir')
    mkdir(dirResult);
end
if ~exist(dirDirectResult,'dir')
    mkdir(dirDirectResult);
end
f = dir([dirSubject,'/*.nii']);
N = length(f); % number of total images

%% Pairwise Registration
fprintf('Computing pairwise distances\n');
pdist = GRAM_PairwiseDistance(dirSubject,w,dirResult);

%% Find K
fprintf('Finding K\n');
K= GRAM_FindK(pdist);
fprintf('K=%d\n',K);

%% Find Geodesic Path
fprintf('Finding geodesic paths\n');
[gpath,gmean,gdist] = GRAM_GeodesicPath(pdist,K);

%% Geodesic Registration
fprintf('Geodesic registration\n');
GRAM_GeodesicRegistration(dirSubject,dirFinalField,gpath,gmean,NNiter,NNsmoothing);

%% Fine Tuning
fprintf('Fine tuning\n');
[gMSE,gHE] = GRAM_FineTuning(dirSubject,dirFinalField,gpath,gmean,Fineiter,Finesmoothing);

%% Direct Registration
fprintf('Direct registration\n');
[dMSE,dHE] = GRAM_DirectRegistrationForComparison(dirSubject,dirDirectResult,gmean,Directiter,Directsmoothing);

