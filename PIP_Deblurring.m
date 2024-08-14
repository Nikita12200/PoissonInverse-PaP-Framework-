image = imread('cameraman256.png');
% Get the size of the image
[height, width, ~] = size(image); 
sigma1=1.6;
[blurred_image,H] = gaussian_kernel(image,sigma1);
disp(size(H));
noisy_image = poisson_contaminated_image(blurred_image);

beta = 1;
lambda = 0.25;
sigma2 = sqrt(beta/lambda);
reconstructed_image = PIP_reconstruction(noisy_image, lambda, sigma2, H);
figure; 
snr = calculate_snr(image, noisy_image);
subplot(1, 3, 1);
imshow(image, []);
title('Clean Image');
subplot(1, 3, 2);
imshow(noisy_image,[]);
title(['Noisy Image with SNR = ', num2str(snr), 'dB']); 
subplot(1, 3, 3);
imshow(reconstructed_image, []);
title('Reconstructed Image')

function reconstructed_image = PIP_reconstruction(y, lambda, sigma,H)
    lr=0.1;
    [h, w] = size(y);
    y = double(y);
    x = double(zeros(h, w));
    u = double(zeros(h, w));
    v = double(ones(h, w))*(4*(sqrt(3/8)+1));
    i = double(ones(h, w));
    for i=1:10
        L= (-1)*H.'*(y./(H*x)) + H'*(ones(size(H, 1), 1)) + lambda*(x-v+u);
        x = x + lr*L;
        v = BM3D(x+u, sigma);
        u = u + (x - v);
    end
    reconstructed_image = x;
end
function [Y,H] = gaussian_kernel(x,sigma)
    [n,m]=size(x);
    disp('gaussian kernel function');
    h = zeros(n,m);
    ans=0;
    for x=1:n
        for y=1:m
            h(x,y) = exp(-((x-n/2)^2+(y-m/2)^2)/(2*sigma^2));
            ans = ans + h(x,y);
        
        end
    end
    for x=1:n
        for y=1:m
            h(x,y) = h(x,y)/ans;
        end
    end
    disp(ans);
    k = conv2(im2double(x), h, 'same');
    H=h;
    Y=k;
end