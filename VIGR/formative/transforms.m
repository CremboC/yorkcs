% very bad original code, where are the spaces?
% 2013/11/22 10:40 - fixed formatting
clear A B T
close all

% Create a 2D square stored as homogeneous points:
A(1, 1 : 41) = 0 : 0.025 : 1; 
A(2, 1 : 41) = 0;
A(1, 42 : 82) = 1;
A(2, 42 : 82) = 0 : 0.025:1;
A(1, 83 : 123) = 1 : -0.025 : 0;
A(2, 83 : 123) = 1;
A(2, 124 : 164) = 1 : -0.025 : 0;
A(1, 124 : 164) = 0;
% Make homogeneous:
A(3 , :) = 1;

% Display the points:
figure;
plot(A(1, :), A(2, :), '.b');
axis equal;
axis([0 10 0 5]);
grid on;
hold;
set(gca, 'XTick', 0 : 10);
set(gca, 'YTick', 0 : 5);

% Create a transformation matrix
% consisting of a translation of +5 in the x direction
T = [1 0 5; 0 1 0; 0 0 1]; 

% Transform the points:
B = T * A;

% Display the transformed points:
plot(B(1, :), B(2, :), '.r');

% TXs - Transformation X, scaling
% TXr - Transformation X, rotation
% TXm - Transformation X, movement
% TXsh - Transformation X, shear
% Tf - final transformation matrix

% T1 - scale x2, move to right by 5
T1m = [1 0 5; 0 1 0; 0 0 1];
T1s = [2 0 0; 0 2 0; 0 0 1];

B = T1s * A;
B = T1m * B;

plot(B(1, :), B(2, :), '.g');

% T2 - scale x*3, move right by 5, move up by 3
T2m = [1 0 5; 0 1 3; 0 0 1];
T2s = [3 0 0; 0 1 0; 0 0 1];

Tf = T2m * T2s;

B = Tf * A;

plot(B(1, :), B(2, :), '.black');

% T3 - rotate 45*, move right by 0.8, move up by 0.8
T3r = [0.707 -0.707 0; 0.707 0.707 0; 0 0 1];
T3m = [1 0 0.7; 0 1 0.8; 0 0 1];

B = T3r * A;
B = T3m * B;

plot(B(1, :), B(2, :), '.black');

% T4 - rotate 45*, move up by 2.3, right by 3
T4r = [0.707 -0.707 0; 0.707 0.707 0; 0 0 1];
T4m = [1 0 3; 0 1 2.3; 0 0 1];

B = T4r * A;
B = T4m * B;

plot(B(1, :), B(2, :), '.g');

% T5 - rotate 45* (sin45 = 0.707, cos45 = 0.707), move up by 1.6, right by 3, scale x2
T5r = [0.707 -0.707 0; 0.707 0.707 0; 0 0 1];
T5m = [1 0 3; 0 1 1.6; 0 0 1];
T5s = [2 0 0; 0 2 0; 0 0 1];

B = T5r * A;
B = T5s * B;
B = T5m * B;

plot(B(1, :), B(2, :), '.r');

% T6 - sheer by 45* (cot(45) = 1), move up by 2, move right by 2
T6sh = [1 1 0; 0 1 0; 0 0 1];
T6m = [1 0 2; 0 1 2; 0 0 1];

B = T6sh * A;
B = T6m * B;

plot(B(1, :), B(2, :), '.yellow');