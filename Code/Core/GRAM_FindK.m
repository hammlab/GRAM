%/*      
%          File:    GRAM_FindK
%          Date:    $Date: $
%          Version: $Revision: $
%          Author:  $Author: $
%          ID:      $Id: $
%      
%          File Description
%           function [Ki tidx]= GRAM_FindK(dists,partial)
%           Find connected graph 
%           dists: pairwise distance
%           partial: fraction of subjects who are outliers anatomic manifold (default:0 optional)
%           Ki: required K-nearest neighborhood for connected graph
%           tidx: outlier subjects
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
function [Ki tidx]= GRAM_FindK(dists,partial)

%% Initialization Setup
% number of subjects
n = length(dists);

if nargin < 2
    partial = 0;
end

%initialization
Kmin = 2;
Kmax=n;
geodist = zeros(n,n);

%% Find K to be connected graph
for K=Kmin:Kmax
    %Defind Neighborhood
    adj = Geodesic_Adjacent(dists,K);
    A = sparse(dists.*adj);
    
    %Shortest Path finding algorithm
    for i = 1:n
        geodist(i,:) = shortest_paths(A,i);
    end
    
    %Check Outlier
    if length(find(isinf(geodist(:,1))|isinf(geodist(1,:)'))) <= round(n * partial)
        tidx = find(isinf(geodist(:,1))|isinf(geodist(1,:)'));
        break; 
    end
end

Ki = K;

function adj = Geodesic_Adjacent(dists,K)

[~,ind]=sort(dists,1);

n = length(dists);

NN=cell(n,1); 

for i=1:n 
    NN{i}=ind(2:K+1,i); 
end

adj=zeros(n); 
for i=1:n
    adj(NN{i},i)=1; 
end