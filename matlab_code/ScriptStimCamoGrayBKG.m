% Stim camo + gray background

clear all, close all, clc
%% 1/ Background
% Define the function parameters
im_height = 650;
im_width  = 650;
plotFlag = 0;

sigma_BKG     = 24; % standard deviation of the Gaussian filter
w2_gauss_BKG  = 65; % weight of the Gaussian filters
w1_wn_BKG     = 1;  % weight of the white noise (remains unchanged)

% 2/ Target: Determine the inner content of the target
% target size = background image size, then select a subset of the target image and
% add it to the background image

sigma_tar1     = 20; % standard deviation of the Gaussian filter
w2_gauss_tar1  = 45; % weight of the Gaussian filter
sigma_tar2     = 12; % standard deviation of the Gaussian filter
w2_gauss_tar2  = 45; % weight of the Gaussian filter
w1_wn_tar      = 1;  % weight of the white noise (remains unchanged)
% im_dim: 650*650; sigma: 2; w2: 18 => slope of approx -0.5
% im_dim: 650*650; sigma: 3.5; w2: 20 => slope of approx -0.75
% im_dim: 650*650; sigma: 5; w2: 22 => slope of approx -1
% im_dim: 650*650; sigma: 6.45; w2: 30 => slope of approx -1.25
% im_dim: 650*650; sigma: 7.2; w2: 45 => slope of approx -1.5
% im_dim: 650*650; sigma: 9.2; w2: 45 => slope of approx -1.75
% im_dim: 650*650; sigma: 12; w2: 45 => slope of approx -2
% im_dim: 650*650; sigma: 20; w2: 45 => slope of approx -2.5
% im_dim: 650*650; sigma: 20; w2: 65 => slope of approx -2.75
% im_dim: 650*650; sigma: 24; w2: 65 => slope of approx -3
% im_dim: 650*650; sigma: 65; w2: 74 => slope of approx -3.25

% Create a disk mask
target_height = 90; %60
target_width  = 90; %60

% Select the background mode: matching (gaussian noise) or neutral (gray)
background_mode = 'BK_matching'; % 'BK_matching' // 'gray'

%% Call the function to create a white noise image and alter its slope using
% a Gaussian filter. It returns the value of the Fourier slope of the modified
% white noise image and the reconstructed image matrix.

% with or without smoothing? we want the stim to be comparable to the
% detection task stim, so we should consider keeping the smoothing option

for ndx = 1:5
    cd('C:\Users\preinstalled\Documents\PostDoc_Doc\');
    [BKG_p, BKG_reconstructedImage ]         = SloppyNoise(im_height, im_width, sigma_BKG,  w1_wn_BKG, w2_gauss_BKG, plotFlag);
    [target1_p, target1_reconstructedImage ] = SloppyNoise(im_height, im_width, sigma_tar1, w1_wn_tar, w2_gauss_tar1, plotFlag);
    [target2_p, target2_reconstructedImage ] = SloppyNoise(im_height, im_width, sigma_tar2, w1_wn_tar, w2_gauss_tar2, plotFlag);
    
    [columnsInImage, rowsInImage] = meshgrid(1:im_height, 1:im_width);
    %     centerX1 = randi([0+target_height im_height-target_height],1);
    %     centerY1 = randi([0+target_height im_height-target_height],1);
    %     centerX2 = randi([0+target_height im_height-target_height],1);
    %     centerY2 = randi([0+target_height im_height-target_height],1);
    center = im_height/2;
    radius = target_height/2;
    disk_mask = (rowsInImage - center).^2 + (columnsInImage - center).^2 <= radius.^2; % x^2+y^2=r^2
    bigger_disk_mask = (rowsInImage - center).^2 + (columnsInImage - center).^2 <= 1.1*radius.^2;
    %     disk_mask1 = (rowsInImage - centerY1).^2 + (columnsInImage - centerX1).^2 <= radius.^2; % x^2+y^2=r^2
    %     disk_mask2 = (rowsInImage - centerY2).^2 + (columnsInImage - centerX2).^2 <= radius.^2; % x^2+y^2=r^2
    %     %     imshow(disk_mask2)
    
    % IF SMOOTHING
    smooth_val = 1.5; % 0.5 / 1 / 1.5
    if strcmp(background_mode, 'gray')
        mega_disk = [disk_mask disk_mask];
        filter_img            = zeros(im_height, im_height*2);
        filter_img(mega_disk) = 1;
        Target_filter         = imgaussfilt(filter_img, smooth_val); 
        Target_filter         = Target_filter - min(min(Target_filter));
        Target_filter         = Target_filter./ ( max(max(Target_filter))); % Gaussian filter
        BKG_filter            = - Target_filter +1 ;
        StimGS = mat2gray( [target1_reconstructedImage target2_reconstructedImage] .* Target_filter );
        
    elseif strcmp(background_mode, 'BK_matching')
            filter_img            = zeros(im_height, im_height);
            filter_img(disk_mask) = 1;
            Target_filter         = imgaussfilt(filter_img, smooth_val);
            Target_filter         = Target_filter - min(min(Target_filter));
            Target_filter         = Target_filter./ ( max(max(Target_filter))); % Gaussian filter
            
%             dilated_target        = imdilate(Target_filter, strel('disk',0,0));
%             dilated_target(dilated_target == 1) = 0;
%             dilated_target(dilated_target >0 ) = 1;

            BKG_filter            = - Target_filter +1 ;
            contour = (bigger_disk_mask - disk_mask);
%             BKG_filter(BKG_filter>0) = 1;
%             BKG_filter(BKG_filter <1) = -1;
            Stimulus_Image_sum = [ ( BKG_reconstructedImage .* BKG_filter + target1_reconstructedImage .* Target_filter + contour*0.25) (BKG_reconstructedImage .* BKG_filter + target2_reconstructedImage .* Target_filter + contour*0.25)];
            StimGS = mat2gray(Stimulus_Image_sum);
            
%             combo_BKG_filter = [BKG_filter BKG_filter];
%             StimGS(combo_BKG_filter <1) = 0;
            % ADD: target contour
    end
        
                
        figure,
        img = imshow(StimGS);
        
        cd('C:\Users\preinstalled\Documents\PostDoc_Doc\figures\\2AFC_noisyBKG\');
        saveas(img, sprintf('Fig-3BKG-2-5vs-2target_biggersize_disk_blurryEdges1-5_contour_%d.png',ndx));
        
        close
        
end
    
%%
        
% Stimulus_Image = 0.5 * ones(im_height, im_height*2) .* BKG_filter;
% Stimulus_Image_sum = BKG_reconstructedImage .* BKG_filter + target1_reconstructedImage .* Target_filter;
% Stimulus_Image_sum = (0.5 * ones(im_height, im_height*2)) .* BKG_filter + mat2gray( [target1_reconstructedImage target2_reconstructedImage] .* Target_filter );
% Stimulus_Image_sum = (0.5 * ones(im_height, im_height)) .* BKG_filter + mat2gray( target1_reconstructedImage .* Target_filter );
% StimGS = mat2gray(Stimulus_Image_sum);
