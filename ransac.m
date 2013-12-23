function [H, numMatches, ptsUsed] = ransac(pts1, pts2)
%RANSAC performs RANSAC to further remove outliers then compute H.
% Also returns how many points were ultimately used. 

numMatches=0;
ptsUsed=[];

pts11=[pts1 ones(size(pts1,1),1)];

for(i=1:1000)
    currentPts= randperm(size(pts1,1),4);
   
warning off;
    H=computeH(pts1(currentPts,:), pts2(currentPts,:));
warning on;

    ptsTmp=pts11*H;
   
    ds=(pts2(:,1)-ptsTmp(:,1)).^2 + (pts2(:,2)-ptsTmp(:,2)).^2;

    ds=[ds [1:size(pts1,1)]'];
    ds(ds(:,1)>100,:)=[];

    if(size(ds,1)>numMatches)
        numMatches=size(ds,1);
        ptsUsed=ds(:,2);
    end
end

H=computeH(pts1(ptsUsed,:), pts2(ptsUsed,:));

end

