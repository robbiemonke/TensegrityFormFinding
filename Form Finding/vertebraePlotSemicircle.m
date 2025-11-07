function [] = vertebraePlotSemicircle(T, params)
% This function takes an input parameters of the screw, xi (6x1), points,
% P (4x4), initial straight and cross lengths, ls_0 and lc_0, and the
% linear stiffness, k, and outputs the body wrench, wrench (6x1), of the
% system.
%
% Author: Robbie Monke
% Date: 11/7/2025

    % Parameters - given by constants.m
    P = params.P;

    %% Points
    % Development of points for plotting
    P1 = P;
    P2 = T * P;
    
    A1 = P1(1:3, 1);
    B1 = P1(1:3, 2);
    C1 = P1(1:3, 3);
    D1 = P1(1:3, 4);
    
    A2 = P2(1:3, 1);
    B2 = P2(1:3, 2);
    C2 = P2(1:3, 3);
    D2 = P2(1:3, 4);
    
    %% Plotting model as semi-circles
    % Finding Euler angles from rotation matrix
    eulerZYX = rotm2eul(T(1:3, 1:3), "XYZ");
    
    % Plotting of arc points - nodes and semicircle arc
    figure(1)
    scatter3(P1(1, :), P1(2, :), P1(3, :))
    text(P1(1, :), P1(2, :), P1(3, :)+0.5, ["A1", "B1", "C1", "D1"], "Color", "r")
    hold on
    [semi1] = semiCirclePoints3D(P(1,4), 101, [0, 0, 0], 0, 0, 0);
    plot3(semi1(:,1), semi1(:,2), semi1(:,3), "Color", "b", "LineWidth", 2)
    
    scatter3(P2(1, :), P2(2, :), P2(3, :))
    text(P2(1, :), P2(2, :), P2(3, :)+0.5, ["A2", "B2", "C2", "D2"], "Color", "r")
    [semi2] = semiCirclePoints3D(P(1,4), 101, T(1:3, 4)', eulerZYX(1), eulerZYX(2), eulerZYX(3));
    plot3(semi2(:,1), semi2(:,2), semi2(:,3), "Color", "r", "LineWidth", 2)
    
    % Plot of diagonal strings.
    plot3([A1(1), A2(1)], [A1(2), A2(2)], [A1(3), A2(3)])
    plot3([A1(1), D2(1)], [A1(2), D2(2)], [A1(3), D2(3)])
    plot3([D1(1), A2(1)], [D1(2), A2(2)], [D1(3), A2(3)])
    plot3([D1(1), D2(1)], [D1(2), D2(2)], [D1(3), D2(3)])
    
    % Plot of straight strings
    plot3([A1(1), B2(1)], [A1(2), B2(2)], [A1(3), B2(3)])
    plot3([A1(1), C2(1)], [A1(2), C2(2)], [A1(3), C2(3)])
    plot3([B1(1), A2(1)], [B1(2), A2(2)], [B1(3), A2(3)])
    plot3([B1(1), D2(1)], [B1(2), D2(2)], [B1(3), D2(3)])
    plot3([C1(1), A2(1)], [C1(2), A2(2)], [C1(3), A2(3)])
    plot3([C1(1), D2(1)], [C1(2), D2(2)], [C1(3), D2(3)])
    plot3([D1(1), B2(1)], [D1(2), B2(2)], [D1(3), B2(3)])
    plot3([D1(1), C2(1)], [D1(2), C2(2)], [D1(3), C2(3)])

end