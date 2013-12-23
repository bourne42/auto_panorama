function [outIm] = pointsOnImage(inIm, pts)
%POINTSONIMAGE draws points on inIm, pts expected to be Nx2 matrix, having
%N points

outIm=inIm;

for(i=1:size(pts,1))
    outIm(pts(i,2)-1:pts(i,2)+1, pts(i,1)-1:pts(i,1)+1,:)=zeros(3,3,3);
    outIm(pts(i,2), pts(i,1),:)=[1 0 0];
end

end

