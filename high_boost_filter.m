function high_boost_img = high_boost_filter(img, alpha)
% High-boost filtering of an image using the Laplacian filter
laplacian_filter = [0, -0.25, 0; ...
                    -0.25, 1, -0.25; ...
                    0, -0.25, 0];
                
laplacian_filter = alpha * laplacian_filter;

high_boost = filter2(laplacian_filter, img);
high_boost_img = img + high_boost;

end

