# camo_exp
### Background-matching stimuli 
Stimuli = white noise x Gaussian filter <br>
Made of two parts: a background and a target. The location of the target is randomised across the background space. Once both parts are assembled, the resulting image is grayscaled (conversion to an intensity image). 

Two types of configurations: one image or two images next to each other (with or without a separation, with an identical background)

Fourier slope of backgrounds: -1; -2; -3 <br>
Fourier slope of targets: -0.5; -0.75; -1; -1.25; -1.5; -1.75; -2; -2.25; -2.5; -2.75; -3; -3.25

Size of images: 650 x 650 or 650 x 1300 (if two images together)<br>
Size of targets: 60 x 60 ; 90 x 90 (earlier versions also included: 20 x 20 ; 40 x 40)

Shape of the target: circles or angular blobs or round blobs
Edges are blurred to limit edge effect via a Gaussian filter. Standard deviation of the kernel: 0.5; 1 ; 1.5; 2