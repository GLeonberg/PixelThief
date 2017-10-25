clc;
clear;

name = input('Please enter the file name of the image: ', 's');
im = imread(name);
new = zeros(size(im));
dims = size(im);

for row = 1:dims(1)
   for col = 1:dims(2)
          origR = im(row, col, 1);
          origG = im(row, col, 2);
          origB = im(row, col, 3);
          
          newR = floor(origR / (2.^5));
          newR = double(newR) / (2.0.^3);
          %R = aR * 255;
          
          newG = floor(origG / (2.^5));
          newG = double(newG) / (2.0.^3);
          %G = aG * 255;
          
          newB = floor(origB / (2.^6));
          newB = double(newB) / (2.0.^2);
          %B = aB * 255;
          
          %input('test')
          
          new(row, col, 1) = newR;
          new(row, col, 2) = newG;
          new(row, col, 3) = newB;
   end
end

figure();
image(im);
figure();
image(new);


