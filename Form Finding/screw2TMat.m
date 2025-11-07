% function [T] = screw2TMat(S)
%     epsilon = 1e-8;
%     omega = S(1:3);
%     v = S(4:6);
% 
%     if norm(omega) < epsilon
%         theta = norm(v);
%         if theta < epsilon
%             T = eye(4);
%             return
%         else
%             R = eye(3);
%             p = v;
%         end
%     else
%         theta = norm(omega);
%         % R = MatExponential3(omega, theta);
%         R = eye(3);
%         G = eye(3) + (1 - cos(theta)) / theta ^ 2 * vec2so3(omega) + (theta - sin(theta)) / theta ^ 3 * (vec2so3(omega) ^ 2);
%         p = G * v;
%     end
%     T = [R p; 0 0 0 1];
% end

function [T] = screw2TMat(S)
    epsilon = 1e-8;
    if norm(S(1:3))<epsilon % omega =0
        omega   = zeros(3,1);
        theta   = norm(S(4:6));
        v       = S(4:6)/theta;
    else
        theta   = norm(S(1:3));
        omega   = S(1:3)/theta;
        v       = S(4:6)/theta;
    end
    T = TMatExponential3(omega,theta,v);
end