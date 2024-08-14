
image = imread("cameraman256.png");  

noisy_image = poisson_contaminated_image(image);

figure;
subplot(1,2,1);
imshow(image, []);
title("Clean Image");

subplot(1,2,2);
imshow(noisy_image,[]);
title("Noisy Image");

diff = double(image)- noisy_image; 
