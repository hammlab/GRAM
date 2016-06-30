%/*      
%          File:    GRAM_GeodesicPath.m
%          Date:    $Date: $
%          Version: $Revision: $
%          Author:  $Author: $
%          ID:      $Id: $
%      
%          File Description
%             function [gpath,gmean,gdist] = GRAM_GeodesicPath(pair_dist,K)
%             Find Geodesic Path given K neighborhood
%             pair_dist: pairwise distance
%             K: K neighborhood
%             gpath: geodesic path
%             gmean: geodesic mean template
%             gdist: geodesic distance
%          
%      
%          Copyright 2011 Jihun Hamm and Donghye Ye
%
%          This software is distributed WITHOUT ANY WARRANTY; without even
%          the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
%          PURPOSE.  See the above copyright notices for more information.
%*/
function [gpath,gmean,gdist] = GRAM_GeodesicPath(pair_dist,K,tmplt)

%% Initialization setup
% number of subjects
n = length(pair_dist);

gdist = zeros(n,n);
gpath = cell(n,1);
paths = cell(n,n);

adj = Geodesic_Adjacent(pair_dist,K);
A = sparse(pair_dist.*adj);

%% Find a connected graph given K
for i = 1:n
    [gdist(i,:),gpath{i}] = shortest_paths(A,i);
end
if any(isinf(gdist)), error('Graph not connected. Try larger K'); end

%% Find paths in a connected graph
for i = 1:n
    for j = 1:n
        paths{i,j} = TreeToPath(gpath{i},j);
    end
end


%% Find geodesic mean
if exist('tmplt','var')
    gmean = tmplt;
else
    [~, gmean] = min(sum(gdist));
end

gpath = paths(:,gmean);

function path = TreeToPath(tree,leaf)

rootidx = find(tree==0);

path = [];
if leaf == rootidx
    path = rootidx;
else
    curridx = leaf;
    while curridx ~= rootidx
    path = [path,curridx];
    curridx = tree(curridx);
    end
    path = [path,rootidx];    
end

path = fliplr(path);

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


