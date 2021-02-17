function pattern = sampling_generator(type,window_size,BRIEF_n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%sampling_generator is a function that generates the coordinates of the
%pixels to be compared in BRIEF deacriptor
% pattern = sampling_generator(type,window_size,BRIEF_n)
%   inputs:
%       type: a string that describes the sampling type, it can be
%       'uniform', 'gaussian' or 'local_gaussian'
%       window_size: an odd number that describes the window in which the
%       points will be choosen
%       BRIEF_n: the number of sample comparisons, can be 128 or 256
%   output:
%       pattern: an n-by-4 matrix that holds the coordinates of the pairs 
%       to be compared
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x1 = zeros(BRIEF_n,1);
    x2 = zeros(BRIEF_n,1);
    y1 = zeros(BRIEF_n,1);
    y2 = zeros(BRIEF_n,1);
    
if strcmp(type,'uniform') % the randomly uniform sampling
    x1 = floor(window_size*rand(BRIEF_n,1)-floor(window_size/2));
    y1 = floor(window_size*rand(BRIEF_n,1)-floor(window_size/2));
    x2 = floor(window_size*rand(BRIEF_n,1)-floor(window_size/2));
    y2 = floor(window_size*rand(BRIEF_n,1)-floor(window_size/2));
    
elseif strcmp(type,'gaussian_local') % gaussian pattern for both x,y but y is dependent on x
    for i = 1:BRIEF_n
        x1(i) = floor(normrnd(0,0.04*window_size^2));
        while x1(i)>floor(window_size/2) || x1(i)<ceil(-window_size/2)
             x1(i) = floor(normrnd(0,0.04*window_size^2));
        end
        x2(i) = floor(normrnd(x1(i),0.01*window_size^2));
        while x2(i)>floor(window_size/2) || x2(i)<ceil(-window_size/2)
             x2(i) = floor(normrnd(x1(i),0.01*window_size^2));
        end
        y1(i) = floor(normrnd(0,0.04*window_size^2));
        while y1(i)>floor(window_size/2) || y1(i)<ceil(-window_size/2)
             y1(i) = floor(normrnd(0,0.04*window_size^2));
        end
        y2(i) = floor(normrnd(y1(i),0.01*window_size^2));
        while y2(i)>floor(window_size/2) || y2(i)<ceil(-window_size/2)
             y2(i) = floor(normrnd(y1(i),0.01*window_size^2));
        end
    end   
    
elseif strcmp(type,'gaussian') % gaussian pattern for both x,y , both are independent 
    for i = 1:BRIEF_n
        x1(i) = floor(normrnd(0,0.04*window_size^2));
        while x1(i)>floor(window_size/2) || x1(i)<ceil(-window_size/2)
             x1(i) = floor(normrnd(0,0.04*window_size^2));
        end
        x2(i) = floor(normrnd(0,0.04*window_size^2));
        while x2(i)>floor(window_size/2) || x2(i)<ceil(-window_size/2)
             x2(i) = floor(normrnd(0,0.04*window_size^2));
        end
        y1(i) = floor(normrnd(0,0.04*window_size^2));
        while y1(i)>floor(window_size/2) || y1(i)<ceil(-window_size/2)
             y1(i) = floor(normrnd(0,0.04*window_size^2));
        end
        y2(i) = floor(normrnd(0,0.04*window_size^2));
        while y2(i)>floor(window_size/2) || y2(i)<ceil(-window_size/2)
             y2(i) = floor(normrnd(0,0.04*window_size^2));
        end
    end   
end
pattern = [y1 x1 y2 x2];
end