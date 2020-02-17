function watermark = yeungMintzer_decode(watermarked_img, key)
rng(key);
watermarked_img = uint8(watermarked_img);

LUTvals = rand(1, 256) > 0.5;

watermark = LUTvals(watermarked_img+1);

end