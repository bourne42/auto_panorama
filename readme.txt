Project 6 (Panorama part A) Readme
Conrad Verkler cverkler

All images must be singles (im2single). 

computeH: takes 2 sets of points and computes the homography that converts pts1->pts2.

warpImage: takes image and homography to warp it by. Uses interp2 to linearly interpolate. Also returns the x and y location of the image (if placed ontop of the image we're going to merge it with). These coordinates are used in mergeImages.

computeMinMax: computes min and max x and y values for the transformed image. Used in warpImage.

mergeImages: takes 2 images and the x,y location of im2 on im1 (returned by warpImage). Uses alpha blending (horizontal only) to blend first low resolution images and then high resolution then adds them together. Returns the added horizontal and vertical pixels to the left/top (respectively) of im1 so functions calling this know how much it has changed. Never got around to using xDiff. 
im2 is expected to have NaN's for pixels with no value (returned in warpImage). 
This does a lot of headachey stuff with the mask to get a good alpha blend but it works relatively well. 

transformPoints: takes a matrix of points (nx2) and transforms them by the 3x3 matrix trans and adds xDiff and yDiff to their respective coordinates. Called by createPan.

createPan: creates a panorama from a given sequence of images and corrosponding points by calling multiple warps and merges. Converts all images to the first images coordinates (easiest, didn't get around to improving to center). 
For each pair of images i and i+1 pts1(i) should be the points on image i and pts2(i) should be the corresponding points on image i+1;