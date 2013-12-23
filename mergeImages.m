function [outIm, xDiff, yDiff] = mergeImages(im1, im2, xLoc, yLoc)
%MERGEIMAGES combines im1 and im2, placing im2 at the location given by
%xLoc and yLoc on im1, (1,1) being the exact top left of im1
%  xDiff and yDiff are the number of pixels added to the left/top of im1

xDiff = max(1-xLoc, 0);
yDiff = max(1-yLoc, 0);

xStart2=xLoc+xDiff;
xEnd2=xLoc+xDiff+size(im2,2)-1;
yStart2=yLoc+yDiff;
yEnd2=yLoc+yDiff+size(im2,1)-1;

newW=max([xDiff+size(im1,2), xLoc+size(im2,2), size(im1,2), size(im2,2)]);
newH=max([yDiff+size(im1,1), yLoc+size(im2,1), size(im1,1), size(im2,1)]);

outIm=zeros(newH,newW,3);
outIm2=zeros(newH,newW,3);
outImH=zeros(newH,newW,3);
outIm2H=zeros(newH,newW,3);

%set up mask, apply to im1
imMask=zeros(newH,newW);
imMask(1+yDiff:yDiff+size(im1,1), 1+xDiff:xDiff+size(im1,2))=1;
im2Mask=im2(:,:,1);
im2Mask=(0*im2Mask)+(.5*ones(size(im2Mask)));
im2Mask(find(isnan(im2Mask))) = 1;

imMask(yStart2:yEnd2,xStart2:xEnd2)=imMask(yStart2:yEnd2,xStart2:xEnd2).*im2Mask;

imMaskH=imMask;

        
for(y=2:newH-1)
    firstX=0;
    lastX=0;
    for(x=2:newW-1)
    	if(imMask(y,x)<1 & imMask(y,x)>0)
            if(firstX==0)
                firstX=x;
            end
            lastX=x;
        end
    end
    
    for(x=2:newW-1)
    	if(imMask(y,x)<1 & imMask(y,x)>0)
            imMask(y,x)=(lastX-x)/(lastX-firstX);
            imMaskH(y,x)=min(1,((lastX-x)/(2*(lastX-firstX))));
        end
    end
end

%fix nans:
im2(find(isnan(im2))) = 0;

%create low and high freq images
im1L(:,:,1)=conv2(im1(:,:,1), fspecial('gaussian'), 'same');
im1L(:,:,2)=conv2(im1(:,:,2), fspecial('gaussian'), 'same');
im1L(:,:,3)=conv2(im1(:,:,3), fspecial('gaussian'), 'same');
im1H=im1-im1L;
im2L(:,:,1)=conv2(im2(:,:,1), fspecial('gaussian'), 'same');
im2L(:,:,2)=conv2(im2(:,:,2), fspecial('gaussian'), 'same');
im2L(:,:,3)=conv2(im2(:,:,3), fspecial('gaussian'), 'same');
im2H=im2-im2L;

% outIm=imMask;
outIm(1+yDiff:yDiff+size(im1,1), 1+xDiff:xDiff+size(im1,2),:)=im1L;
outImH(1+yDiff:yDiff+size(im1,1), 1+xDiff:xDiff+size(im1,2),:)=im1H;
for(i=1:3)
    outIm(:,:,i)=outIm(:,:,i).*imMask;
    outImH(:,:,i)=outImH(:,:,i).*imMaskH;
end
outIm2(yStart2:yEnd2,xStart2:xEnd2,:)=im2L;
outIm2H(yStart2:yEnd2,xStart2:xEnd2,:)=im2H;
for(i=1:3)
    outIm2(:,:,i)=outIm2(:,:,i).*(ones(newH,newW)-imMask);
    outIm2H(:,:,i)=outIm2H(:,:,i).*(ones(newH,newW)-imMaskH);
end

outIm=outIm+outIm2+outImH+outIm2H;

% outIm(1+yDiff:yDiff+size(im1,1), 1+xDiff:xDiff+size(im1,2),:)=outIm(1+yDiff:yDiff+size(im1,1), 1+xDiff:xDiff+size(im1,2),:)+im1H;
% outIm(yStart2:yEnd2,xStart2:xEnd2,:)=outIm(yStart2:yEnd2,xStart2:xEnd2,:)+im2H;

end