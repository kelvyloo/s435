function watermarked_img = yeungMintzer_encode(img, watermark, key)
% Implements the Yeung-Mintzer algorithm to embed a fragile watermark into
% a digital image
%
% img       - image to bed embed a watermark
% watermark - binary sequence to embed in img
% key       - seed to create look-up-table
[r1, c1] = size(img);
[r2, c2] = size(watermark);

if r1 ~= r2 || c1 ~= c2
    fprintf("Image and watermark need to be same size");
    return
end

rng(key);
img = uint8(img);
watermark = watermark./max(watermark);
LUTvals = rand(1, 256) > 0.5;

for i = 1:r1
    for j = 1:c2
        while LUTvals(img(i, j) + 1) ~= watermark(i, j)
            img(i, j) = img(i, j) + 1;
        end
    end
end

watermarked_img = img;

end

