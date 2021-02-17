function [match_pairs,min_distance,distance] = BRIEF_match(feature1 ,descriptor1 ,feature2 ,descriptor2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%BRIEF_match this function takes the features descriptor matrix of two
%different images and then matches the possible similar matches together
%[match_pairs,min_distance,distance] = BRIEF_match(feature1 ,descriptor1 ,feature2 ,descriptor2)
%   inputs:
%       feature1,2: a n-by-2 matrix that holds the coordinates of the
%       features in the images
%       descriptor1,2: an n-by-m matrix that holds the descriptor array
%       corresponding to each feature
%   outputs:
%       match_pairs: an l-by-4 matrix that has the coordiantes of the
%       matched pairs together, the 1st two columns hold the coordinates
%       of the feature in 1st image and the 2nd two columns hold
%       coordinates of the matched feature
%       min_distance: an array that holds the distance of the corresponding
%       matched pairs
%       distance: an m-by-n matrix that has all the distances obtained by
%       the algorithm among all the features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
desc_length_1 = size(descriptor1,1);
desc_length_2 = size(descriptor2,1);


if (desc_length_1>desc_length_2)
    small = descriptor2;
    f_small = feature2;
    large = descriptor1;
    f_large = feature1;
elseif (desc_length_1<=desc_length_2)
    small = descriptor1;
    f_small = feature1;
    large = descriptor2;    
    f_large = feature2;
end

distance = zeros(size(large,1),size(small,1));
match_pairs = zeros(size(large,1),4);
min_distance = zeros(size(large,1),1);
for i = 1:size(large,1)
    for j = 1:size(small,1)
        distance(i,j) = hamming_distance(large(i,:),small(j,:));
    end
    [min_distance(i),index] = min(distance(i,:));
    match_pairs(i,:) = [f_large(i,1) f_large(i,2) f_small(index,1) f_small(index,2)];
    
end
end