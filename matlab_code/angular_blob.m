function bw = angular_blob(centerX, centerY, im_height,im_width)
% angular_blob: Creates a mask for an angular blob shape 
%
%  Parameters of the function:
%      im_height and im_width: dimension of the mask image
%      centerX, centerY: determines the centre of the blob patch

k    = round(rand(1,50)*10)+25;
Th   = linspace(0,2*pi,50);
k    = [k  k(1)];
Th   = [Th  Th(1)];
[x, y] = pol2cart(Th, k);

Xint = round(x) + centerX;
Yint = round(y) + centerY;
bw   = poly2mask(Xint,Yint,im_height,im_width);

% imshow(bw)
% kbis = mean(k) * ones(1, size(k,2));

% figure
% hold on
% polar(Th,k, 'b')
% polar(Th, kbis, 'r')
% hold off

% Xint = round(x) + abs(min(round(x)));
% Yint = round(y) + abs(min(round(y)));

% figure,
% h = fill(Xint, Yint, 'r');

% bw = poly2mask(Xint,Yint,100,100);