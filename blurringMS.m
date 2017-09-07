# Gaussian_blurring_mean_shift
function [out] = blurringMS(image,hr,isLuv)

% argument check
if nargin < 3
    error('invalid input\n');
elseif nargin == 3
    if sum(ismember(isLuv,[0,1])) == 0
        error('isLuv option has to be 0 or 1\n');
    end
elseif nargin > 3
    error('too many input arguments\n')
end
% initialization
[height,width,depth] = size(image);
x = im2double(reshape(image,height*width,depth));
num = 1000;
hR = hr^2;
N = height*width;
A = 0;
B = 0;
C = zeros(1,3);
y = zeros(N,depth);
% blurring mean shift using gaussian kernel
tic
figure(randi(1000)+1000); 
MS = [];
update=1;
for iter = 1:num
	if(update<0.1)
		break;
	end
    c = 0;
	for i = 1:N 
		vx = x(i,:);
		diffvec = bsxfun(@minus, x, vx);
		normsquare = sum(diffvec.^2,2);
		A = exp((-1/2)*normsquare/hR);
		B = sum(A);
		C = A'*x;
		y(i,:) = C./B;
		c = c + norm(y(i,:) - x(i,:),2);
	end
	x = y;
	update = c/N;
	MS(iter) = update;
	fprintf('update of no%-2diteration is %-5d\n',iter,update);
	subplot(121), imshow(reshape(colorspace('RGB<-Luv',y), height, width, depth)), axis image, title(['iteration times = ' num2str(iter) '; average update = ' num2str(update)]);
	subplot(122), plot(1:iter, MS ), xlabel('iteration times'), ylabel('average update');axis square
    set(gcf,'color','w');
	drawnow
	%pause(0.5)
	frame = getframe(gcf);
	im = frame2im(frame);
	[imind,cm] = rgb2ind(im,256);
	outfile = 'x.gif';
	if iter==1
		imwrite(imind,cm,outfile,'gif','DelayTime',0.5,'loopcount',inf);
	else
		imwrite(imind,cm,outfile,'gif','DelayTime',0.5,'writemode','append');
    end
end
toc
if isLuv
    y = reshape(y,height,width,depth);
else
    y = reshape(uint8(y),height,width,depth);
end
out = y;
