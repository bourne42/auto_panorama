function [outPts] = anms(imrgb)
%ANMS Performs Adaptive Non-Maximal Suppression
% Returns matrix of points 500 x 2

[x,y,z]=harris(imrgb);
ptsR = [x y z zeros(size(x))];

for(i=1:size(x))
    ptsT=[x y (.9*z)];
    smaller=(ptsT(:,3)<ptsR(i,3));
    ptsT(smaller,:)=[];% filter out all points will smaller value that i
    rs=((ptsT(:,1)-ptsR(i,1)).^2) + ((ptsT(:,2)-ptsR(i,2)).^2);

    ptsR(i,4)=min([rs; size(imrgb,2)^2]); %if everything is smaller then max value, make big
end

ptsR=sortrows(ptsR,-4); % sorts so largest radius at top

outPts=ptsR(1:500,1:2);

end