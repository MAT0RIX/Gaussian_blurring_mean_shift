% segementaion demo using GBMS
% demonstrates how pixels converge together
image = input('please specify an image:\n','s');
I = imread(image);%I uint8
[m,n,d] = size(I);
I2 = colorspace('RGB->Luv',I);%I2 double
x = double(I);
isLuv = true;
hr = input('enter the bandwidth:\n'); 
if isLuv
    y = blurringMS(I2,hr,isLuv);%y double
    y = colorspace('RGB<-Luv',y);
else
    y = blurringMS(I,hr,isLuv);
end
y = im2uint8(y);
imwrite(y,'result.jpg');
sample = zeros(size(x,1),size(x,2));
sample(1:3:end,1:3:end) = 1;
R = x(:,:,1); Rx = R(sample==1); Rn = randn( numel(Rx),1 )/3;
G = x(:,:,2); Gx = G(sample==1); Gn = randn( numel(Rx),1 )/3;
B = x(:,:,3); Bx = B(sample==1); Bn = randn( numel(Rx),1 )/3;
figure, 
subplot(221), imshow(uint8(x)), axis image; title('input image')
subplot(223), imshow(uint8(y)), axis image; title('output image')
subplot(222)
scatter3( Rx(:)-Rn, Gx(:)-Gn, Bx(:)-Bn, 3, [ Rx(:), Gx(:), Bx(:) ]/255 );
title('Pixel Distribution Before GBMS')
xlim([0,255]),ylim([0,255]),zlim([0,255]);axis square
R = y(:,:,1); Ry = double(R(sample==1)); Rn = randn( numel(Rx),1 )/3;
G = y(:,:,2); Gy = double(G(sample==1)); Gn = randn( numel(Rx),1 )/3;
B = y(:,:,3); By = double(B(sample==1)); Bn = randn( numel(Rx),1 )/3;
subplot(224)
scatter3( Ry(:)-Rn, Gy(:)-Gn, By(:)-Bn, 3, [ Rx(:), Gx(:), Bx(:) ]/255);
title('Pixel Distribution After GBMS')
xlim([0,255]),ylim([0,255]),zlim([0,255]);axis square
