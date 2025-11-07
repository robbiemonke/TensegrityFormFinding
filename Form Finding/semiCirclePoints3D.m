function [P] = semiCirclePoints3D(r, N, C, alpha, beta, gamma)
% This function takes parameters of the radius of the curve r, the
% number of nodes of the curve N, and the center of the curve C, and 
% outputs the offset coordinates from the center of the semi-circle of the 
% points of the curve, P.
%
% Author: Robbie Monke
% Date: 6/2/2025

% Creation of angles to each point desired
theta = linspace(0, pi, N);

% Location of each x, y, and z coordinate in unrotated plane
x = -r * cos(theta);
y = -r * sin(theta);
z = zeros(size(theta));

% Points in unrotated plane
P_xy = [x(:), y(:), z(:)];

% Rotation of points to tilted plane
Rx = [1 0 0;
      0 cos(alpha) -sin(alpha);
      0 sin(alpha) cos(alpha)];

Ry = [cos(beta) 0 sin(beta);
      0 1 0;
     -sin(beta) 0 cos(beta)];

Rz = [cos(gamma) -sin(gamma) 0;
      sin(gamma) cos(gamma) 0;
      0 0 1];

R = Rx * Ry * Rz;

P_rotated = (R * P_xy')';

% Offset of points from defined center
P = P_rotated + C;

%% YAML
% disp("nodes:")
% for i = 1:length(P)
%     disp("  node1-" + i + ": [" + P(i, 1) + ", " + P(i, 2) + ", " + P(i, 3) + "]")
% end
% 
% disp("pair_groups:")
% disp("  rod:")
% for i = 1:(length(P) - 1)
%     next = i + 1;
%     disp("    - [node1-" + i + ", node1-" + next + "]")
% end


% for i = 1:length(P)
%     disp("  node2-" + i + ": [" + P(i, 1) + ", " + P(i, 2) + ", " + P(i, 3) + "]")
% end
% 
% 
% for i = 1:(length(P) - 1)
%     next = i + 1;
%     disp("    - [node2-" + i + ", node2-" + next + "]")
% end

%% C++
% for i = 1:length(P)
%     disp("    s.addNode(" + P(i, 1) + ", " + P(i, 2) + ", " + P(i, 3) + "); // " + (i-1+100))
% end

% for i = 1:(length(P) - 1)
%     disp("    s.addPair(" + (i-1) + ", " + i + ", ""rod"");")
% end
end