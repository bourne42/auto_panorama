function [totalIm] = autoPan(name, number, order)
%AUTOPAN takes all pictures numberd name#.jpg and stitch
% order determines the order the pics are stitched together, leave blank
% for 1..number

if(nargin<3)
    order=[1:number];
end

totalIm=im2single(imread(sprintf('%s%d.jpg',name,order(1))));
prevPoints=anms(totalIm);
prevDesc=descriptors(totalIm,prevPoints);

totalXDiff=0;
totalYDiff=0;

lastH=eye(3);

for(i=2:number)
    currImage=im2single(imread(sprintf('%s%d.jpg',name,order(i))));
    currPoints=anms(currImage);
    currDesc=descriptors(currImage,currPoints);
    
    [p1,p2]=matches(prevPoints, prevDesc, currPoints, currDesc);
    
    if(i>2)
        p1=transformPoints(p1,inv(lastH),0,totalYDiff);
    end
    H=ransac(p1,p2);
    
    [outIm, xLoc, yLoc] = warpImage(currImage, H);
    [totalIm, totalXDiff, totalYDiff] = mergeImages(totalIm, outIm, xLoc, yLoc);
    lastH=H;
    
    prevPoints=currPoints;
    prevDesc=currDesc;
end

end

