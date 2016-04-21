function [  phi3,   phi4,   x5,     phi6,   phi7,   phi8,   x9,     phi10,      x11,    phi12, ... 
            dphi3,  dphi4,  dx5,    dphi6,  dphi7,  dphi8,  dx9,    dphi10,     dx11,   dphi12, ...
            ddphi3, ddphi4, ddx5,   ddphi6, ddphi7, ddphi8, ddx9,   ddphi10,    ddx11,  ddphi12, ...
            a56_x_check, a56_y_check, a67_x_check, a67_y_check, a68_x_check, a68_y_check, a89_x_check, ...
            a89_y_check, a810_x_check, a810_y_check, a1011_x_check, a1011_y_check] = ...
            kinematics_4bar(r2l, r2k, r3, r4l, r4k, r6l, r6k, r7, r8l, r8k, r10, r11, r12, x4, y4, x7, y7, y9, ...
                    phi1, phi2, dphi2, ddphi2, omega, alpha, ...
                    phi3_init, phi4_init, x5_init, phi6_init, phi7_init, phi8_init, x9_init, phi10_init, x11_init, phi12_init, ...
                    t, fig_kin_4bar)

%% **initialization**

% allocation of the result vectors (this results in better performance because we don't have to reallocate and
% copy the vector each time we add an element.
phi3    = zeros(size(t));
phi4    = zeros(size(t));
x5      = zeros(size(t));
phi6    = zeros(size(t));
phi7    = zeros(size(t));
phi8    = zeros(size(t));
x9      = zeros(size(t));
phi10   = zeros(size(t));
x11     = zeros(size(t));
phi12   = zeros(size(t));

dphi3    = zeros(size(t));
dphi4    = zeros(size(t));
dx5      = zeros(size(t));
dphi6    = zeros(size(t));
dphi7    = zeros(size(t));
dphi8    = zeros(size(t));
dx9      = zeros(size(t));
dphi10   = zeros(size(t));
dx11     = zeros(size(t));
dphi12   = zeros(size(t));

ddphi3    = zeros(size(t));
ddphi4    = zeros(size(t));
ddx5      = zeros(size(t));
ddphi6    = zeros(size(t));
ddphi7    = zeros(size(t));
ddphi8    = zeros(size(t));
ddx9      = zeros(size(t));
ddphi10   = zeros(size(t));
ddx11     = zeros(size(t));
ddphi12   = zeros(size(t));

% controlevariabelen
dphi3_check =  zeros(size(t));
dphi4_check =  zeros(size(t));
dx5_check =    zeros(size(t));
dphi6_check =  zeros(size(t));
dphi7_check =  zeros(size(t));
dphi8_check =  zeros(size(t));
dx9_check =    zeros(size(t));
dphi10_check = zeros(size(t));
dx11_check =   zeros(size(t));
dphi12_check = zeros(size(t));

ddphi3_check =  zeros(size(t));
ddphi4_check =  zeros(size(t));
ddx5_check =    zeros(size(t));
ddphi6_check =  zeros(size(t));
ddphi7_check =  zeros(size(t));
ddphi8_check =  zeros(size(t));
ddx9_check =  zeros(size(t));
ddphi10_check = zeros(size(t));
ddx11_check =   zeros(size(t));
ddphi12_check = zeros(size(t));

% hulpvariabelen voor controle
v56_x_check =   zeros(size(t));
v56_y_check =   zeros(size(t));
v67_x_check =   zeros(size(t));
v67_y_check =   zeros(size(t));
v68_x_check =   zeros(size(t));
v68_y_check =   zeros(size(t));
v89_x_check =   zeros(size(t));
v89_y_check =   zeros(size(t));
v810_x_check =  zeros(size(t));
v810_y_check =  zeros(size(t));
v1011_x_check = zeros(size(t));
v1011_y_check = zeros(size(t));

a56_x_check =   zeros(size(t));
a56_y_check =   zeros(size(t));
a67_x_check =   zeros(size(t));
a67_y_check =   zeros(size(t));
a68_x_check =   zeros(size(t));
a68_y_check =   zeros(size(t));
a89_x_check =   zeros(size(t));
a89_y_check =   zeros(size(t));
a810_x_check =  zeros(size(t));
a810_y_check =  zeros(size(t));
a1011_x_check = zeros(size(t));
a1011_y_check = zeros(size(t));


% fsolve options (help fsolve, help optimset)
optim_options = optimset('Display','off');


%% *** loop over positions ***
Ts = t(2) - t(1);      % timestep
t_size = size(t,1);    % number of simulation steps
for k=1:t_size
    
    %% *** position analysis ***
    
    % fsolve solves the non-linear set of equations
    % loop closure equations: see loop_closure_eqs.m
    % argument loop_closure_eqs: file containing closure equations
    % argument [..]': initial values of unknown angles phi3 and phi4
    % argument optim options: parameters for fsolve
    % argument phi2(k): input angle phi2 for which we want to calculate the unknown angles phi3 and phi4
    % argument a1 ... phi1: constants
    % return value x: solution for the unknown angles phi3 and phi4
    % return exitflag: indicates convergence of algorithm
    [x, fval, exitflag] = fsolve('loop_closure_eqs', ...
                                 [phi3_init, phi4_init, x5_init, phi6_init, phi7_init, phi8_init, x9_init, phi10_init, x11_init, phi12_init]', ...
                                 optim_options, ...
                                 phi2(k), ...
                                 r2l, r2k, r3, r4l, r4k, r6l, r6k, r7, r8l, r8k, r10, r11, r12, x4, y4, x7, y7, y9);
    if (exitflag ~= 1)
        display 'The fsolve exit flag was not 1, probably no convergence!'
        exitflag
    end
    % Declaratie nieuwe variabele
    r6 = r6k + r6l;
    dphi2(k)= omega;
    ddphi2(k) = alpha;
    
    % save results of fsolve
    phi3(k) =   x(1);
    phi4(k) =   x(2);
    x5(k)  =    x(3);
    phi6(k) =   x(4);
    phi7(k) =   x(5);
    phi8(k) =   x(6);
    x9(k) =     x(7);
    phi10(k) =  x(8);
    x11(k) =    x(9);
    phi12(k) =  x(10);
    
    
    %% *** velocity analysis ***
    %    dphi3              dphi4               dx5                 dphi6               dphi7               dphi8               dx9                 dphi10              dx11                dphi12
    A = [0,                 0,                  0,                  0,                  0,                  0,                  0,                  0,                  1,                  -r12*sin(phi12(k));
         0,                 0,                  0,                  0,                  0,                  0,                  0,                  0,                  0,                  r12*cos(phi12(k));
         0,                 0,                  0,                  0,                  0,                  -r8l*sin(phi8(k)),  -1,                 -r10*sin(phi10(k)), -1,                 0;
         0,                 0,                  0,                  0,                  0,                  r8l*cos(phi8(k)),   0,                  r10*cos(phi10(k)),  0,                  0;
         0,                 -x5(k)*sin(phi4(k)),cos(phi4(k)),       -r6k*sin(phi6(k)),  r7*sin(phi7(k)),    0,                  0,                  0,                  0,                  0;
         0,                 x5(k)*cos(phi4(k)), sin(phi4(k)),       r6k*cos(phi6(k)),   -r7*cos(phi7(k)),   0,                  0,                  0,                  0,                  0;
         0,                 0,                  0,                  -r6*sin(phi6(k)),   r7*sin(phi7(k)),    r8k*sin(phi8(k)),  -1,                 0,                  0,                  0;
         0,                 0,                  0,                  r6*cos(phi6(k)),    -r7*cos(phi7(k)),   -r8k*cos(phi8(k)),  0,                  0,                  0,                  0;
         -r3*sin(phi3(k)),  -r4l*sin(phi4(k))+r4k*cos(phi4(k)),  0,     0,                  0,                  0,                  0,                  0,                  0,                  0;
         r3*cos(phi3(k)),   r4l*cos(phi4(k))+r4k*sin(phi4(k)), 0,       0,                  0,                  0,                  0,                  0,                  0,                  0];
     
    B = [-r2l*sin(phi2(k))*dphi2(k);
         r2l*cos(phi2(k))*dphi2(k);
         0;
         0;
         0;
         0;
         0;
         0;
         -r2k*cos(phi2(k))*dphi2(k);
         -r2k*sin(phi2(k))*dphi2(k)];
        
    x = A\B;
    
    % save results
    dphi3(k)  = x(1);
    dphi4(k)  = x(2);
    dx5(k)    = x(3);
    dphi6(k)  = x(4);
    dphi7(k)  = x(5);
    dphi8(k)  = x(6);
    dx9(k)    = x(7);
    dphi10(k) = x(8);
    dx11(k)   = x(9);
    dphi12(k) = x(10);
    
    %% *** acceleration analysis ***
    
    % A = zelfde als daarnet
    
    B = [-r2l*sin(phi2(k))*ddphi2(k) - r2l*cos(phi2(k))*dphi2(k)^2 + r12*cos(phi12(k))*dphi12(k)^2;
         r2l*cos(phi2(k))*ddphi2(k) - r2l*sin(phi2(k))*dphi2(k)^2 + r12*sin(phi12(k))*dphi12(k)^2;
         r10*cos(phi10(k))*dphi10(k)^2 + r8l*cos(phi8(k))*dphi8(k)^2;
         r10*sin(phi10(k))*dphi10(k)^2 + r8l*sin(phi8(k))*dphi8(k)^2;
         -r7*cos(phi7(k))*dphi7(k)^2 + r6k*cos(phi6(k))*dphi6(k)^2 + 2*sin(phi4(k))*dphi4(k)*dx5(k) + x5(k)*cos(phi4(k))*dphi4(k)^2;
         -r7*sin(phi7(k))*dphi7(k)^2 + r6k*sin(phi6(k))*dphi6(k)^2 - 2*cos(phi4(k))*dphi4(k)*dx5(k) + x5(k)*sin(phi4(k))*dphi4(k)^2;
         -r7*cos(phi7(k))*dphi7(k)^2 + r6*cos(phi6(k))*dphi6(k)^2 - r8k*cos(phi8(k))*dphi8(k)^2;
         -r7*sin(phi7(k))*dphi7(k)^2 + r6*sin(phi6(k))*dphi6(k)^2 - r8k*sin(phi8(k))*dphi8(k)^2;
         -r2k*cos(phi2(k))*ddphi2(k) + r2k*sin(phi2(k))*dphi2(k)^2 + r3*cos(phi3(k))*dphi3(k)^2 + (r4l*cos(phi4(k)) + r4k*sin(phi4(k)))*dphi4(k)^2;
         -r2k*sin(phi2(k))*ddphi2(k) - r2k*cos(phi2(k))*dphi2(k)^2 + r3*sin(phi3(k))*dphi3(k)^2 + (r4l*sin(phi4(k)) - r4k*cos(phi4(k)))*dphi4(k)^2];
    
    x = A\B;
    
    % save results
    ddphi3(k)  = x(1);
    ddphi4(k)  = x(2);
    ddx5(k)    = x(3);
    ddphi6(k)  = x(4);
    ddphi7(k)  = x(5);
    ddphi8(k)  = x(6);
    ddx9(k)    = x(7);
    ddphi10(k) = x(8);
    ddx11(k)   = x(9);
    ddphi12(k) = x(10);
    
    
    %% *** calculate initial values for next iteration step ***
    phi3_init  = phi3(k) + Ts*dphi3(k);
    phi4_init  = phi4(k) + Ts*dphi4(k);
    x5_init    = x5(k) + Ts*dx5(k);
    phi6_init  = phi6(k) + Ts*dphi6(k);
    phi7_init  = phi7(k) + Ts*dphi7(k);
    phi8_init  = phi8(k) + Ts*dphi8(k);
    x9_init    = x9(k) + Ts*dx9(k);
    phi10_init = phi10(k) + Ts*dphi10(k);
    x11_init   = x11(k) + Ts*dx11(k);
    phi12_init = phi12(k) + Ts*dphi12(k);
    
    
    %% *** control calculations position ***
    
    pos_1112_a = -r2l*exp(j*phi2) + r12*exp(j*phi12);
    pos_1112_b = r2l + r12 - x11 + 0*j;
    
    pos_810_a =  r2l + r12 - x11 - r11*j + r10*exp(j*phi10);
    pos_810_b =  r2l + r12 + x9 + j*y9 - r8l*exp(j*phi8);
    
    pos_56_a =   x7 + j*y7 -r7*exp(j*phi7) + r6k*exp(j*phi6);
    pos_56_b =   x4 + j*y4 -x5.*exp(j*phi4);
    
    pos_68_a =   x7 + j*y7 -r7*exp(j*phi7) + (r6k+r6l)*exp(j*phi6);
    pos_68_b =   r2l + r12 + x9 + j*y9 + r8k*exp(j*phi8);
    
    pos_34_a =   r2k*exp(j*(phi2-pi/2)) + r3*exp(j*phi3);
    pos_34_b =   x4 + j*y4 + (r4k+r4l*j)*exp(j*(phi4+pi/2));
    
    
    %% *** control calculations velocity ***
    
    % dphi3 en dphi4
    A_check_34 = [-r3*sin(phi3(k)),  r4l*sin(phi4(k)-pi)+r4k*sin(phi4(k)+pi/2);
                  r3*cos(phi3(k)),   -r4l*cos(phi4(k)-pi)-r4k*cos(phi4(k)+pi/2)];
              
    B_check_34 = [dphi2(k)*r2k*sin(phi2(k)-pi/2);
                  -dphi2(k)*r2k*cos(phi2(k)-pi/2)];
              
    x = A_check_34\B_check_34;
    
    % save results
    dphi3_check(k) = x(1);
    dphi4_check(k) = x(2);
    
    
    % dx11 en dphi12
    A_check_1112 = [1, -r12*sin(phi12(k));
                    0, r12*cos(phi12(k))];
    
    B_check_1112 = [dphi2(k)*r2l*sin(phi2(k)-pi);
                    -dphi2(k)*r2l*cos(phi2(k)-pi)];
                
    x = A_check_1112\B_check_1112;
    
    % save results
    dx11_check(k) =   x(1);
    dphi12_check(k) = x(2);
    
    
    % de rest
    %               v56_x v56_y v67_x v67_y v68_x v68_y v89_x v89_y v810_x v810_y v1011_x v1011_y dx5                 dphi6                   dphi7               dphi8                   dx9 dphi10
    A_check_rest = [0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     1,      0,      0,                  0,                      0,                  0,                      0,  0;
                    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0,      1,      0,                  0,                      0,                  0,                      0,  0;
                    0,    0,    0,    0,    0,    0,    0,    0,    1,     0,     -1,     0,      0,                  0,                      0,                  0,                      0,  r10*sin(phi10(k));
                    0,    0,    0,    0,    0,    0,    0,    0,    0,     1,     0,      -1,     0,                  0,                      0,                  0,                      0,  -r10*cos(phi10(k));
                    0,    0,    0,    0,    0,    0,    1,    0,    -1,    0,     0,      0,      0,                  0,                      0,                  r8l*sin(phi8(k)),       0,  0;
                    0,    0,    0,    0,    0,    0,    0,    1,    0,     -1,    0,      0,      0,                  0,                      0,                  -r8l*cos(phi8(k)),      0,  0;
                    0,    0,    0,    0,    1,    0,    0,    0,    -1,    0,     0,      0,      0,                  0,                      0,                  (r8l+r8k)*sin(phi8(k)), 0,  0;
                    0,    0,    0,    0,    0,    1,    0,    0,    0,     -1,    0,      0,      0,                  0,                      0,                  -(r8l+r8k)*cos(phi8(k)),0,  0;
                    0,    0,    1,    0,    0,    0,    0,    0,    0,     0,     0,      0,      0,                  0,                      r7*sin(phi7(k)-pi), 0,                      0,  0;
                    0,    0,    0,    1,    0,    0,    0,    0,    0,     0,     0,      0,      0,                  0,                      -r7*cos(phi7(k)-pi),0,                      0,  0;
                    1,    0,    -1,   0,    0,    0,    0,    0,    0,     0,     0,      0,      0,                  r6k*sin(phi6(k)),       0,                  0,                      0,  0;
                    0,    1,    0,    -1,   0,    0,    0,    0,    0,     0,     0,      0,      0,                  -r6k*cos(phi6(k)),      0,                  0,                      0,  0;
                    0,    0,    -1,   0,    1,    0,    0,    0,    0,     0,     0,      0,      0,                  (r6k+r6l)*sin(phi6(k)), 0,                  0,                      0,  0;
                    0,    0,    0,    -1,   0,    1,    0,    0,    0,     0,     0,      0,      0,                  -(r6k+r6l)*cos(phi6(k)),0,                  0,                      0,  0;
                    1,    0,    0,    0,    0,    0,    0,    0,    0,     0,     0,      0,      -cos(phi4(k)-pi),   0,                      0,                  0,                      0,  0;
                    0,    1,    0,    0,    0,    0,    0,    0,    0,     0,     0,      0,      -sin(phi4(k)-pi),   0,                      0,                  0,                      0,  0;
                    0,    0,    0,    0,    0,    0,    1,    0,    0,     0,     0,      0,      0,                  0,                      0,                  0,                      -1, 0;
                    0,    0,    0,    0,    0,    0,    0,    1,    0,     0,     0,      0,      0,                  0,                      0,                  0,                      0,  0];
    %               v56_x v56_y v67_x v67_y v68_x v68_y v89_x v89_y v810_x v810_y v1011_x v1011_y dx5                 dphi6                   dphi7               dphi8                   dx9 dphi10
                
    B_check_rest = [-dx11_check(k);
                    0;
                    0;
                    0;
                    0;
                    0;
                    0;
                    0;
                    0;
                    0;
                    0;
                    0;
                    0;
                    0;
                    -dphi4_check(k)*x5(k)*sin(phi4(k)-pi);
                    dphi4_check(k)*x5(k)*cos(phi4(k)-pi);
                    0;
                    0];
                
    x = A_check_rest\B_check_rest;
    
    % save results
    v56_x_check(k) =   x(1);
    v56_y_check(k) =   x(2);
    v67_x_check(k) =   x(3);
    v67_y_check(k) =   x(4);
    v68_x_check(k) =   x(5);
    v68_y_check(k) =   x(6);
    v89_x_check(k) =   x(7);
    v89_y_check(k) =   x(8);
    v810_x_check(k) =  x(9);
    v810_y_check(k) =  x(10);
    v1011_x_check(k) = x(11);
    v1011_y_check(k) = x(12);
    dx5_check(k) =     x(13);
    dphi6_check(k) =   x(14);
    dphi7_check(k) =   x(15);
    dphi8_check(k) =   x(16);
    dx9_check(k) =     x(17);
    dphi10_check(k) =  x(18);
    
    
    %% *** control calculations acceleration ***
    
    % ddphi3 en ddphi4    
    % A_check_34 blijft gelijk
    B_check_34 = [ddphi2(k)*r2k*sin(phi2(k)-pi/2) + dphi2(k)^2*r2k*cos(phi2(k)-pi/2) + dphi3(k)^2*r3*cos(phi3(k)) - dphi4(k)^2*(r4l*cos(phi4(k)-pi)+r4k*cos(phi4(k)+pi/2));
                  -ddphi2(k)*r2k*cos(phi2(k)-pi/2) + dphi2(k)^2*r2k*sin(phi2(k)-pi/2) + dphi3(k)^2*r3*sin(phi3(k)) - dphi4(k)^2*(r4l*sin(phi4(k)-pi)+r4k*sin(phi4(k)+pi/2))];
    
    x = A_check_34\B_check_34;
    
    % save results
    ddphi3_check(k) = x(1);
    ddphi4_check(k) = x(2);
    
    
    % ddx11 en ddphi12
    % A_check_1112 blijft gelijk
    B_check_1112 = [ddphi2(k)*r2l*sin(phi2(k)-pi) + dphi2(k)^2*r2l*cos(phi2(k)-pi) + dphi12(k)^2*r12*cos(phi12(k));
                     -ddphi2(k)*r2l*cos(phi2(k)-pi) + dphi2(k)^2*r2l*sin(phi2(k)-pi) + dphi12(k)^2*r12*sin(phi12(k))];
                 
    x = A_check_1112\B_check_1112;
    
    % save results
    ddx11_check(k) =   x(1);
    ddphi12_check(k) = x(2);
    
    
    % de rest
    % A_check_rest blijft gelijk
    B_check_rest = [-ddx11_check(k);
                    0;
                    -dphi10(k)^2*r10*cos(phi10(k));
                    -dphi10(k)^2*r10*sin(phi10(k));
                    -dphi8(k)^2*r8l*cos(phi8(k));
                    -dphi8(k)^2*r8l*sin(phi8(k));
                    -dphi8(k)^2*(r8l+r8k)*cos(phi8(k));
                    -dphi8(k)^2*(r8l+r8k)*sin(phi8(k));
                    -dphi7(k)^2*r7*cos(phi7(k)-pi);
                    -dphi7(k)^2*r7*sin(phi7(k)-pi);
                    -dphi6(k)^2*r6k*cos(phi6(k));
                    -dphi6(k)^2*r6k*sin(phi6(k));
                    -dphi6(k)^2*(r6k+r6l)*cos(phi6(k));
                    -dphi6(k)^2*(r6k+r6l)*sin(phi6(k));
                    -ddphi4_check(k)*x5(k)*sin(phi4(k)-pi) - dphi4(k)^2*x5(k)*cos(phi4(k)-pi) - 2*dphi4(k)*dx5(k)*sin(phi4(k)-pi);
                    ddphi4_check(k)*x5(k)*cos(phi4(k)-pi) - dphi4(k)^2*x5(k)*sin(phi4(k)-pi) + 2*dphi4(k)*dx5(k)*cos(phi4(k)-pi);
                    0;
                    0];
                
    x = A_check_rest\B_check_rest;
    
    % save results
    a56_x_check(k) =   x(1);
    a56_y_check(k) =   x(2);
    a67_x_check(k) =   x(3);
    a67_y_check(k) =   x(4);
    a68_x_check(k) =   x(5);
    a68_y_check(k) =   x(6);
    a89_x_check(k) =   x(7);
    a89_y_check(k) =   x(8);
    a810_x_check(k) =  x(9);
    a810_y_check(k) =  x(10);
    a1011_x_check(k) = x(11);
    a1011_y_check(k) = x(12);
    ddx5_check(k) =    x(13);
    ddphi6_check(k) =  x(14);
    ddphi7_check(k) =  x(15);
    ddphi8_check(k) =  x(16);
    ddx9_check(k) =    x(17);
    ddphi10_check(k) = x(18);    
    
                    
end % loop over positions


%% *** create movie ***

if fig_kin_4bar
    % startpunt
    % nomenclatuur: scharnier tussen staaf x en staaf y = sch_x_y
    sch_1_2 = 0;
    % andere vaste punten (coördinaten = complexe getallen)
    sch_1_7 = (x7 + j*y7)*exp(j*phi1);
    sch_1_4 = (x4 + j*y4)*exp(j*phi1);

    % define which positions we want as frames in our movie
    frames = 40;    % number of frames in movie
    delta = floor(t_size/frames); % time between frames
    index_vec = [1:delta:t_size]';

    % Create a window large enough for the whole mechanisme in all positions, to prevent scrolling.
    % This is done by plotting a diagonal from (x_left, y_bottom) to (x_right, y_top), setting the
    % axes equal and saving the axes into "movie_axes", so that "movie_axes" can be used for further
    % plots.
    x_left = -1.5*r2l;
    y_bottom = -1.5*max(r2l, r11);
    x_right = x7 + 1.5*(r7 + r6);
    y_top = 1.2*max(y4,max(y7,y9)); 

    figure(10)
    hold on
    plot([x_left, x_right], [y_bottom, y_top]);
    axis equal;
    movie_axes = axis;   %save current axes into movie_axes

    % draw and save movie frame
    for m=1:length(index_vec)
        index = index_vec(m);

        sch_2_12  = sch_1_2 + r2l*exp(j*(phi2(index) + pi));
        sch_2_3   = sch_1_2 + r2k*exp(j*(phi2(index) - pi/2));
        sch_3_4a  = sch_2_3 + r3*exp(j*phi3(index));

        sch_11_12 = sch_2_12 + r12*exp(j*phi12(index));
        sch_10_11 = sch_11_12 - j*r11;
        sch_8_101 = sch_10_11 + r10*exp(j*phi10(index));

        sch_8_9   = r2l + r12 + x9(index) + j*y9;                       % De bovenste van de twee zuigers

        sch_6_7   = sch_1_7 + r7*exp(j*(phi7(index) + pi));
        sch_5_6   = sch_6_7 + r6k*exp(j*(phi6(index)));                 % Het blokje dat over de roterende staaf glijdt
        sch_6_8   = sch_5_6 + r6l*exp(j*phi6(index));
        sch_8_102 = sch_6_8 + (r8l + r8k)*exp(j*(phi8(index) + pi));

        hoekpunt_4 = sch_1_4 + r4l*exp(j*(phi4(index) + pi));           % Het hoekpunt van staaf 4
        vrijpunt_4 = sch_1_4 + 2/3*r4l*exp(j*phi4(index));              % Ongeconnecteerde punt van staaf 4
        sch_3_4b   = hoekpunt_4 + r4k*exp(j*(phi4(index) + pi/2));


        staaf2 = [sch_1_2 sch_2_3 sch_2_12 sch_1_2];                    % De driehoekige staaf 2
        loop1  = [sch_2_12 sch_11_12 sch_10_11 sch_8_101];
        loop2  = [sch_1_7 sch_6_7 sch_5_6 sch_6_8 sch_8_9 sch_8_102]; 
        staaf4 = [vrijpunt_4 sch_1_4 hoekpunt_4 sch_3_4b];              % Wordt getekend zonder bolletjes
        scharnieren4 = [sch_1_4 sch_3_4b];                              % Wordt enkel als bolletjes getekend
        staaf3  = [sch_2_3 sch_3_4a sch_3_4b];
        knoop810 = [sch_8_101 sch_8_102];


        figure(10)
        clf
        hold on
        plot(real(staaf2), imag(staaf2), '-o')
        plot(real(loop1), imag(loop1), '-o')
        plot(real(loop2), imag(loop2), '-o')
        plot(real(staaf4), imag(staaf4), '-')
        plot(real(scharnieren4), imag(scharnieren4), 'o')
        plot(real(staaf3), imag(staaf3), '-o')
        plot(real(knoop810), imag(knoop810), '-o')


        axis(movie_axes);     % set axes as in movie_axes
        Movie(m) = getframe;  % save frame to a variable Film
    end

    % save movie
    save fourbar_movie Movie
    close(10)

end

%% *** plot figures ***

screen_size = get(groot, 'ScreenSize');

if fig_kin_4bar
    %% assembly figuur
    
    %plot assembly at a certain timestep 
    index = 1; %select 1st timestep
    sch_1_2 = 0;
    sch_1_7 = (x7 + j*y7)*exp(j*phi1);
    sch_1_4 = (x4 + j*y4)*exp(j*phi1);
    
    sch_2_12  = sch_1_2 + r2l*exp(j*(phi2(index) + pi));
    sch_2_3   = sch_1_2 + r2k*exp(j*(phi2(index) - pi/2)); 
    sch_3_4a  = sch_2_3 + r3*exp(j*phi3(index));
    
    sch_11_12 = sch_2_12 + r12*exp(j*phi12(index));
    sch_10_11 = sch_11_12 - j*r11;
    sch_8_101 = sch_10_11 + r10*exp(j*phi10(index));
        
    sch_8_9   = r2l + r12 + x9(index) + j*y9;                       % De bovenste van de twee zuigers
        
    sch_6_7   = sch_1_7 + r7*exp(j*(phi7(index) + pi));
    sch_5_6   = sch_6_7 + r6k*exp(j*(phi6(index)));                 % Het blokje dat over de roterende staaf glijdt
    sch_6_8   = sch_5_6 + r6l*exp(j*phi6(index));
    sch_8_102  = sch_6_8 + (r8l + r8k)*exp(j*(phi8(index) + pi));
    
    hoekpunt_4 = sch_1_4 + r4l*exp(j*(phi4(index) + pi));           % Het hoekpunt van staaf 4
    vrijpunt_4 = sch_1_4 + 2/3*r4l*exp(j*phi4(index));              % Ongeconnecteerde punt van staaf 4
    sch_3_4b   = hoekpunt_4 + r4k*exp(j*(phi4(index) + pi/2));
       
    figure('Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/3])
    hold on;
    plot([-r2l, 1.2*(r2l+r12)], [-1.3*r2l, 1.1*y4])
    axis equal;
    plot_axis = axis;
    close all;
    
    figure('Name', 'Assembly', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/3])
    clf
    hold on
    
    staaf2 = [sch_1_2 sch_2_3 sch_2_12 sch_1_2];                    % De driehoekige staaf 2
    loop1  = [sch_2_12 sch_11_12 sch_10_11 sch_8_101];
    loop2  = [sch_1_7 sch_6_7 sch_5_6 sch_6_8 sch_8_9 sch_8_102]; 
    staaf4 = [vrijpunt_4 sch_1_4 hoekpunt_4 sch_3_4b];              % Wordt getekend zonder bolletjes
    scharnieren4 = [sch_1_4 sch_3_4b];                              % Wordt enkel als bolletjes getekend
    staaf3  = [sch_2_3 sch_3_4a sch_3_4b];
    knoop810 = [sch_8_101 sch_8_102];
    
    
    plot(real(knoop810), imag(knoop810),'ro-')   
    hold on;
    plot(real(loop1), imag(loop1), 'ro-')
    plot(real(loop2), imag(loop2), 'ro-')
    plot(real(staaf2), imag(staaf2), 'ro-')
    plot(real(staaf4), imag(staaf4), 'r-')
    plot(real(scharnieren4), imag(scharnieren4), 'ro')
    plot(real(staaf3), imag(staaf3), 'ro-')
    xlabel('[m]')
    ylabel('[m]')
    title('assembly')
    axis(plot_axis)
    hold off
    
    
    %% alle posities
    figure('Name', 'Posities', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(6,2,1)
    plot(t, phi2)
    ylabel('\theta_2 [rad]')
    subplot(6,2,3)
    plot(t, phi3)
    ylabel('\theta_3 [rad]')
    subplot(6,2,5)
    plot(t, phi4)
    ylabel('\theta_4 [rad]')
    subplot(6,2,7)
    plot(t, x5)
    ylabel('x_5 [m]')
    subplot(6,2,9)
    plot(t, phi6)
    ylabel('\theta_6 [rad]')
    subplot(6,2,11)
    plot(t, phi7)
    ylabel('\theta_7 [rad]')
    subplot(6,2,2)
    plot(t, phi8)
    ylabel('\theta_8 [rad]')
    subplot(6,2,4)
    plot(t, x9)
    ylabel('x_9 [m]')
    subplot(6,2,6)
    plot(t, phi10)
    ylabel('\theta_{10} [rad]')
    subplot(6,2,8)
    plot(t, x11)
    ylabel('x_{11} [m]') 
    subplot(6,2,10)
    plot(t, phi12)
    ylabel('\theta_{12} [rad]')
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Posities in functie van de tijd in s'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
    %% alle snelheden
    figure('Name', 'Snelheden', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(6,2,1)
    plot(t, dphi2)
    ylabel('d\theta_2 [rad/s]')
    subplot(6,2,3)
    plot(t, dphi3)
    ylabel('d\theta_3 [rad/s]')
    subplot(6,2,5)
    plot(t, dphi4)
    ylabel('d\theta_4 [rad/s]')
    subplot(6,2,7)
    plot(t, dx5)
    ylabel('dx_5 [m/s]')
    subplot(6,2,9)
    plot(t, dphi6)
    ylabel('d\theta_6 [rad/s]')
    subplot(6,2,11)
    plot(t, dphi7)
    ylabel('d\theta_7 [rad/s]')
    subplot(6,2,2)
    plot(t, dphi8)
    ylabel('d\theta_8 [rad/s]')
    subplot(6,2,4)
    plot(t, dx9)
    ylabel('dx_9 [m/s]')
    subplot(6,2,6)
    plot(t, dphi10)
    ylabel('d\theta_{10} [rad/s]')
    subplot(6,2,8)
    plot(t, dx11)
    ylabel('dx_{11} [m/s]') 
    subplot(6,2,10)
    plot(t, dphi12)
    ylabel('d\theta_{12} [rad/s]')
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Snelheden in functie van de tijd in s'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
    %% alle versnellingen
    figure('Name', 'Versnellingen', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(6,2,1)
    plot(t, ddphi2)
    ylabel('dd\theta_2 [rad/s^2]')
    subplot(6,2,3)
    plot(t, ddphi3)
    ylabel('dd\theta_3 [rad/s^2]')
    subplot(6,2,5)
    plot(t, ddphi4)
    ylabel('dd\theta_4 [rad/s^2]')
    subplot(6,2,7)
    plot(t, ddx5)
    ylabel('ddx_5 [m/s^2]')
    subplot(6,2,9)
    plot(t, ddphi6)
    ylabel('dd\theta_6 [rad/s^2]')
    subplot(6,2,11)
    plot(t, ddphi7)
    ylabel('dd\theta_7 [rad/s^2]')
    subplot(6,2,2)
    plot(t, ddphi8)
    ylabel('dd\theta_8 [rad/s^2]')
    subplot(6,2,4)
    plot(t, ddx9)
    ylabel('ddx_9 [m/s^2]')
    subplot(6,2,6)
    plot(t, ddphi10)
    ylabel('dd\theta_{10} [rad/s^2]')
    subplot(6,2,8)
    plot(t, ddx11)
    ylabel('ddx_{11} [m/s^2]') 
    subplot(6,2,10)
    plot(t, ddphi12)
    ylabel('dd\theta_{12} [rad/s^2]')
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Versnellingen in functie van de tijd in s'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
    %% alle positiecontroles
    
    figure('Name', 'Positiecontroles', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(5,1,1)
    plot(t, real(pos_1112_a - pos_1112_b))
    hold on
    plot(t, imag(pos_1112_a - pos_1112_b))
    hold off
    ylabel('\Delta positie o [m]') 
    subplot(5,1,2)
    plot(t, real(pos_810_a - pos_810_b))
    hold on
    plot(t, imag(pos_810_a - pos_810_b))
    hold off
    ylabel('\Delta positie m [m]') 
    subplot(5,1,3)
    plot(t, real(pos_56_a - pos_56_b))
    hold on
    plot(t, imag(pos_56_a - pos_56_b))
    hold off
    ylabel('\Delta positie e [m]') 
    subplot(5,1,4)
    plot(t, real(pos_68_a - pos_68_b))
    hold on
    plot(t, imag(pos_68_a - pos_68_b))
    hold off
    ylabel('\Delta positie j [m]')
    subplot(5,1,5)
    plot(t, real(pos_34_a - pos_34_b))
    hold on
    plot(t, imag(pos_34_a - pos_34_b))
    hold off
    ylabel('\Delta positie d [m]')
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Controles van de posities'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
    %% alle snelheidscontroles
    figure('Name', 'Snelheidscontroles', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(5,2,1)
    plot(t, dphi3-dphi3_check)
    ylabel('\Deltad\theta_3 [rad/s]')
    subplot(5,2,3)
    plot(t, dphi4-dphi4_check)
    ylabel('\Deltad\theta_4 [rad/s]')
    subplot(5,2,5)
    plot(t, dx5-dx5_check)
    ylabel('\Deltadx_5 [m/s]')
    subplot(5,2,7)
    plot(t, dphi6-dphi6_check)
    ylabel('\Deltad\theta_6 [rad/s]')
    subplot(5,2,9)
    plot(t, dphi7-dphi7_check)
    ylabel('\Deltad\theta_7 [rad/s]')
    subplot(5,2,2)
    plot(t, dphi8-dphi8_check)
    ylabel('\Deltad\theta_8 [rad/s]')
    subplot(5,2,4)
    plot(t, dx9-dx9_check)
    ylabel('\Deltadx_9 [m/s]')
    subplot(5,2,6)
    plot(t, dphi10-dphi10_check)
    ylabel('\Deltad\theta_{10} [rad/s]')
    subplot(5,2,8)
    plot(t, dx11-dx11_check)
    ylabel('\Deltadx_{11} [m/s]')
    subplot(5,2,10)
    plot(t, dphi12-dphi12_check)
    ylabel('\Deltad\theta_{12} [rad/s]')
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Controles van de snelheden'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
    %% alle versnellingscontroles
    figure('Name', 'Versnellingscontroles', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(5,2,1)
    plot(t, ddphi3-ddphi3_check)
    ylabel('\Deltadd\theta_3 [rad/s^2]')
    subplot(5,2,3)
    plot(t, ddphi4-ddphi4_check)
    ylabel('\Deltadd\theta_4 [rad/s^2]')
    subplot(5,2,5)
    plot(t, ddx5-ddx5_check)
    ylabel('\Deltaddx_5 [m/s^2]')
    subplot(5,2,7)
    plot(t, ddphi6-ddphi6_check)
    ylabel('\Deltadd\theta_6 [rad/s^2]')
    subplot(5,2,9)
    plot(t, ddphi7-ddphi7_check)
    ylabel('\Deltadd\theta_7 [rad/s^2]')
    subplot(5,2,2)
    plot(t, ddphi8-ddphi8_check)
    ylabel('\Deltadd\theta_8 [rad/s^2]')
    subplot(5,2,4)
    plot(t, ddx9-ddx9_check)
    ylabel('\Deltaddx_9 [m/s^2]')
    subplot(5,2,6)
    plot(t, ddphi10-ddphi10_check)
    ylabel('\Deltadd\theta_{10} [rad/s^2]')
    subplot(5,2,8)
    plot(t, ddx11-ddx11_check)
    ylabel('\Deltaddx_{11} [m/s^2]')
    subplot(5,2,10)
    plot(t, ddphi12-ddphi12_check)
    ylabel('\Deltadd\theta_{12} [rad/s^2]')
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Controles van de versnellingen'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
end