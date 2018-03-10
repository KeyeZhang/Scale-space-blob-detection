% CS 543 Assignment 2

% name of the input file
imname = 'assignment2_images/butterfly.jpg';

% read in the image
fullim = imread(imname);

% convert to double matrix (might want to do this later on to same memory)
fullim = im2double(fullim);

% compute the height of each part (just 1/3 of total)
height = floor(size(fullim,1)/3);
% separate color channels
B = fullim(1:height,:);
G = fullim(height+1:height*2,:);
R = fullim(height*2+1:height*3,:);

%crop the 3 photos by finding the best width of margin
B = crop(B);
G = crop(G);
R = crop(R);

aB = nccalign(B, R);
aG = nccalign(G, R);

res = cat(3, R, aG, aB);
imshow(res);
% save result image
imwrite(res,'01112v_result_R.jpg');

function [dispv] = findDispv(inputimg, baseimg)
mindiff = inf

for x = -15 : 1:  15
    for y = -15 :1 : 15
        currdispv = [x y]
        currimg = circshift(inputimg, currdispv)
        currdiff = sum(sum(currimg - baseimg).^2)
        if(currdiff < mindiff)
            mindiff = currdiff
            dispv = currdispv
        end
    end
end

end

function [outimg] = align(inputimg, baseimg)
    outimg = circshift(inputimg,findDispv(inputimg, baseimg))
end

function [outimg] = crop(inputimg)
    height = size(inputimg, 1);
    width = size(inputimg, 2);
    
    marginleft = floor(width * 0.05);
    margintop = floor(height * 0.05);
    
    outimg = inputimg(margintop : (height - margintop), marginleft : (width - marginleft));
end

function [outputimg] = nccalign(inputimg, baseimg)

    height = size(inputimg, 1);
    width = size(inputimg, 2);
    
    ncc = normxcorr2(inputimg, baseimg);
    [y, x] = find(ncc==max(ncc(:)));
    by = y - height;
    bx = x - width;
    outputimg = circshift(inputimg, [by bx]);
    disp(-by);
    disp(-bx);
    
end