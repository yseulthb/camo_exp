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

sigma     = 15; % standard deviation of the Gaussian filter
w1_wn     = 1; % weight of the white noise
w2_gauss  = 26; % weight of the Gaussian filter
plotFlag  = 0; % show the plot: 1 yes; 0 no

% im_dim: 250*250; w1: 1; w2: 26; sigma: 6.5 => slope of approx -2
% im_dim: 450*450; w1: 1; w2: 26; sigma: 10.5 => slope of approx -2
% im_dim: 650*650; w1: 1; w2: 26; sigma: 15 => slope of approx -2
% im_dim: 650*650; w1: 1; w2: 26; sigma: 25 => slope of approx -1
% im_dim: 650*650; w1: 1; w2: 42; sigma: 65 => slope of approx -2.9

% Call the function to create a white noise image and alter its slope using
% a Gaussian filter. It returns the value of the Fourier slope of the modified
% white noise image and the reconstructed image matrix.

for ndx = 1:10
    cd('C:\Users\preinstalled\Documents\PostDoc_Doc\');
    [BKG_p, BKG_reconstructedImage ] = SloppyNoise(im_height, im_width, sigma, w1_wn, w2_gauss, plotFlag);
        
    % 2/ Target: Determine the inner content of the target
    % target size = background image size, then select a subset of the target image and
    % add it to the background image
    
    sigma     = 12; % standard deviation of the Gaussian filter
    w1_wn     = 1; % weight of the white noise
    w2_gauss  = 45; % weight of the Gaussian filter
    % im_dim: 650*650; w1: 1; w2: 22; sigma: 5 => slope of approx -1
    % im_dim: 650*650; w1: 1; w2: 65; sigma: 24 => slope of approx -2.9
    % im_dim: 650*650; w1: 1; w2: 45; sigma: 12 => slope of approx -2

    [target_p, target_reconstructedImage ] = SloppyNoise(im_height, im_width, sigma, w1_wn, w2_gauss, plotFlag);
        
    % Create a disk mask
    target_height = 20;
    target_width  = 20;
    
    [columnsInImage, rowsInImage] = meshgrid(1:im_height, 1:im_width);
    centerX = randi([0 im_height-target_height],1);
    centerY = randi([0 im_height-target_height],1);
    radius = target_height/2;
    disk_mask = (rowsInImage - centerY).^2 + (columnsInImage - centerX).^2 <= radius.^2;
    
    % 3/ Stimulus: Convert reconstructed images to grayscale images
    BKG_grayscImage = mat2gray(BKG_reconstructedImage);
    target_grayscImage = mat2gray(target_reconstructedImage);

%     figure, imshow(BKG_grayscImage)
%     figure, imshow(target_grayscImage)
    
%     Stimulus_Image = BKG_grayscImage;
%     Stimulus_Image(disk_mask) = target_grayscImage(disk_mask);
    
    % Assemble both background and target images to build the stimulus
    Stimulus_Image = BKG_reconstructedImage;
    Stimulus_Image(disk_mask) = target_reconstructedImage(disk_mask);
%     figure,
%     imshow(Stimulus_Image)
    Stimulus_Image_grayscImage = mat2gray(Stimulus_Image);
    
    close all

    figure,
    img = imshow(Stimulus_Image_grayscImage);
    
    
    cd('C:\Users\preinstalled\Documents\PostDoc_Doc\figures\');
    %saveas(img, 'Fig-2BKG-1target.tif')
    
    saveas(img, sprintf('Fig-2BKG-2target%d.png',ndx));
    
    close all
end





%%

% % if targets are circles
% X = randi([0 im_height],1);
% Y = randi([0 im_height],1);
% CentreCoord = [X Y];
% radius = 10;
% circulo = viscircles(CentreCoord, radius, 'EnhanceVisibility', false, 'Color',[0.5 0.5 0.5], 'LineWidth', 0.5);
% xd = circulo.Children(1).XData(1:end-1); %leave out the nan
% yd = circulo.Children(1).YData(1:end-1);
% hold on
% fill(xd, yd, [0.5 0.5 0.5], 'EdgeColor',[.5 .5 .5]);


%
% PSD is simply the amplitude of FFT squared and divided by the FFT bin width deltaF.
% If a window function isa applied then
% PSD(fk) = |X(fk)|^2 / (Window BW x deltaF)

% 2D fft example
% P = peaks(20);
% X = repmat(P,[5 10]);
% imagesc(X)
% Y = fft2(X);
% imagesc(abs(fftshift(Y)))

% img = imread('dancing.jpg');
% [im_height, im_width] = size(img);
% imshow(img)

% Compute its 2D-fft + power spectrum
% normalise + shift zero-frequency component to center of spectrum
% imgf      = fftshift(fft2(img));
% imgfp     = (abs(imgf)/(im_height*im_width)).^2;
% img_phase = angle(imgf);
% imagesc(imgfp)

% % Plot radially averaged power spectral density (PSD)
% res          = round(im_widtht/2); % res = spatial resolution ofr the PSD plot
% [logX, logY] = radialPsd2d(img(:,:,1),res, 0); % compute the PSD plot
% p            = polyfit(logX, logY, 1); % compute the Fourier slope
