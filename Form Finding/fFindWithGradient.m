clear; 
clc;
close all;

%% Constants
% First arc's points
P = [-3.6195, 0, 0, 1;...
    -2.2924, -2.4130, 0, 1;...
    2.2924, -2.4130, 0, 1;...
    3.6195, 0, 0, 1]';

% Straight tendon member length (cm)
ls_0 = 3.175;

% Diagonal tendon member length (cm)
lc_0 = 3.810;

% Spring constant N/cm
k = 0.77;

params.P = P;
params.ls_0 = ls_0;
params.lc_0 = lc_0;
params.k = k;

%% Optimization
% Initial guess for transformation matrix and screw
T = TMatExponential3([0 1 0]', pi/2, [0 0 0]') * TMatExponential3([0 0 1]', pi, [0 0 0]');
T_translation = [1 0 0 0;...
                 0 1 0 1.57;...
                 0 0 1 0;...
                 0 0 0 1];
T = T * T_translation;
[u, theta, vtilde] = EquivalentScrew3(T);
xi_0 = [u; vtilde] * theta;

Fext = 0.85 * [1 0 -1]';

% Optimization of screw using minimization of energy functions. 
options = optimoptions(@fminunc);
tic
xi_min = fminunc(@(xi) fFindFunction(xi, params, Fext), xi_0, options);
toc

options = optimoptions(@fminunc, 'SpecifyObjectiveGradient', true);
tic
xi_min = fminunc(@(xi) fFindFunctionwithgrad(xi, params, Fext), xi_0, options);
toc