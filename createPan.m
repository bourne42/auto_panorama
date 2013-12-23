function [totalIm] = createPan(images, pts1, pts2)
%CREATEPAN creates panorama with cell array of images, pts1, pts2
% points on images i and i+1 will be in pts1(i) and pts2(i) respecitvely

totalIm=images{1};
totalXDiff=0;
totalYDiff=0;

lastH=eye(3);%not really used, if it was should put 0 at (3,3)
totImages=size(images,2);

% mid=floor(totImages/2);
mid=1;

for(i=mid:totImages-1)
    if(i==mid)
        H=computeH(pts1{i}, pts2{i});
    else
        H=computeH(transformPoints(pts1{i},inv(lastH),0,totalYDiff), pts2{i});
    end
    [outIm, xLoc, yLoc] = warpImage(images{i+1}, H);
    [totalIm, totalXDiff, totalYDiff] = mergeImages(totalIm, outIm, xLoc, yLoc);
    lastH=H;
end

end

