function descriptor = BRIEF_descriptor(img ,feature ,pattern,  window_size , BRIEF_n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BRIEF_descriptor is a function that implements BRIEF descriptor as
% proposed by Michael Calonder et al
% descriptor = BRIEF_descriptor(img ,feature ,pattern,  window_size , BRIEF_n)
%   inputs:
%       img: the image of which the feature were detected
%       feature: an n-by-2 matrix of the coordinates of the detected
%       features, with y as 1st column and x as 2nd column
%       pattern: an n-by-4 matrix of points to be compared around the
%       feature point with 1st two columns as the coordintes of the 1st
%       point and the 2nd two columns as the coordinates of the 2nd point
%       window_size: the size of the window used around the feature point
%       BRIEF_n: takes an integer number to represent the size of the
%       descriptore
%   output:
%       descriptor: an array of size n-by-m where n is the number of
%       features and m is the descriptor size, so that each row describes
%       the corresponding feature 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rows = size(img,1);
columns = size(img,2);
im_corner =zeros(floor(window_size/2));
edge_ver = zeros(rows,floor(window_size/2));
edge_hor = zeros(floor(window_size/2),columns);
% apply image padding to maintain matchin at all the pixels
img = [im_corner edge_hor im_corner;...
       edge_ver img edge_ver;...
       im_corner edge_hor im_corner];

%% smoothing the picture to reject noise first 
sigma = sqrt(2);
filter_size_gaussian = 9;
meu = floor(filter_size_gaussian/2);
A = 1 / (2*pi*sigma);
B = 2*sigma^2;
gaussian_kernel = zeros(filter_size_gaussian);
for i = 1:filter_size_gaussian
    for j = 1:filter_size_gaussian
        temp = -((i-meu-1)^2 + (j-meu-1)^2) / B;
        gaussian_kernel(i,j) = A * exp(temp);
    end
end
gaussian_kernel = gaussian_kernel ./ sum(sum(gaussian_kernel));
img = conv2(img,gaussian_kernel,'same');

%% creating the descriptor for the feature vector
y1 = pattern(:,1);
x1 = pattern(:,2);
y2 = pattern(:,3);
x2 = pattern(:,4);
descriptor = zeros(size(feature,2),BRIEF_n);
pad_x = size(im_corner,1);
pad_y = size(im_corner,2);
for i = 1:length(feature)
    coord_x = feature(i,2) + pad_x;
    coord_y = feature(i,1) + pad_y;
    for j = 1:BRIEF_n
        if img(coord_y+y1(j),coord_x+x1(j))<img(coord_y+y2(j),coord_x+x2(j))
            descriptor(i,j) = 1;
        else
            descriptor(i,j) = 0;
        end
    end
end

end