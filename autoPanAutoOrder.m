function [totalIm] = autoPanAutoOrder(name, number)
%AUTOPANAUTOORDER same as autoPan except finds own order

images=cell(number);
pts=cell(number);
desc=cell(number);

for(i=1:number)
    images{i}=im2single(imread(sprintf('%s%d.jpg',name,i)));
    pts{i}=anms(images{i});
    desc{i}=descriptors(images{i},pts{i});
end

matchingPairs=zeros(number, number);%row number (left) -> column number (right)

for(i=1:number-1)%x
    for(j=i+1:number)
        [p1,p2]=matches(pts{i}, desc{i}, pts{j}, desc{j});
        [H,num,finalPts]=ransac(p1,p2);
        xAvg1=(sum(p1(finalPts,1)))./size(finalPts);
        
        if(xAvg1>size(images{i},2)/2)
            matchingPairs(j,i)=num;
        else
            matchingPairs(i,j)=num;
        end
    end
end

%find path:
goodMatches=[];
for(i=1:number)
    for(j=1:number)
            [blah,row]=max(matchingPairs(j,:));
            [blah,col]=max(matchingPairs(:,i));
            if(col==j && row==i)
                goodMatches=[goodMatches; i j];
            end
    end
end

order=zeros(1,number);
for(i=1:number)
    if(max(ismember(goodMatches(:,2), i))==0)
        order(1)=i;
        break;
    end
end
%if nothing that would be first image than just return black image
if(order(1)==0)
    totalIm = zeros(5);
    return;
end
%iterate and find sequence
for(i=2:number)
    next=ismember(goodMatches(:,1), order(i-1));
    order(i)=goodMatches(next,2);
end

totalIm = autoPan(name, number, order);

end

