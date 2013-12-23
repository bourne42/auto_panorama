function [minX, minY, maxX, maxY] = computeMinMax(H, height, width)
%COMPUTEMINMAX returns min and max x and y values for transforming an image
% with given width and height by H

% get 4 corner points:
p1=[1 1 1]/H;
p2=[width 1 1]/H;
p3=[1 height 1]/H;
p4=[width height 1]/H;

minX=floor(min([p1(1) p2(1) p3(1) p4(1)]));
minY=floor(min([p1(2) p2(2) p3(2) p4(2)]));
maxX=ceil(max([p1(1) p2(1) p3(1) p4(1)]));
maxY=ceil(max([p1(2) p2(2) p3(2) p4(2)]));
end

