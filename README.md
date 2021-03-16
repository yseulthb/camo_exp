# camo_exp
### Background-matching stimuli 
Stimuli = white noise x Gaussian filter <br>
Made of two parts: a background and a target. The location of the target is randomised across the background space (solo condition) or centred (2-AFC conditions). Once both parts are assembled, the resulting image is grayscaled (conversion to an intensity image). 

Image size: 650 x 650 (solo condition) or 650 x 1300 (2-AFC conditions)<br>
Target size: 90 x 90 or 120 x 120

Shape of the target: circles

Fourier slope for the backgrounds: -1; -2; -3 <br>
Fourier slope for the targets: -0.5; -1.5; -2.5; -3.5
<!--Fourier slope of targets: -0.5; -0.75; -1; -1.25; -1.5; -1.75; -2; -2.25; -2.5; -2.75; -3; -3.25-->

Edges are blurred to limit edge effect via a Gaussian filter. Standard deviation of the kernel: 1 or 1.5
Images with no blur are also available.

Simuli have the same mean luminance value (pixel intensity): 128 (+/-32) - similar to the lumMatch function from the Matlab's SHINE toolbox (Willenbockel et al., 2010)