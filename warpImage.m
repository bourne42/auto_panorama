function [outIm, xLoc, yLoc] = warpImage(image, H)
%WARPIMAGE warp the image by H
%  H is 3x3 homography matrix
%  For p in image and corresponding p' in outIm, p'*H=p
%  xLoc and yLoc is location of top left corner of image for the original
%  image

[height width three]=size(image);

[minX minY maxX maxY] = computeMinMax(H, height, width);

xLoc=minX;
yLoc=minY;

ys=maxY-minY+1;
xs=maxX-minX+1;

points(:,:,1)=repmat([minX:maxX], ys, 1);
points(:,:,2)=repmat([minY:maxY]', 1, xs);
points(:,:,3)=ones(ys, xs);

% Didn't get around to shortening this, should be relatively simple
for(x=[1:xs])
    for(y=[1:ys])
        a=[points(y,x,1) points(y,x,2) 1]*H;
        points(y,x,1)=a(1);
        points(y,x,2)=a(2);
    end
end

% Tried to shorten above with this code byt didn't work

% points=reshape(points, [ys,3,xs]);
% for(x=1:xs)
%     points(:,:,x)=points(:,:,x)*H;
% end
% points=reshape(points, [ys,xs,3]);

outIm(:,:,1) = interp2(image(:,:,1), points(:,:,1), points(:,:,2));
outIm(:,:,2) = interp2(image(:,:,2), points(:,:,1), points(:,:,2));
outIm(:,:,3) = interp2(image(:,:,3), points(:,:,1), points(:,:,2));

end