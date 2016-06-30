%/*      
%          File:    test_GRAM.m
%          Date:    $Date: $
%          Version: $Revision: $
%          Author:  $Author: $
%          ID:      $Id: $
%      
%          File Description
% This script is a demonstration of GRAM framework. It shows the usage of function GRAM.m
% for groupwise registration of simulated 2D images resembling cortical patches. 
%
% To run this script with default parameters, change the directories to fit your downloaded folder.
% It is recommended that the path names do not include spaces.
% After changing the directories, run test_GRAM.m. The script runs in less than an hour on a PC
% without user actions. This will output four figures, whose description is
% in the text.

% To use GRAM.m for other image databases, the directories and the parameters need
% to be set properly. Descriptions of the directories and the parameters can be found by typing
% help GRAM, or by looking into the GRAM.m function.
%      
%          Copyright 2011 Jihun Hamm and Donghye Ye
%
%          This software is distributed WITHOUT ANY WARRANTY; without even
%          the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
%          PURPOSE.  See the above copyright notices for more information.
%*/

%addpath('/home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/Core');
addpath('/home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/matlab_bgl');
%addpath('/home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Code/NIFTI


clear all;
close all;
clc;

%% Directories
dirSubject = '/home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Demo/subject';
dirResult = '/home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Demo/result/geo';
dirDirectResult = '/home/hammj/Documents/MATLAB/CompAnatomy/GRAM/Demo/result/direct';

%% Parameters
w = .75;
NNiter = '15x10x5';
NNsmoothing = '1.5';
Fineiter = '5';
Finesmoothing = '1.5';
Directiter = '15x10x10';
Directsmoothing = '1.5';

%% Run the main function
[pdist,K,gpath,gmean,gdist,gMSE,gHE,dMSE,dHE]=GRAM ...
(dirSubject,dirResult,dirDirectResult,w,NNiter,NNsmoothing,Fineiter,Finesmoothing,Directiter,Directsmoothing)

%% Display warped images
GRAM_Montage([dirResult,'/Warped']);
% Figure 1. GRAM Result: These are 60 images registered to a W-shaped
% template by GRAM method
GRAM_Montage([dirDirectResult,'/Warped']);
% Figure 2. Diffeomorphic Demon Result: These are 60 images registered to the same template
% using Demons method directly. Compare this figure with the figure above.

%% Display Isomap embedding
GRAM_Isomap(dirSubject,gdist,K);
% Figure 3. ISOMAP: This figure shows 2-dimensional embedding of the data using ISOMAP algorithm.
% Red lines show nearest-neighbor relationships of the images. The template image is marked by a red box.

%% Display geodesic paths
% Figure 4. Geodesic Path in Anatomical Manifold: This shows an example of a registration path
% found by GRAM. The leftmost image (source) is registered to the rightmost image (target) sequentially via the path shown below. 
PathIndex = 55; % Let's choose a path from 55-th sample to the template
GRAM_ShowPath(dirSubject,gpath{PathIndex});
