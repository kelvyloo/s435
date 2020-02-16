function new_img = mergeNBitPlanes(img, replace_img, N)
% Gets the N MSB planes from replace_img and sets those same bit planes
% on img
%
% img         - img to replace N LSB planes
% replace_img - img to get N MSB planes
% N           - N layers of bit planes to get
img = uint8(img);
replace_img = uint8(replace_img);

% Get N MSB planes from replace_img and set those bit planes on img
for i = 7-N:7
    bp = getBitPlane(replace_img, i);
    img = bitset(img, 8-i, bp);
end

new_img = uint8(img);

end