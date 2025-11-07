clear
clc

%% Constants
constants;

%% Initial xi guess
% Initial guess for transformation matrix and screw
T = TMatExponential3([0 1 0]', pi/2, [0 0 0]') * TMatExponential3([0 0 1]', pi, [0 0 0]');
T_translation = [1 0 0 0;...
                 0 1 0 2;...
                 0 0 1 0;...
                 0 0 0 1];
T = T * T_translation;
[u, theta, vtilde] = EquivalentScrew3(T);
xi_0 = [u; vtilde] * theta;
% xi_0 = rand(6, 1)

%% Find xi for target wrench
% target_xi = [0.4070 0.0040 -0.4006 0.2539 0.1131 0.2573]';
% xi_min = fsolve(@(xi) getWrench(xi, params) - target_xi, xi_0)

%% Find xi using analytical gradient
options = optimoptions('fsolve', 'SpecifyObjectiveGradient', true, 'MaxFunctionEvaluations', 1000, 'MaxIterations', 1000);
% target_xi = [0.4070 0.0040 -0.4006 0.2539 0.1131 0.2573]';
% xi_min = fsolve(@(xi) getWrenchWithGradient(xi, params), xi_0, options)
% xi_min = fsolve(@(xi) getWrenchWithGradient(xi, params) - target_xi, xi_0, options)

%% Find xi using numerical gradient
xi_min = fsolve(@(xi) getWrench(xi, params), xi_0)

T_min = screw2TMat(xi_min)

%% Plotting model as semicircles
vertebraePlotSemicircle(T_min, params)

%% Plotting model from STL file
figure(2)
vertebraePlotStl(T_min, params)