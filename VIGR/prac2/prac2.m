im = imread('LennaGray.BMP');

% hit(double(im(:)), 20);

dm = imread('chessDM.jpg');

% hit(double(im(:)), 20);

rgb = imread('chessRGB.png');

% hit(double(im(:)), 20);

rows = size(dm, 1);
cols = size(dm, 2);

X = double(dm(:,:,1));

for i = 1 : rows
    for j = 1 : cols
        if X(i, j) > 100
            X(i, j) = 100;
        end
    end
end

th_dm = dm;
threshold_image(th_dm > 100) = 100;
% mesh(X)

rows = size(rgb, 1);
cols = size(rgb, 2);

Y = double(rgb(:,:,1));

for i = 1 : rows
    for j = 1 : cols
        if Y(i, j) > 100
            Y(i, j) = 100;
        end
    end
end

th_rgb = rgb;
threshold_image(th_rgb > 100) = 100;
% mesh(Y)


% 5.

%A = zeros(3, 84);

%A(1, :) = -1 : 0.1 : 1;
%A(2, :) = 1;
%A(2, 22 : 42) = 1 : -0.1 : -1;
%A(1, 22 : 42) = 1;
%A(1, 43 : 63) = 1 : -0.1 : -1;
%A(2, 43 : 63) = -1;
%A(2, 64 : 84) = -1 : 0.1 : 1;
%A(1, 64 : 84) = -1;    

% figure; plot(A(1, :), A(2, :), '.'); axis([-5 5 -5 5]); axis equal;

%A(3, :) = 1;

% figure; plot(A(1, :), A(2, :), '.'); axis([-5 5 -5 5]); axis equal;

% skew by 60 deg
%T = [1 0.57 0; 0 1 0; 0 0 1];

%B = T * A;

% figure; plot(B(1, :), B(2, :), '.'); axis([-5 5 -5 5]); axis equal;

% to compare:
% figure; plot(A(1, :), A(2, :), '.'); axis([-5 5 -5 5]); axis equal;
% hold
% figure; plot(B(1, :), B(2, :), '.r'); axis([-5 5 -5 5]); axis equal;

% shear by 60 deg
%T = [1 0 0; 0.57 1 0; 0 0 1];

%B = T * A;

% figure; plot(B(1, :), B(2, :), '.'); axis([-5 5 -5 5]); axis equal;

% 6.

%T = [0.234 0.65 0; 0.45 0.234 0; 0 0 1];
%T= [0.64 -0.64 0; 0.94 0.34 0; 0 0 1];
%T= [0.12 0.5 0; -0.65 0.5 0; 0 0 1];
T= [0.8 0.65 0; -0.65 0.6 0; 0.01 0.01 1];

[New, newT] = imTrans(dm, T);

