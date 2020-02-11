function v = gamma_correction(u, gamma)
% Gamma correction of an image for a grayscale image
% using v = 255 * (u/255)^gamma
    v = 255 * (u/255).^gamma;
end
