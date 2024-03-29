# camo_exp
### Background-matching stimuli 
Stimuli = white noise x Gaussian filter <br>
Made of two parts: a background and a target. The location of the target is randomised across the background space (solo condition) or centred (2-AFC conditions). Once both parts are assembled, the resulting image is grayscaled (conversion to an intensity image). 

Image size: 650 x 650 (solo condition) or 650 x 1300 (2-AFC conditions)<br>
Target size: 160 x 160

Shape of the target: circles

Fourier slope for the backgrounds: -1; -2; -3 <br>
Fourier slope for the targets: -0.5; -1.5; -2.5; -3.5 <br>
Slope difference (background - target): +/- 0.25, +/- 0.5, +/- 0.75


Edges are blurred to limit edge effect via a Gaussian filter. Standard deviation of the kernel: 0.5

For the 2-AFC condition with a noisy background, two circles were added to highlight the location of the target. The linewidth of those circles is 1.5 and the pixel intensity of the gray colour is 64.

Simuli have the same mean luminance value (pixel intensity): 128 (+/-32) <br>
(cf the lumMatch function from the Matlab's SHINE toolbox (Willenbockel et al., 2010))
