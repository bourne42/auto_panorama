function [match1, match2] = matches(pts1, desc1, pts2, desc2)
%MATCHES Matches points from pts1 to pts2 using respective descriptors
% Expects descriptors from descriptors function (matrix form)
% Uses square between 2 vectors. If 1NN/2NN <=.6

distances=dist2(desc1,desc2); %(i,j) is ith of pts1 and jth of pts2

[nn1, ind]=min(distances); %min of each column and their locations

% replaces all min values with a really big number
distances(sub2ind(size(distances),ind,[1:size(pts1,1)])) = 500; %arbitrary big number

nn2=min(distances);

ratio = nn1./nn2;

matchPairs=[[1:size(pts1,1)] ; ind ; ratio];

badMatches = (matchPairs(3,:)>.6);
matchPairs(:,badMatches)=[];

match1=pts1(matchPairs(2,:),:);
match2=pts2(matchPairs(1,:),:);

end

