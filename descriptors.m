function [desc] = descriptors(img, pts)
%DESCRIPTORS returns descriptors on img for the given points

desc=zeros(size(pts,1),64);

im2=conv2(rgb2gray(img), (1/25*ones(5)));%fspecial('gaussian', 10, 10.0/6.0));
[FX,FY]=gradient(im2);

for(i=1:size(pts,1))
%     xs = pts(i,1)-20:5:pts(i,1)+19;
%     ys = pts(i,2)-20:5:pts(i,2)+19;
%     
%     xs=min(max(xs,1),size(img,2));
%     ys=min(max(ys,1),size(img,1));

    grad=[FX(pts(i,2),pts(i,1)) FY(pts(i,2),pts(i,1))];
    grad=grad./norm(grad);
    gradP=[grad(2) -grad(1)];
    
    ptsForDesc=[];
    for(x=-3:4)
        for(y=-3:4)
            p=pts(i,:)+((x*5)*grad)+((y*5)*gradP);
            ptsForDesc=[ptsForDesc; p];
        end
    end
    
    ptsForDesc(:,1)=min(max(ptsForDesc(:,1),1), size(img,2));
    ptsForDesc(:,2)=min(max(ptsForDesc(:,2),1), size(img,1));
    ptsForDesc=int64(ptsForDesc);
    
    X=im2(sub2ind(size(im2), ptsForDesc(:,2), ptsForDesc(:,1)));
%     X=img(ys,xs);
    X=X-mean(X(:));%mean 0
    X=X./std(X(:));%standard deviation 1
    desc(i,:)=X;%reshape(X,[1,64]);
end

end

