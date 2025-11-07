function [dE_dxi] = screw2dEdxi(xi, k, P)
    % Takes input of screw and converts to the transformation matrix
    T = screw2TMat(xi);

    % Definition of connection matrices C1, C2 for A1A2 D1D2 configuration
    C1 = [1 1 1 1 0 0 0 0 0 0 0 0;...
          0 0 0 0 1 1 0 0 0 0 0 0;...
          0 0 0 0 0 0 1 1 0 0 0 0;...
          0 0 0 0 0 0 0 0 1 1 1 1];

    C2 = [1 0 0 0 1 0 1 0 1 0 0 0;...
          0 1 0 0 0 0 0 0 0 1 0 0;...
          0 0 1 0 0 0 0 0 0 0 1 0;...
          0 0 0 1 0 1 0 1 0 0 0 1];

    % Solves equation for connection members vectors
    P1 = P * C1;
    P2 = P * C2;
    S = P1 - T * P2;

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
end