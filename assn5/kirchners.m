function p_map = kirchners(img, lambda, tau, omega)
% Uses Kirchner's Algorithm to calculate an image's p-map
alpha_star = [-0.25, 0.50, -0.25; ...
               0.50, 0.00,  0.50; ...
              -0.25, 0.50, -0.25];

img_hat = filter2(alpha_star, img);
err = img - img_hat;
p_map = lambda * exp(-err.^tau/omega);
end