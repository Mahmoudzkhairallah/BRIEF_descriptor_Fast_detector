function corner_non_nax = FAST_non_max(img,corners,percentage)

% instead of looping on a 2d matrix, it's faster to sort our data in one
% array and loop over it.
direction = [[0 3];[1 3];[2 2];[3 1];...
			 [3 0];[3 -1];[2 -2];[1 -3];...
			 [0 -3];[-1 -3];[-2 -2];[-3 -1];...
			 [-3 0];[-3 1];[-2 2];[-1 3]];
ysize = size(img,1);
xsize = size(img,2);
direction = direction(:,1) + direction(:,2)*ysize;
corner = corners(:,1) + (corners(:,2)-1)*ysize;
score = zeros(ysize*xsize,1);

for i = 1:length(corner)
    threshold = percentage*img(corner(i));
    pos = img(corner(i)+direction) - (img(corner(i))+threshold);
  %  x = pos.*(pos>0);
    neg = (img(corner(i))-threshold) - img(corner(i)+direction);
    pos = double(pos);
    pos1 = sum(pos.*(pos>0));
    neg = double(neg);
    neg1 = sum(neg.*(neg>0));
    score(corner(i)) = max([pos1 neg1]);
end

corner_max = zeros(length(corner),1);
up = -1;
down = 1;
left =-size(img,1);
right = size(img,1);

for i = 1:length(corner)
    pixel = corner(i);
    surround = pixel + [up down left right up+left up+right down+left down+right];
    corner_max(i) = (sum(score(pixel) >= score(surround)) == 8);    
end

maxima = corner(find(corner_max));
corner_non_nax = zeros(length(maxima), 2);	
corner_non_nax(:,2) = 1 + floor(maxima/size(img,1));
corner_non_nax(:,1) = mod(maxima,size(img,1));
end