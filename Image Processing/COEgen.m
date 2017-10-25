%inpath = input('Please enter the path to the sprites folder: ', 's');
outpath = input('Please enter the name of the output file: ', 's');

% open coe output file and write header
cd C:\Users\Gregory\Desktop
coe = fopen(outpath, 'w');
fprintf(coe, 'MEMORY_INITIALIZATION_RADIX=2;\n');
fprintf(coe, 'MEMORY_INITIALIZATION_VECTOR=\n');

%cd inpath;
cd C:\Users\Gregory\Desktop\icons
images = dir('*.png')
num_files = length(images);

mem = [];

for i = 1:num_files
    im = imread(images(i).name);
    dims = size(im);

    new = zeros(size(im));
    
    for row = 1:dims(1)
        for col = 1:dims(2)
            origR = im(row, col, 1);
            origG = im(row, col, 2);
            origB = im(row, col, 3);
            
            tempR = floor(origR / (2.^5));
            tempR = double(tempR) / (2.0.^3);
            tempG = floor(origG / (2.^5));
            tempG = double(tempG) / (2.0.^3);
            tempB = floor(origB / (2.^6));
            tempB = double(tempB) / (2.0.^2);
            
            newR = dec2bin(tempR*7, 3);
            newG = dec2bin(tempG*7, 3);
            newB = dec2bin(tempB*3, 2);
              
            pixel = [newR, newG, newB];
            fprintf(coe, pixel);
            
            if(row == dims(1) && col == dims(2) && i == num_files)
                fprintf(coe, ';');
            else
                fprintf(coe, ',\n');
            end
            
            new(row, col, 1) = (bin2dec(newR) / 7);
            new(row, col, 2) = (bin2dec(newG) / 7);
            new(row, col, 3) = (bin2dec(newB) / 3);
            
        end
        
        str = sprintf('end of image (%d / %d) row (%d / %d)', i, num_files, row, dims(1));
        disp(str)
        
    end
    
    figure();
    image(im);
    figure();
    image(new);

end

fclose(coe);