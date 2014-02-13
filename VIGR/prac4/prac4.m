rows = size(pp, 1);
cols = size(pp, 2);

red = pp(:, :, 1);
green = pp(:, :, 2);
blue = pp(:, :, 3);

% figure; colormap(gray(256)); image(red); axis equal; axis off;
% figure; colormap(gray(256)); image(green); axis equal; axis off;
% figure; colormap(gray(256)); image(blue); axis equal; axis off;

ych = zeros(rows, cols);
ich = zeros(rows, cols);
qch = zeros(rows, cols);

% for i = 1 : rows
%    for j = 1 : cols
%        ych(i, j) = 0.299 * red(i, j) + 0.587 * green(i, j) + 0.114 * blue(i, j);
%        ich(i, j) = 0.596 * red(i, j) - 0.274 * green(i, j) - 0.322 * blue(i, j);
%        qch(i, j) = 0.212 * red(i, j) - 0.528 * green(i, j) + 0.312 * blue(i, j);
%    end
% end

ych = 0.299 * red(:, :) + 0.587 * green(:, :) + 0.114 * blue(:, :);
ich = 0.596 * red(:, :) - 0.274 * green(:, :) - 0.322 * blue(:, :);
qch = 0.212 * red(:, :) - 0.528 * green(:, :) + 0.312 * blue(:, :);

% figure; colormap(gray(256)); image(ych); axis equal; axis off;
% figure; colormap(gray(256)); image(ich); axis equal; axis off;
% figure; colormap(gray(256)); image(qch); axis equal; axis off;

V = 0.33 * (red + green + blue);
S = 1 - (3 / (red + green + blue)) * min(red, green, blue);
H = arccos((0.5 * ((red - green) + (red - blue))) / sqrt((red - green)))

