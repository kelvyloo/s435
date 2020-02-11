function im = diyDecoder(im, Q)
    % Dequantize image with DCT coefficients
    dequant = @(block) Q .* block.data;
    im = blockproc(im, size(Q), dequant);

    % Compute the inverse DCT of the image
    invdct = @(block) idct2(block.data);
    im = blockproc(im, size(Q), invdct);
end