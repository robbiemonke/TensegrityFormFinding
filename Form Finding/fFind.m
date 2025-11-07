clear; 
clc;
close all;

%% Constants
constants;

%% Optimization
% Initial guess for transformation matrix and screw
T = TMatExponential3([0 1 0]', pi/2, [0 0 0]') * TMatExponential3([0 0 1]', pi, [0 0 0]');
T_translation = [1 0 0 0;...
                 0 1 0 2;...
                 0 0 1 0;...
                 0 0 0 1];
T = T * T_translation;
[u, theta, vtilde] = EquivalentScrew3(T);
xi_0 = [u; vtilde] * theta;

Fext = 0 * [0 0 -1]';

% Optimization of screw using minimization of energy functions. 
options = optimoptions(@fminunc,'Display','iter');
xi_min = fminunc(@(xi) fFindFunction(xi, params, Fext), xi_0, options);
T_min = screw2TMat(xi_min);

%% Wrench
wrench = getWrench(xi_min, params);

%% Plotting model as semicircles
vertebraePlotSemicircle(T_min, params)

%% Plotting model from STL file
figure(2)
vertebraePlotStl(T_min, params)

%% Plotting of force applied to model
% quiver3(0, 6, 0, 0, -2.5, 0, 'r', 'LineWidth', 3, 'MaxHeadSize', 3)
% text(0, 6, 0, "Perturbation Force", "Color", "black", 'FontSize', 28)

% quiver3(A2(1)+0.32, A2(2), A2(3), 0, 0, -2.5, 'r', 'LineWidth', 3, 'MaxHeadSize', 3)
% text(A2(1), A2(2), A2(3)-3, "Perturbation Force", "Color", "black", 'FontSize', 28)