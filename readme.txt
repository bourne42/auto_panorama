Automatic panorama maker in matlab


All images must be singles (im2single). 

Files for the basic panorama stitcher:

computeH: takes 2 sets of points and computes the homography that converts pts1->pts2.

warpImage: takes image and homography to warp it by. Uses interp2 to linearly interpolate. Also returns the x and y location of the image (if placed ontop of the image we're going to merge it with). These coordinates are used in mergeImages.

computeMinMax: computes min and max x and y values for the transformed image. Used in warpImage.

mergeImages: takes 2 images and the x,y location of im2 on im1 (returned by warpImage). Uses alpha blending (horizontal only) to blend first low resolution images and then high resolution then adds them together. Returns the added horizontal and vertical pixels to the left/top (respectively) of im1 so functions calling this know how much it has changed. Never got around to using xDiff. 
im2 is expected to have NaN's for pixels with no value (returned in warpImage). 
This does a lot of headachey stuff with the mask to get a good alpha blend but it works relatively well. 

transformPoints: takes a matrix of points (nx2) and transforms them by the 3x3 matrix trans and adds xDiff and yDiff to their respective coordinates. Called by createPan.

createPan: creates a panorama from a given sequence of images and corrosponding points by calling multiple warps and merges. Converts all images to the first images coordinates (easiest, didn't get around to improving to center). 
For each pair of images i and i+1 pts1(i) should be the points on image i and pts2(i) should be the corresponding points on image i+1;


Files for automatic:
anms: gets points from the given harris point detector. For each point find the maximum radius there can be around it while having it still be maximum. Sort poits by this radius and then take the top 500 points. 

pointsOnImage: draw list of points onto the given image, used to show what points I ended up with

descriptors: takes in a Nx2 matrix of N points and returns an Nx64 matrix of descriptors. Calculates each descriptor with respect to the gradient so descriptors will be rotationally invariant. Calculates as described in paper. 

matches: takes 2 sets of points and their descriptors and matches them together. Only compare one way. Uses given dist2 function. When the ratio of 1NN/2NN<=.6 then keep the match. 

ransac: uses 1000 iterations of ransac to find the best points and best H. Selects 4 random pairs and calculates the H. Sometimes this throws a warning but didn't mess up the final result, so I removed warnings for calculating H. To decide if a pair of points fits the original 4 transform it by H, if the transformed point is withing 10 pixels (100 in code becasuse didn't square root) then matches H. At end uses all points to calculate H and returns H, how many points were used, and the indexes of those points (latter 2 values are used for automatic ordering of images). 

autoPan: basically copies my original make panorama but gets its own matches. Takes the a string and how many pictures there are. Assumes pictures are labeled name1.jpg,name2.jpg. It also takes an optional 3rd argument of a vector with the order of numbers which is used by autoPanAutoOrder. 

autoPanAutoOrder: calculate the number of shared points between every pair of images using ransac. When 2 pictures overlap then there are a lot more shared points. To tell if what side they overlap on calculate the average of all the used points and check which half the average is on. Then iteratively finds the order and passes to autoPan. 
