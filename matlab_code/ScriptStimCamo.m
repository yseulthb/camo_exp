%%% Script Camouflaged Stimuli %%%
%
% Background-matching stimuli
% Change of the Fourier slope (-2 for natural scenes) to manipulate the
% degree of background-matching
%
% 1/ Detection task
% Stim: white noise filtered by different Fourier slopes // different
% levels of granularity // else see with I. Cuthill
%
% 2/ Preference task: highlight the stimulus contour to make it conspicuous
% w.r.t. its background - contour might take the shape of a familiar
% object/animal or be abstract
%%%
%%
clc, clear all, close all

%% 1/ Background: Create a white noise image and alter its Fourier slope (ideally, a slope of -2)
% Define the function parameters
im_height = 650;
im_width  = 650;
plotFlag  = 0; % show the plot: 1 yes; 0 no

sigma_BKG     = 65; % standard deviation of the Gaussian filter
w1_wn_BKG     = 1; % weight of the white noise (remains unchanged)
w2_gauss_BKG  = 42; % weight of the Gaussian filter

% im_dim: 650*650; sigma: 5;  w2: 26 => slope of approx -1
% im_dim: 650*650; sigma: 15; w2: 26 => slope of approx -2
% im_dim: 650*650; sigma: 65; w2: 42 => slope of approx -2.9


% 2/ Target: Determine the inner content of the target
% target size = background image size, then select a subset of the target image and
% add it to the background image

sigma_tar     = 12; % standard deviation of the Gaussian filter
w1_wn_tar     = 1; % weight of the white noise (remains unchanged)
w2_gauss_tar  = 45; % weight of the Gaussian filter
% im_dim: 650*650; sigma: 5;  w2: 22 => slope of approx -1
% im_dim: 650*650; sigma: 7.2; w2: 45 => slope of approx -1.5
% im_dim: 650*650; sigma: 12; w2: 45 => slope of approx -2
% im_dim: 650*650; sigma: 20; w2: 45 => slope of approx -2.5
% im_dim: 650*650; sigma: 24; w2: 65 => slope of approx -2.9

% Create a disk mask
target_height = 60;
target_width  = 60;

% Select the target shape: 'disk' or 'ang_blob' or 'round_blob'
target_shape = 'ang_blob';

%% Call the function to create a white noise image and alter its slope using
% a Gaussian filter. It returns the value of the Fourier slope of the modified
% white noise image and the reconstructed image matrix.

for ndx = 1:5
    cd('yourfolder\');
    
    [BKG_p, BKG_reconstructedImage ]       = SloppyNoise(im_height, im_width, sigma_BKG, w1_wn_BKG, w2_gauss_BKG, plotFlag);
    [target_p, target_reconstructedImage ] = SloppyNoise(im_height, im_width, sigma_tar, w1_wn_tar, w2_gauss_tar, plotFlag);
    
    [columnsInImage, rowsInImage] = meshgrid(1:im_height, 1:im_width);
    centerX = randi([0+target_height im_height-target_height],1);
    centerY = randi([0+target_height im_height-target_height],1);
    radius = target_height/2;
    
    if strcmp(target_shape, 'disk')
        disk_mask = (rowsInImage - centerY).^2 + (columnsInImage - centerX).^2 <= radius.^2; % x^2+y^2=r^2
    elseif strcmp(target_shape, 'ang_blob')
        bw = angular_blob(centerX, centerY, im_height,im_width);
        disk_mask = bw;
    elseif strcmp(target_shape, 'round_blob')
        blob_mask = round_blob(centerX, centerY, im_height, im_width);
        disk_mask = blob_mask;
    else
        fprintf('ERROR: Please specify the target shape.')
    end

    % SMOOTHING
    filter_img            = zeros(im_height);
    filter_img(disk_mask) = 1;
    Target_filter      = imgaussfilt(filter_img, 2); % 2.5
    Target_filter      = Target_filter - min(min(Target_filter)); 
    Target_filter      = Target_filter./ ( max(max(Target_filter))); % Gaussian filter

    BKG_filter            = - Target_filter +1 ;
    
    Stimulus_Image = BKG_reconstructedImage.* BKG_filter;
    Stimulus_Image_sum = BKG_reconstructedImage .* BKG_filter + target_reconstructedImage .* Target_filter;
    StimGS = mat2gray(Stimulus_Image_sum); 
    figure, 
    img = imshow(StimGS);


    % 3/ Stimulus: Convert reconstructed images to grayscale images
    %BKG_grayscImage    = mat2gray(BKG_reconstructedImage);
    %target_grayscImage = mat2gray(target_reconstructedImage);
    
    % Assemble both background and target images to build the stimulus
    %Stimulus_Image = BKG_reconstructedImage;
    %Stimulus_Image(disk_mask) = target_reconstructedImage(disk_mask);
    %Stimulus_Image_grayscImage = mat2gray(Stimulus_Image);
        
    %figure,
    %img = imshow(Stimulus_Image_grayscImage);
    
    cd('yourfolder\figures\');
    saveas(img, sprintf('Fig-XBKG-Xtarget_sizeX_ang_blob_%d.png',ndx));
    
    close
end
