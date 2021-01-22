function blob_mask = round_blob(centerX, centerY, im_height, im_width)
% Draw some sorts of round blobs
N = 6;
radius  = randi([10,12],N,1);
theta = 0 : 0.01 : 2*pi;

figure,
hold on
rand_shift_X = randi([5,25],N,1);
rand_shift_Y = randi([5,25],N,1);
for i = 1:N
    x = radius(i) * cos(theta) + centerX + rand_shift_X(i);
    y = radius(i) * sin(theta) + centerY + rand_shift_Y(i);
    plot(x, y);
    axis square;
    xlim([0 650]);
    ylim([0 650]);
    bwr(:,:,i) = poly2mask(x,y,im_height,im_width);
end
close all

bwr_all = sum(bwr, 3);
blob_mask = (bwr_all>=1);

% figure,
% imshow(blob_mask)
