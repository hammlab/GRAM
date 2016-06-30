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
