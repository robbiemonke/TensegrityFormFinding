function [E_total, dE_dxi] = fFindFunctionwithgrad(xi, params, Fext)

    % Parameters
    P = params.P;
    ls_0 = params.ls_0;
    lc_0 = params.lc_0;
    k = params.k;
    C1 = params.C1;
    C2 = params.C2;

    % Takes input of screw and converts to the transformation matrix
    T = screw2TMat(xi);

    % Solves equation for connection members vectors
    P1 = P * C1;
    P2 = P * C2;
    S = P1 - T * P2;

    % Iterates through connection members and solves for the total energy
    % in the system
    E_total = 0;
    E = zeros(length(S), 1);
    for i = 1:length(S)
        if any(i == [1, 4, 9, 12]) % Member is diagonal
            if (norm(S(:, i)) - lc_0) <= 0 % Member is slack
                E(i) = 0;
            else % Member is in tension
                E(i) = 0.5 * k * (norm(S(:,i)) - lc_0) ^ 2;
            end
        else % Member is straight
            if (norm(S(:, i)) - ls_0) <= 0 % Member is slack
                E(i) = 0;
            else % Member is in tension
                E(i) = 0.5 * k * (norm(S(:,i)) - ls_0) ^ 2;
            end
        end
        E_total = E(i) + E_total;
    end

    dT_dxi = screw2dT(xi);
    dE_dxi = zeros(6, 1);
    for j = 1:12
        if any(j == [1, 4, 9, 12])
            l0 = lc_0;
        else
            l0 = ls_0;
        end

        sj_norm = norm(S(1:3, j));

        if sj_norm > l0
            for i = 1:6
                dE_dxi(i) = dE_dxi(i) - k * ((sj_norm - l0) / sj_norm) * S(1:3, j)' * dT_dxi(1:3, :, i) * P2(:, j);
            end
        end
    end

    F = [Fext; vec2so3(P(1:3, 1)) * Fext];
    % F = [0.01 0 0 0 0 0]';
    E_total = E_total + xi' * F;
    dE_dxi = dE_dxi + F;
end