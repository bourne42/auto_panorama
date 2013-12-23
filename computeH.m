function [H] = computeH(pts1, pts2)
%COMPUTEH computes h such that pts1*H=pts2
%   pts1 and pts2 are nx2 matrices, will be transformed into nx3 (ending 1)

numPts = size(pts1,1);

pts1=[pts1 ones(numPts,1)];
pts2=[pts2 ones(numPts,1)];

H=pts1\pts2;

end