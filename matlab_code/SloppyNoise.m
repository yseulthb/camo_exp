function [p, img] = SloppyNoise(im_height, im_width, sigma, w1, w2, plotFlag)
%SloppyNoise: Create a white noise image and modify its Fourier slope
%
%  Parameters of the function:
%       im_height and im_width: dimension of the white noise image
%       sigma: standard deviation of the Gaussian filter
%       w1 and w2: weight of the white noise and of the Gaussian, resp.
%       plotFlag: if 0, then no plot shown, if 1, shows the plots
%

whiteNoiseImage = randn(im_height, im_width); % create a white noise image
wn2Dfft         = fft2(whiteNoiseImage);      % compute its 2D FFT
modCentered     = abs(fftshift(wn2Dfft));     % shift zero-frequency component to center of spectrum
angleCentered   = angle(fftshift(wn2Dfft));   % extract the phase

%m = size of the Gaussian lowpass filter
m = round(im_height / 17);
    if rem(m,2)==0
        m = m+1; % m has to be odd
    end

coreGauss       = fspecial('gaussian', [(m*2)+1 (m*2)+1], sigma); % Gaussian filter

modCentered     = modCentered./max(max(modCentered)); % normalise
coreGauss       = coreGauss./max(max(coreGauss));     % normalise

% w1 = 1; % weight of the white noise
% w2 = 1; % weight of the Gaussian filter

% Add the Gaussian filter to the white noise image
addMatrix      = zeros(size(modCentered));                % create a matrix with size of the white noise image
addMatrix( round(size(modCentered,1)/2)-m : round(size(modCentered,1)/2)+m, round(size(modCentered,2)/2)-m : round(size(modCentered,2)/2)+m ) = coreGauss;
modCentered    = (w1*modCentered + w2*addMatrix)/(w1+w2); % give +/- weight to the Gaussian filter
modCentered    = modCentered./max(max(modCentered));      % normalise

reconstructedImageComplex = ifftshift( modCentered.*cos(angleCentered) + 1i .* modCentered.*sin(angleCentered) );
reconstructedImage        = real(ifft2(reconstructedImageComplex)); % only keep the real part


whiteNoiseImage    = whiteNoiseImage./max(max(whiteNoiseImage));       % normalise
reconstructedImage = reconstructedImage./max(max(reconstructedImage)); % normalise

if plotFlag
    figure
    subplot(2,2,1)
    imagesc(whiteNoiseImage)
    colorbar
    title('White noise image')
    subplot(2,2,2)
    imagesc(modCentered)
    colorbar
    title('Power spectrum: WN + Gauss')
    subplot(2,2,3)
    imagesc(reconstructedImage)
    colorbar
    title('Reconstructed image')
    subplot(2,2,4)
    imagesc(whiteNoiseImage - reconstructedImage)
    colorbar
    title('White noise - reconstructed image')
end

SlopePlotFlag = plotFlag;
[logX, logY] = radialPsd2d(reconstructedImage, size(reconstructedImage,2)/2, SlopePlotFlag);

logX(isnan(logX))=[];
logY(isnan(logX))=[];
logX(isnan(logY))=[];
logY(isnan(logY))=[];

p    = polyfit(logX, logY,1);
p(1) = p(1)*-1;
img  = reconstructedImage;
