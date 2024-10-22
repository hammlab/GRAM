%/*      
%          File:    GRAM_Isomap.m
%          Date:    $Date: $
%          Version: $Revision: $
%          Author:  $Author: $
%          ID:      $Id: $
%      
%          File Description
%             function GRAM_Montage(dirData,SliceNum)
%             Compute and display the ISOMAP embedding
%          
%          Copyright 2011 Jihun Hamm and Donghye Ye
%
%          This software is distributed WITHOUT ANY WARRANTY; without even
%          the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
%          PURPOSE.  See the above copyright notices for more information.
%*/
function GRAM_Isomap(dirSubject,gdist,K,sliceNum,frac)

if nargin < 4
    sliceNum = 1;
end

f = dir([dirSubject,'/*.nii']);
if (isempty(f))
    error('No Nifti file (.nii)');
end
N = length(f);

J=eye(N)-ones(N)/N;

[~, gmean] = min(sum(gdist));

NN = Geodesic_Adjacent(gdist,K);

D=gdist.^2; 
D=1/2*(D+D'); % symmetrize: cost is not symmetric in general
V=-1/2*J*D*J; 
V=1/2*(V+V'); 

[E,dd]=eig(V); [dd,ind]=sort(diag(dd)); ind=flipud(ind); dd=flipud(dd);
X=diag(sqrt(dd(1:3)))*E(:,ind(1:3))'; 
if find(isnan(X)), error('nan'); end
if find(isinf(X)), error('inf'); end
if find(~isreal(X)), error('complex'); end

rangex=max(X(1,:))-min(X(1,:));
rangey=max(X(2,:))-min(X(2,:));
width=frac*rangex; height=frac*rangey;

[a b] = meshgrid(linspace(min(X(1,:)),max(X(1,:)),1/frac),...
    linspace(min(X(2,:)),max(X(2,:)),1/frac));

idx = zeros(size(a));
for k = 1:size(a,1)
    for l = 1:size(a,2)
        dist = (X(1,:)-a(k,l)).^2 + (X(2,:)-b(k,l)).^2; 
        [~, idx(k,l)] = min(dist);
    end
end

idx = unique(idx(:));
%% show connectivity
figure;
hold on;
for i=1:length(idx)
    for j=find(NN(:,idx(i))==1)
        plot([X(1,idx(i)),X(1,j)],[X(2,idx(i)),X(2,j)],'-r');
    end
end

hold on;
for i=1:length(idx)
    xmin=X(1,idx(i))-width/2; xmax=X(1,idx(i))+width/2;
    ymin=X(2,idx(i))-height/2; ymax=X(2,idx(i))+height/2;

    nii = load_nii([dirSubject,'/',f(i).name]);
    img = uint8((fliplr(rot90(squeeze(nii.img(:,:,sliceNum)),-1))));

    imagesc([xmin xmax],[ymin ymax],img);colormap('gray');
end

i = gmean;
xmin=X(1,i)-width/2; xmax=X(1,i)+width/2;
ymin=X(2,i)-height/2; ymax=X(2,i)+height/2;

nii = load_nii([dirSubject,'/',f(i).name]);
img = uint8((fliplr(rot90(squeeze(nii.img(:,:,sliceNum)),-1))));

imagesc([xmin xmax],[ymin ymax],img);colormap('gray');
line([xmin xmax xmax xmin xmin],[ymin ymin ymax ymax ymin],'Color',[1 0 0],'LineWidth',3);

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
