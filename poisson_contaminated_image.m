function noisy_image = poisson_contaminated_image(clean_image, peak)
    % Convert clean image to double
    clean_image = double(clean_image);
    
    % Generate Poisson noise for each pixel
    [rows, cols] = size(clean_image);
    noisy_image = zeros(rows, cols);
    for i = 1:rows
        for j = 1:cols
            % Probability of getting noisy value y[i] given clean value x[i]
            if clean_image(i, j) > 0
                noisy_image(i, j) = poissrnd(peak*clean_image(i, j));
            else
                noisy_image(i, j) = 0; % Set to 0 for x[i] = 0
            end
        end
    end
end


