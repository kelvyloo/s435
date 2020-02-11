function [len, im] = diyEncoder(im_in, Q)
    % Row count
    r = 1;
    
    % Block size
    S = 8;

    % Image dimensions
    [rowN, colN] = size(im_in);

    % Convert image to double
    im = double(im_in);

    % Compute the DCT of the image in pixel blocks of 8x8
    dct = @(block) dct2(block.data);
    im = blockproc(im, [S S], dct);

    % Quantize image with DCT coefficients
    quant = @(block) round(block.data ./ Q);
    im = blockproc(im, [S S], quant);

    % Reorder each block of quantized DCT coefficients
    imzigzag = ones(rowN * colN / S^2, S^2);
    for i = 1 : S : rowN
        for j = 1 : S : colN
            imzigzag(r, :) = ZigzagMtx2Vector(im(i : i+S-1, j : j+S-1));
            r = r + 1;
        end
    end

    % Entropy encoding
    len = JPEG_entropy_encode(rowN, colN, S, Q, imzigzag, '', 1);

    % Entropy decoding
    [rowN, colN, dct_block_size, iQ, iZZDCTQIm] = JPEG_entropy_decode('');
end