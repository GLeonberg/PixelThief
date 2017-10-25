cs = zeros(1, 255, 3);
curr = 1;

for r = 0:7
    for g = 0:7
        for b = 0:3
            red = r*(2.^5) / 256;
            green = g*(2.^5) / 256;
            blue = b*(2.^6) / 256;
            
            cs(1, curr, 1) = red;
            cs(1, curr, 2) = green;
            cs(1, curr, 3) = blue;
            
            curr = curr + 1;
        end
    end
end

cs = reshape(cs, [16, 16, 3]);
image(cs);