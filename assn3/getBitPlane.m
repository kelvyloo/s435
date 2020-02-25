function bitPlane = getBitPlane(img, bitPlaneIndex)
% Get the specified bit plane from an image
%
% img           - imread image
% bitPlaneIndex - index of bit plane user wants from 0 (LSB) to 7 (MSB)
%
% Convert img to uint8 then AND with bitmask then shift
%
img = uint8(img);

bitMask = bitshift(1, bitPlaneIndex);
bitPlane = bitand(img, bitMask);
bitPlane = bitshift(bitPlane, 7-bitPlaneIndex);
bitPlane = uint8(bitPlane);

end