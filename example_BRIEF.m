% this is  an example code to test the functions that I have implemented
% regarding my master's degree, here iI am testing the BRIEF descriptor
% with FAST_12 detector 

clc;  close all; clear all;

%% loading the vidoe to extract the images
video = VideoReader('rhinos.avi'); % here I put the name of the video
vidWidth = video.Width;
vidHeight = video.Height;
frame = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
i =1;
while hasFrame(video)
    frame(i).cdata = readFrame(video);
    i = i+1;
end
img11 = frame(10).cdata ; % choose the 1st frame to compare
if length(size(img11)) == 3
	img1 =  uint8(img11(:,:,2));
else
	img1 = uint8(img11);
   
end
img22 = frame(12).cdata; % choose the second frame to compare
if length(size(img22)) == 3
	img2 =  uint8(img22(:,:,2));
else
	img2 = uint8(img22);
end


%create a gaussian filter to smoothen the noisy data, un-comment the
%following lines if the pics are not noisy
% kernel = gaussian_kernel(0.7071); % this creates a kernel by taking only the variance
% img1 = uint8(conv2(img1,kernel,'same'));
% img2 = uint8(conv2(img2,kernel,'same'));

%% implementing FAST detector
tic
corners1 = FAST_12(img1,0.3); % using FAST_12 to detect features of 1st image
feature1 = FAST_non_max(img1,corners1,0.3); % suppress the non_maxima
toc
corners2 = FAST_12(img2,0.3); % using FAST_12 to detect features of 2nd image
feature2 = FAST_non_max(img2,corners2,0.3); % suppress the non_maxima

%% apply the matching function using the hamming distance
type = 'gaussian'; % the typeof the sampling pattern
BRIEF_n = 256;
window_size = 9;
pattern = sampling_generator(type,window_size,BRIEF_n);
descriptor1 = BRIEF_descriptor(img1 ,feature1 , pattern , window_size ,BRIEF_n);
descriptor2 = BRIEF_descriptor(img2 ,feature2 , pattern , window_size ,BRIEF_n);
[matching,dis,diss] = BRIEF_match(feature1, descriptor1, feature2, descriptor2);

%% showing the features detected in the two images 
% 1st image features
figure(1)
imshow(img11)
hold on 
plot(corners1(:,2),corners1(:,1), 'r.')
plot(feature1(:,2),feature1(:,1), 'g.')
title('the detected featuere of 1^s^t image')
legend('all detected features','maxima features')
% 2nd image features
figure(2)
imshow(img22)
hold on 
plot(corners2(:,2),corners2(:,1), 'r.')
plot(feature2(:,2),feature2(:,1), 'g.')
title('the detected featuere of 2^n^d image')
legend('all detected features','maxima features')
% the matched feature of both images
figure(3)
if size(feature1,1)>size(feature2,1)
    newImg = cat(2,img22,img11);
    imshow(newImg)
    hold on
    plot(feature2(:,2),feature2(:,1), 'g.')
    plot(feature1(:,2)+size(img2,2),feature1(:,1), 'r.')
    for i = 1:size(matching,1)
        plot([matching(i,2) matching(i,4)+size(img2,2)],[matching(i,1) matching(i,3)],'b')
    end
    title('the matched feature between the two images')
else
    newImg = cat(2,img11,img22);
    imshow(newImg)
    hold on
    plot(feature2(:,2)+size(img1,2),feature2(:,1), 'g.')
    plot(feature1(:,2),feature1(:,1), 'r.')
    for i = 1:size(matching,1)
        plot([matching(i,2)+size(img1,2) matching(i,4)],[matching(i,1) matching(i,3)],'b')
    end
    title('the matched feature between the two images')
end
% plotting some insights about the performance of the descriptor, it was
% the same as teh proposed in the published paper
figure(4) 
histfit(dis)
hold on
histfit(mean(diss))
title('distribution of the hamming distance of matched and unmtched features with mean');
% plotting the sampling pattern
figure(5)
hold on
plot(0,0,'y','MarkerSize',20)
plot(pattern(:,2),pattern(:,1),'r.','MarkerSize',10)
plot(pattern(:,4),pattern(:,3),'g.','MarkerSize',10)
for i = 1:BRIEF_n
    plot([pattern(i,1) pattern(i,3)],[pattern(i,2) pattern(i,4)],'k')
end
axis([-(window_size/2+1) window_size/2+1 -(window_size/2+1) window_size/2+1])
title('gaussian sampling pattern')

