function [pointsOut] = transformPoints(pointsIn, trans, xDiff, yDiff)
%TRANSFORMPOINTS transforms each of the points by trans then adds xDiff and
%yDiff

height=size(pointsIn,1);

pointsIn=[pointsIn ones(height,1)];
pointsIn=pointsIn*trans;
pointsOut=pointsIn(1:height, 1:2);
pointsOut=pointsOut+[(xDiff*ones(height,1)) (yDiff*ones(height,1))];

end

