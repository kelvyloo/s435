function [k] = blockDetect(image)
    % Implementation of the Fan and de Quieroz's JPEG blocking artifact
    % detecting algorithm. Function takes an image as an input and outputs
    % the blocking srrength, k.
    Zp = []; % Z prime
    Zpp=[]; % Z pouble prime
    [row, col]=size(image); % Pixel row and col dimensions

    % 1. For each 8 x 8 pixel block in the image, calculate the values
    for i = 1:8:row-8
        for j = 1:8:col-8
            grid = image(i:i+7, j:j+7);
            A = grid(4, 4);
            B = grid(4, 5);
            C = grid(5, 4);
            D = grid(5, 5);
            E = grid(8, 8);
            F = image(i+7, j+8);
            G = image(i+8, j+7);
            H = image(i+8, j+8);

            Zp = [Zp, double(abs(A-B-C+D))]; 
            Zpp = [Zpp, double(abs(E-F-G+H))]; 
        end
    end

    % 2. Calculate the normalized histogram HI (n) of Z0 values and the
    % normalized histogram HII (n) of the Z00 values.
    figure
    HI = histogram(Zp, 255);
    HI.Normalization = 'probability';
    hold on
    HII = histogram(Zpp, 255);
    HII.Normalization = 'probability';
    legend('HI - Center values','HII - Edge values');

    % 3. Measure the strength K of the blocking fingerprints using the equation
    k = sum(abs(HI.Values - HII.Values));

    % 4. Determine if the image was previously JPEG compressed by comparing
    % the blocking fingerprint strength to a detection threshold n. The
    % algorithm detects evidence of JPEG compression if K > n and classifies
    % the image as never compressed if K < n.
    n = 0.25; % Detection threshold
    detection = (k>n);
    fprintf('The blocking fingerprint strength is %d.\n', k);
    if detection == 1
        fprintf('The image is JPEG compressed \n');
    else
        fprintf('The image isn''t JPEG compressed \n');
    end
end