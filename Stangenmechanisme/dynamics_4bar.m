function [F12x, F12y, F23x, F23y, F212x, F212y, F34x, F34y, F14x, F14y, F45, F56x, F56y, F67x, F67y, ...
    F68x, F68y, F17x, F17y, F89x, F89y, F810x, F810y, F19, F1011x, F1011y, F1112x, F1112y, F111, ...
    M12, M19, M111, M45] ...
    = dynamics_4bar(phi2,  phi3,  phi4,  x5,  phi6,  phi7,  phi8,  x9,  phi10,  x11,  phi12, ...
                    dphi2, dphi3, dphi4, dx5, dphi6, dphi7, dphi8, dx9, dphi10, dx11, dphi12, ...
                    ddphi2,ddphi3,ddphi4,ddx5,ddphi6,ddphi7,ddphi8,ddx9,ddphi10,ddx11,ddphi12, ...
                    r2l, r2k, r3, r4l, r4k, r6l, r6k, r7, r8l, r8k, r10, r11, r12, x4, y4, x7, y7, y9, L9, ...
                    m2,m3,ma,mb,m4,m5,m6k,m6l,m6,m7,m8k,m8l,m8,m9,m10,m11,m12, mpiston1, mpiston2,...
                    X2,X3,X4,X5,X6k,X6l,X6,X7,X8k,X8l,X8,X9,X10,X11,X12, ...
                    Y2,Y3,Y4,Y5,Y6k,Y6l,Y6,Y7,Y8k,Y8l,Y8,Y9,Y10,Y11,Y12, ...
                    J2,J3,J4,J5,J6k,J6l,J6,J7,J8k,J8l,J8,J9,J10,J11,J12, t,fig_dyn_4bar);


% a lot of definitions to make the matrix A and B a bit clear.
% skip the definitions for now (move down to "force analysis")
% and check them when you need them.

% Declaratie nieuwe variabelen:
g = 9.81;           % valversnelling


%% *** Declaratie afstandsvectoren matrix A ***

% cogi_P_x, cogn_P_y = vector from the centre of gravity of bar i to point P
cog2_23_x = r2k*cos(phi2-pi/2);                     % voor stang 2 gerekend vanaf vaste punt
cog2_23_y = r2k*sin(phi2-pi/2);
cog2_212_x = -r2l*cos(phi2);
cog2_212_y = -r2l*sin(phi2);

cog3_23_x = -X3*cos(phi3);                          % voor stang 3 gerekend vanaf massacentrum
cog3_23_y = -X3*sin(phi3);                          % X3 vanaf scharnier 1,3
cog3_34_x = (r3-X3)*cos(phi3);
cog3_34_y = (r3-X3)*sin(phi3);

proj_45_x = cos(phi4-pi/2);                         % projectie van kracht F45
proj_45_y = sin(phi4-pi/2);

vp4_45 = x5;                                        % voor stang 4 gerekend vanaf vaste punt
vp4_34_x = (-r4l*cos(phi4)) + (r4k*cos(phi4+pi/2));      
vp4_34_y = (-r4l*sin(phi4)) + (r4k*sin(phi4+pi/2));    

cog6_56_x = -(X6-r6k)*cos(phi6);                    % voor stang 6 gerekend vanaf massacentrum
cog6_56_y = -(X6-r6k)*sin(phi6);                    % X6 vanaf scharnier 6,7
cog6_67_x = -X6*cos(phi6);
cog6_67_y = -X6*sin(phi6);
cog6_68_x = (r6k + r6l - X6)*cos(phi6);
cog6_68_y = (r6k + r6l - X6)*sin(phi6);

cog7_17_x = X7*cos(phi7);                           % voor stang 7 gerekend vanaf massacentrum
cog7_17_y = X7*sin(phi7);                           % X7 vanaf scharnier 1,7
cog7_67_x = -(r7-X7)*cos(phi7);
cog7_67_y = -(r7-X7)*sin(phi7);

cog8_68_x = (r8k + r8l -X8)*cos(phi8);              % voor stang 8 gerekend vanaf massacentrum
cog8_68_y = (r8k + r8l -X8)*sin(phi8);              % X8 vanaf scharnier 8,10
cog8_89_x = L9*cos(phi8);                           % L9 de afstand van cog tot aangrijping F89
cog8_89_y = L9*sin(phi8);
cog8_810_x = -X8*cos(phi8);
cog8_810_y = -X8*sin(phi8);


cog10_810_x = (r10-X10)*cos(phi10);                 % voor stang 10 gerekend vanaf massacenrum
cog10_810_y = (r10-X10)*sin(phi10);                 % X10 vanaf scharnier 10,11
cog10_1011_x = -X10*cos(phi10);
cog10_1011_y = -X10*sin(phi10);

cog11_111_y = Y11*ones(size(phi2));                 % voor stang 11 gerekend vanaf massacentrum, mag geen scalar zijn, maar vector met dezelfde waarde overal
cog11_1011_y = -(r11-Y11)*ones(size(phi2));         % X11 vanaf scharnier 1,11, mag geen scalar zijn, maar vector met dezelfde waarde overal

cog12_212_x = -X12*cos(phi12);                      % voor stang 12 gerekend vanaf massacentrum
cog12_212_y = -X12*sin(phi12);                      % X12 vanaf scharnier 2,12
cog12_1112_x = (r12-X12)*cos(phi12);
cog12_1112_y = (r12-X12)*sin(phi12);


%% *** Declaratie 3D omega en alpha vectoren ***

% 3D omega (dphi) and alpha (ddphi) vectors)    
omega2 = [zeros(size(phi2)) zeros(size(phi2)) dphi2];   
omega3 = [zeros(size(phi2)) zeros(size(phi2)) dphi3];
omega4 = [zeros(size(phi2)) zeros(size(phi2)) dphi4];
omega6 = [zeros(size(phi2)) zeros(size(phi2)) dphi6];
omega7 = [zeros(size(phi2)) zeros(size(phi2)) dphi7];
omega8 = [zeros(size(phi2)) zeros(size(phi2)) dphi8];
omega10 = [zeros(size(phi2)) zeros(size(phi2)) dphi10];
omega12 = [zeros(size(phi2)) zeros(size(phi2)) dphi12];

alpha2 = [zeros(size(phi2)) zeros(size(phi2)) ddphi2];
alpha3 = [zeros(size(phi2)) zeros(size(phi2)) ddphi3];
alpha4 = [zeros(size(phi2)) zeros(size(phi2)) ddphi4];
alpha6 = [zeros(size(phi2)) zeros(size(phi2)) ddphi6];
alpha7 = [zeros(size(phi2)) zeros(size(phi2)) ddphi7];
alpha8 = [zeros(size(phi2)) zeros(size(phi2)) ddphi8];
alpha10 = [zeros(size(phi2)) zeros(size(phi2)) ddphi10];
alpha12 = [zeros(size(phi2)) zeros(size(phi2)) ddphi12];

%% *** 3D vectoren voor versnellingen ***

% 3D model vectors:
vec_23_cog3 = [-cog3_23_x    -cog3_23_y   zeros(size(phi2))];
vec_212_cog12 = [-cog12_212_x    -cog12_212_y   zeros(size(phi2))];
vec_vp7_cog7 = [-cog7_17_x    -cog7_17_y   zeros(size(phi2))];
vec_67_cog6 = [-cog6_67_x    -cog6_67_y   zeros(size(phi2))];
vec_vp7_67 = [-r7*cos(phi7)   -r7*sin(phi7) zeros(size(phi2))];
vec_68_cog8 = [-cog8_68_x    -cog8_68_y   zeros(size(phi2))];
vec_67_68 = [(r6k+r6l)*cos(phi6)   (r6k+r6l)*sin(phi6)  zeros(size(phi2))];
vec_67_56 = [r6k*cos(phi6)   r6k*sin(phi6)   zeros(size(phi2))];
vec_68_810 = [-(r8k+r8l)*cos(phi8)   -(r8k+r8l)*sin(phi8)  zeros(size(phi2))];

%Extra vectoren nodig:
vec_vp2_cog2 = [(X2*cos(phi2-pi/2))-(Y2*cos(phi2)) (X2*sin(phi2-pi/2))-(Y2*sin(phi2)) zeros(size(phi2))];
vec_212_cog2 = [-cog2_212_x    -cog2_212_y   zeros(size(phi2))];
vec_23_cog2 = [-cog2_23_x    -cog2_23_y   zeros(size(phi2))];
vec_23_34 = [r3*cos(phi3) r3*sin(phi3) zeros(size(phi2))];
vec_vp4_cog4 = [(-Y4*cos(phi4))+(X4*cos(phi4+pi/2))  (-Y4*sin(phi4))+(X4*sin(phi4+pi/2)) zeros(size(phi2))];       % moet hetzelfde zijn als vp4_34 maar Y4 ipv r2k en X4 ipv r2l                         
vec_vp4_cog5 = [-1*times(x5,cos(phi4))  -1*times(x5,sin(phi4))  zeros(size(phi2))];       % Moet kleine x5 zijn, want deze positie varieert continu + elk element apart vermenigvuldigen
vec_68_89 = [-r8k*cos(phi8)  -r8k*sin(phi8)  zeros(size(phi2))];
vec_1011_cog10 = [X10*cos(phi10)  X10*sin(phi10)  zeros(size(phi2))];  
vec_212_1112 = [r12*cos(phi12)  r12*sin(phi12)   zeros(size(phi2))];
vec_1011_810 = [r10*cos(phi10)  r10*sin(phi10)  zeros(size(phi2))];

vec_34_cog4 = [(-(r4k-X4)*cos(phi4+pi/2))+((r4l-Y4)*cos(phi4))  (-(r4k-X4)*sin(phi4+pi/2))+((r4l-Y4)*sin(phi4)) zeros(size(phi2))];       % moet hetzelfde zijn als vp4_34 maar (a-Y4) ipv a en (b-X4) ipv b + tegengesteld gericht


%% *** 3D versnellingsvectoren voor matrix B ***

% acceleration vectors
% bv. acc_2 = versnelling massacentrum van stang 2
%     acc_2_12 = versnelling van scharnierpunt 2,12

acc_2 =                cross(omega2,cross(omega2,vec_vp2_cog2)) +    cross(alpha2,vec_vp2_cog2);    % controle: = 0
acc_2_12 = acc_2 +     cross(omega2,cross(omega2,-vec_212_cog2)) +    cross(alpha2,-vec_212_cog2);
acc_2_3 = acc_2 +      cross(omega2,cross(omega2,-vec_23_cog2)) +     cross(alpha2,-vec_23_cog2);

acc_3 = acc_2_3 +      cross(omega3,cross(omega3,vec_23_cog3)) +     cross(alpha3,vec_23_cog3);
acc_3_4 = acc_2_3 +    cross(omega3,cross(omega3,vec_23_34)) +       cross(alpha3,vec_23_34);       % enkel nodig voor controle

acc_4 =                cross(omega4,cross(omega4,vec_vp4_cog4)) +    cross(alpha4,vec_vp4_cog4);
acc_4_check = acc_3_4 +cross(omega4,cross(omega4,vec_34_cog4))  +    cross(alpha4,vec_34_cog4);
%Deze controle klopt!

acc_7 =                cross(omega7,cross(omega7,vec_vp7_cog7)) +    cross(alpha7,vec_vp7_cog7);
acc_7_6 =              cross(omega7,cross(omega7,vec_vp7_67)) +      cross(alpha7,vec_vp7_67);

acc_6 = acc_7_6 +      cross(omega6,cross(omega6,vec_67_cog6)) +     cross(alpha6,vec_67_cog6);
acc_6_8 = acc_7_6 +    cross(omega6,cross(omega6,vec_67_68)) +       cross(alpha6,vec_67_68);

acc_5 = acc_7_6 +      cross(omega6,cross(omega6,vec_67_56)) +       cross(alpha6,vec_67_56);

acc_8 = acc_6_8 +      cross(omega8,cross(omega8,vec_68_cog8)) +     cross(alpha8,vec_68_cog8);
acc_8_9 = acc_6_8 +    cross(omega8,cross(omega8,vec_68_89))   +     cross(alpha8,vec_68_89);
acc_8_10 = acc_6_8+    cross(omega8,cross(omega8,vec_68_810))  +     cross(alpha8,vec_68_810);      % enkel nodig voor controle

acc_9 = [ddx9  zeros(size(phi2))  zeros(size(phi2))];           % controle: moet gelijk zijn aan acc_8_9
% Deze controle klopt!

acc_12 = acc_2_12 +    cross(omega12,cross(omega12,vec_212_cog12))+  cross(alpha12,vec_212_cog12);
acc_11_12 = acc_2_12 + cross(omega12,cross(omega12,vec_212_1112))+   cross(alpha12,vec_212_1112);

acc_11 = [-ddx11  zeros(size(phi2))  zeros(size(phi2))];        % controle: moet gelijk zijn aan acc_11_12
acc_10_11 = acc_11_12;                                          % controle: moet zo kloppen aangezien ze vast hangen + gelijk aan acc_11
% Deze controle klopt!

acc_10 = acc_10_11 +   cross(omega10,cross(omega10,vec_1011_cog10))+ cross(alpha10,vec_1011_cog10);
acc_10_8 = acc_10_11 + cross(omega10,cross(omega10,vec_1011_810))  + cross(alpha10,vec_1011_810);   % controle: = acc_8_10
% Deze controle klopt!

% controle versnellingen:

if fig_dyn_4bar
    
    screen_size = get(groot, 'ScreenSize');
    figure('Name', 'Controle versnellingen dynamica (1)', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(3,1,1)
    plot(t, acc_8_9 - acc_9)
    ylabel('\Delta versnelling cog9 [m/s�]')   
    
    subplot(3,1,2)
    plot(t, acc_8_9)
    ylabel('acc_8_9 [m/s�]')
    
    subplot(3,1,3)
    plot(t, acc_9)
    ylabel('acc_9 [m/s�]')
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Controle versnelling cog9 dynamisch'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
    
    figure('Name', 'Controle versnellingen dynamica (2)', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(3,1,1)
    plot(t, acc_11_12 - acc_11)
    ylabel('\Delta versnelling cog11 [m/s�]')   
    
    subplot(3,1,2)
    plot(t, acc_11_12)
    ylabel('acc_11_12 [m/s�]')
    
    subplot(3,1,3)
    plot(t, acc_11)
    ylabel('acc_11 [m/s�]')
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Controle versnelling cog11 dynamisch'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
    figure('Name', 'Controle versnellingen dynamica (3)', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(3,1,1)
    plot(t, acc_8_10 - acc_10_8)
    ylabel('\Delta versnelling 8,10 [m/s�]')   
    
    subplot(3,1,2)
    plot(t, acc_8_10)
    ylabel('acc_8_10 [m/s�]')
    
    subplot(3,1,3)
    plot(t, acc_10_8)
    ylabel('acc_10_8 [m/s�]')
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Controle versnelling 8,10 dynamisch'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
    
    figure('Name', 'Controle versnellingen dynamica (4)', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(3,1,1)
    plot(t, acc_4 - acc_4_check)
    ylabel('\Delta versnelling cog4 [m/s�]')   
    
    subplot(3,1,2)
    plot(t, acc_4)
    ylabel('acc_4 [m/s�]')
    
    subplot(3,1,3)
    plot(t, acc_4_check)
    ylabel('acc_4_check [m/s�]')
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Controle versnelling cog4 dynamisch'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
end 

% Declaratie van de deelversnellingen voor matrix B:
acc_2x = acc_2(:,1);
acc_2y = acc_2(:,2);
acc_3x = acc_3(:,1);
acc_3y = acc_3(:,2);
acc_4x = acc_4(:,1);
acc_4y = acc_4(:,2);
acc_5x = acc_5(:,1);
acc_5y = acc_5(:,2);
acc_6x = acc_6(:,1);
acc_6y = acc_6(:,2);
acc_7x = acc_7(:,1);
acc_7y = acc_7(:,2);
acc_8x = acc_8(:,1);
acc_8y = acc_8(:,2);
acc_9x = acc_9(:,1);
acc_9y = acc_9(:,2);
acc_10x = acc_10(:,1);
acc_10y = acc_10(:,2);
acc_11x = acc_11(:,1);
acc_11y = acc_11(:,2);
acc_12x = acc_12(:,1);
acc_12y = acc_12(:,2);


%% *** Dynamische analyse ***

% **********************
% *** force analysis ***
% **********************

% allocate matrices for force (F) and moment (M)
F12x = zeros(size(phi2));
F12y = zeros(size(phi2));
F23x = zeros(size(phi2));
F23y = zeros(size(phi2));
F212x = zeros(size(phi2));
F67y = zeros(size(phi2));
F68x = zeros(size(phi2));
F212y = zeros(size(phi2));
F34x = zeros(size(phi2));
F34y = zeros(size(phi2));
F14x = zeros(size(phi2));
F14y = zeros(size(phi2));
F45 = zeros(size(phi2));
F56x = zeros(size(phi2));
F56y = zeros(size(phi2));
F67x = zeros(size(phi2));
F68y = zeros(size(phi2));
F17x = zeros(size(phi2));
F17y = zeros(size(phi2));
F89x = zeros(size(phi2));
F89y = zeros(size(phi2));
F810x = zeros(size(phi2));
F810y = zeros(size(phi2));
F19 = zeros(size(phi2));
F1011x = zeros(size(phi2));
F1011y = zeros(size(phi2));
F1112x = zeros(size(phi2));
F1112y = zeros(size(phi2));
F111 = zeros(size(phi2));
M12 = zeros(size(phi2));
M19 = zeros(size(phi2));
M111 = zeros(size(phi2));
M45 = zeros(size(phi2));


% calculate dynamics for each time step
t_size = size(t,1);    % number of simulation steps

for k=1:t_size
    
%       F12x        F12y         F23x          F23y          F212x           F212y           F34x          F34y               F14x       F14y        F45          F56x          F56y         F67x          F67y          F68x          F68y          F17x          F17y          F89x          F89y          F810x           F810y          F19         F1011x           F1011y          F1112x           F1112y          F111        M12         M19          M111        M45
  A = [ 1           0            1             0             1               0               0             0                  0          0           0            0             0            0             0             0             0             0             0             0             0             0               0              0           0                0               0                0               0           0           0            0           0;
        0           1            0             1             0               1               0             0                  0          0           0            0             0            0             0             0             0             0             0             0             0             0               0              0           0                0               0                0               0           0           0            0           0;
        0           0            -cog2_23_y(k) cog2_23_x(k) -cog2_212_y(k)   cog2_212_x(k)   0             0                  0          0           0            0             0            0             0             0             0             0             0             0             0             0               0              0           0                0               0                0               0           1           0            0           0;
        0           0           -1             0             0               0              -1             0                  0          0           0            0             0            0             0             0             0             0             0             0             0             0               0              0           0                0               0                0               0           0           0            0           0;
        0           0            0            -1             0               0               0            -1                  0          0           0            0             0            0             0             0             0             0             0             0             0             0               0              0           0                0               0                0               0           0           0            0           0;
        0           0            cog3_23_y(k) -cog3_23_x(k)  0               0               cog3_34_y(k) -cog3_34_x(k)       0          0           0            0             0            0             0             0             0             0             0             0             0             0               0              0           0                0               0                0               0           0           0            0           0;
        0           0            0             0             0               0               1             0                  1          0           proj_45_x(k) 0             0            0             0             0             0             0             0             0             0             0               0              0           0                0               0                0               0           0           0            0           0;
        0           0            0             0             0               0               0             1                  0          1           proj_45_y(k) 0             0            0             0             0             0             0             0             0             0             0               0              0           0                0               0                0               0           0           0            0           0;
        0           0            0             0             0               0              -vp4_34_y(k)   vp4_34_x(k)        0          0           vp4_45(k)    0             0            0             0             0             0             0             0             0             0             0               0              0           0                0               0                0               0           0           0            0           1;
        0           0            0             0             0               0               0             0                  0          0          -proj_45_x(k) 1             0            0             0             0             0             0             0             0             0             0               0              0           0                0               0                0               0           0           0            0           0;
        0           0            0             0             0               0               0             0                  0          0          -proj_45_y(k) 0             1            0             0             0             0             0             0             0             0             0               0              0           0                0               0                0               0           0           0            0           0;
        0           0            0             0             0               0               0             0                  0          0           0            0             0            0             0             0             0             0             0             0             0             0               0              0           0                0               0                0               0           0           0            0          -1;
        0           0            0             0             0               0               0             0                  0          0           0           -1             0           -1             0            -1             0             0             0             0             0             0               0              0           0                0               0                0               0           0           0            0           0;
        0           0            0             0             0               0               0             0                  0          0           0            0            -1            0            -1             0            -1             0             0             0             0             0               0              0           0                0               0                0               0           0           0            0           0;
        0           0            0             0             0               0               0             0                  0          0           0            cog6_56_y(k) -cog6_56_x(k) cog6_67_y(k) -cog6_67_x(k)  cog6_68_y(k) -cog6_68_x(k)  0             0             0             0             0               0              0           0                0               0                0               0           0           0            0           0;
        0           0            0             0             0               0               0             0                  0          0           0            0             0            1             0             0             0             1             0             0             0             0               0              0           0                0               0                0               0           0           0            0           0;
        0           0            0             0             0               0               0             0                  0          0           0            0             0            0             1             0             0             0             1             0             0             0               0              0           0                0               0                0               0           0           0            0           0;
        0           0            0             0             0               0               0             0                  0          0           0            0             0           -cog7_67_y(k)  cog7_67_x(k)  0             0            -cog7_17_y(k)  cog7_17_x(k)  0             0             0               0              0           0                0               0                0               0           0           0            0           0;
        0           0            0             0             0               0               0             0                  0          0           0            0             0            0             0             1             0             0             0             1             0             1               0              0           0                0               0                0               0           0           0            0           0;
        0           0            0             0             0               0               0             0                  0          0           0            0             0            0             0             0             1             0             0             0             1             0               1              0           0                0               0                0               0           0           0            0           0;
        0           0            0             0             0               0               0             0                  0          0           0            0             0            0             0            -cog8_68_y(k)  cog8_68_x(k)  0             0            -cog8_89_y(k)  cog8_89_x(k) -cog8_810_y(k)   cog8_810_x(k)  0           0                0               0                0               0           0           0            0           0;
        0           0            0             0             0               0               0             0                  0          0           0            0             0            0             0             0             0             0             0            -1             0             0               0              0           0                0               0                0               0           0           0            0           0;
        0           0            0             0             0               0               0             0                  0          0           0            0             0            0             0             0             0             0             0             0            -1             0               0             -1           0                0               0                0               0           0           0            0           0;
        0           0            0             0             0               0               0             0                  0          0           0            0             0            0             0             0             0             0             0             0             0             0               0              0           0                0               0                0               0           0          -1            0           0;
        0           0            0             0             0               0               0             0                  0          0           0            0             0            0             0             0             0             0             0             0             0            -1               0              0          -1                0               0                0               0           0           0            0           0;
        0           0            0             0             0               0               0             0                  0          0           0            0             0            0             0             0             0             0             0             0             0             0              -1              0           0               -1               0                0               0           0           0            0           0;
        0           0            0             0             0               0               0             0                  0          0           0            0             0            0             0             0             0             0             0             0             0             cog10_810_y(k) -cog10_810_x(k) 0           cog10_1011_y(k) -cog10_1011_x(k) 0                0               0           0           0            0           0;      
        0           0            0             0             0               0               0             0                  0          0           0            0             0            0             0             0             0             0             0             0             0             0               0              0           1                0               1                0               0           0           0            0           0;
        0           0            0             0             0               0               0             0                  0          0           0            0             0            0             0             0             0             0             0             0             0             0               0              0           0                1               0                1               1           0           0            0           0;
        0           0            0             0             0               0               0             0                  0          0           0            0             0            0             0             0             0             0             0             0             0             0               0              0          -cog11_1011_y(k)  0              -cog11_111_y(k)   0               0           0           0            1           0;
        0           0            0             0            -1               0               0             0                  0          0           0            0             0            0             0             0             0             0             0             0             0             0               0              0           0                0              -1                0               0           0           0            0           0;
        0           0            0             0             0              -1               0             0                  0          0           0            0             0            0             0             0             0             0             0             0             0             0               0              0           0                0               0               -1               0           0           0            0           0;
        0           0            0             0             cog12_212_y(k) -cog12_212_x(k)  0             0                  0          0           0            0             0            0             0             0             0             0             0             0             0             0               0              0           0                0               cog12_1112_y(k) -cog12_1112_x(k) 0           0           0            0           0];
%       F12x        F12y         F23x          F23y          F212x           F212y           F34x          F34y               F14x       F14y        F45          F56x          F56y         F67x          F67y          F68x          F68y          F17x          F17y          F89x          F89y          F810x           F810y          F19         F1011x           F1011y          F1112x           F1112y          F111        M12         M19          M111        M45


  B = [ m2*acc_2x(k);
        m2*(acc_2y(k)+g);
        J2*ddphi2(k);               
        m3*acc_3x(k);
        m3*(acc_3y(k)+g);
        J3*ddphi3(k);
        m4*acc_4x(k);
        m4*(acc_4y(k)+g);
        (J4+(X4^2+Y4^2)*m4)*ddphi4(k) + m4*g*vec_vp4_cog4(k,1);
        m5*acc_5x(k);
        m5*(acc_5y(k)+g);
        J5*ddphi4(k);
        m6*acc_6x(k);
        m6*(acc_6y(k)+g);
        J6*ddphi6(k);
        m7*acc_7x(k);
        m7*(acc_7y(k)+g);
        J7*ddphi7(k);
        m8*acc_8x(k);
        m8*(acc_8y(k)+g);
        J8*ddphi8(k);
        m9*acc_9x(k);
        m9*(acc_9y(k)+g);
        0;
        m10*acc_10x(k);
        m10*(acc_10y(k)+g);
        J10*ddphi10(k);
        m11*acc_11x(k);
        m11*(acc_11y(k)+g);
        0;
        m12*acc_12x(k);
        m12*(acc_12y(k)+g);
        J12*ddphi12(k)];
        
    
    x = A\B;
    
    % save results
    F12x(k) = x(1);
    F12y(k) = x(2);
    F23x(k) = x(3);
    F23y(k) = x(4);
    F212x(k) = x(5);
    F212y(k) = x(6);
    F34x(k) = x(7);
    F34y(k) = x(8);
    F14x(k) = x(9);
    F14y(k) = x(10);
    F45(k) = x(11);
    F56x(k) = x(12);
    F56y(k) = x(13);
    F67x(k) = x(14);
    F67y(k) = x(15);
    F68x(k) = x(16);
    F68y(k) = x(17);
    F17x(k) = x(18);
    F17y(k) = x(19);
    F89x(k) = x(20);
    F89y(k) = x(21);
    F810x(k) = x(22);
    F810y(k) = x(23);
    F19(k) = x(24);
    F1011x(k) = x(25);
    F1011y(k) = x(26);
    F1112x(k) = x(27);
    F1112y(k) = x(28);
    F111(k) = x(29);
    M12(k) = x(30);
    M19(k) = x(31);
    M111(k) = x(32);
    M45(k) = x(33);
  
end


%% *** Figuren plotten ***


% **********************
% *** plot figures ***
% **********************


if fig_dyn_4bar
    
    screen_size = get(groot, 'ScreenSize');
    
    figure('Name', 'Krachten', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(6,2,1)
    plot(t, F12x)
    ylabel('F12x (a_x) [N]')
    subplot(6,2,2)
    plot(t, F12y)
    ylabel('F12y (a_y) [N]')
    subplot(6,2,3)
    plot(t, F212x)
    ylabel('F212x (b_x) [N]')
    subplot(6,2,4)
    plot(t, F212y)
    ylabel('F212y (b_y) [N]')
    subplot(6,2,5)
    plot(t, F23x)
    ylabel('F23x (c_x) [N]')
    subplot(6,2,6)
    plot(t, F23y)
    ylabel('F23y (c_y) [N]')
    subplot(6,2,7)
    plot(t, F34x)
    ylabel('F34x (d_x) [N]')
    subplot(6,2,8)
    plot(t, F34y)
    ylabel('F34y (d_y) [N]')
    subplot(6,2,9)
    plot(t, F45)
    ylabel('F45 (e_F) [N]')
    subplot(6,2,10)
    plot(t, M45)
    ylabel('M45 (e_M) [Nm]')
    subplot(6,2,11)
    plot(t, F56x)
    ylabel('F56x (f_x) [N]') 
    subplot(6,2,12)
    plot(t, F56y)
    ylabel('F56y (f_y) [N]')
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Krachten en momenten in functie van de tijd in s (1)'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
    
    figure('Name', 'Krachten(2)', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(5,2,1)
    plot(t, F14x)
    ylabel('F14x (g_x) [N]')
    subplot(5,2,2)
    plot(t, F14y)
    ylabel('F14y (g_y) [N]')
    subplot(5,2,3)
    plot(t, F67x)
    ylabel('F67x (h_x) [N]')
    subplot(5,2,4)
    plot(t, F67y)
    ylabel('F67y (h_y) [N]')
    subplot(5,2,5)
    plot(t, F17x)
    ylabel('F17x (i_x) [N]')
    subplot(5,2,6)
    plot(t, F17y)
    ylabel('F17y (i_y) [N]')
    subplot(5,2,7)
    plot(t, F68x)
    ylabel('F68x (j_x) [N]')
    subplot(5,2,8)
    plot(t, F68y)
    ylabel('F68y (j_y) [N]')
    subplot(5,2,9)
    plot(t, F19)
    ylabel('F19 (k_F) [N]')
    subplot(5,2,10)
    plot(t, M19)
    ylabel('M19 (k_M) [Nm]')
    
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Krachten en momenten in functie van de tijd in s (2)'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
 
    figure('Name', 'Krachten(3)', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    
    subplot(5,2,1)
    plot(t, F89x)
    ylabel('F89x (l_x) [N]') 
    subplot(5,2,2)
    plot(t, F89y)
    ylabel('F89y (l_y) [N]')   
    subplot(5,2,3)
    plot(t, F810x)
    ylabel('F810x (m_x) [N]')
    subplot(5,2,4)
    plot(t, F810y)
    ylabel('F810y (m_y) [N]')
    subplot(5,2,5)
    plot(t, F1011x)
    ylabel('F1011x (n_x) [N]')
    subplot(5,2,6)
    plot(t, F1011y)
    ylabel('F1011y (n_y) [N]')
    subplot(5,2,7)
    plot(t, F111)
    ylabel('F111 (o_F) [N]')
    subplot(5,2,8)
    plot(t, M111)
    ylabel('M111 (o_M) [Nm]')
    subplot(5,2,9)
    plot(t, F1112x)
    ylabel('F1112x (p_x) [N]')
    subplot(5,2,10)
    plot(t, F1112y)
    ylabel('F1112y (p_y) [N]')
        
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Krachten en momenten in functie van de tijd in s (3)'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
    
    figure('Name', 'Aandrijfmoment', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(1,1,1)
    plot(t, M12)
    ylabel('M12 (A) [Nm]')   
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Aandrijfmoment in functie van de tijd in s'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
end

%% *** Controle: variatie van (kinetische) energie ***


% Gewichten stangen:

G2 = [zeros(size(phi2)) -m2*g*ones(size(phi2)) zeros(size(phi2))];
G3 = [zeros(size(phi2)) -m3*g*ones(size(phi2)) zeros(size(phi2))];
G4 = [zeros(size(phi2)) -m4*g*ones(size(phi2)) zeros(size(phi2))];
G5 = [zeros(size(phi2)) -m5*g*ones(size(phi2)) zeros(size(phi2))];
G6 = [zeros(size(phi2)) -m6*g*ones(size(phi2)) zeros(size(phi2))];
G7 = [zeros(size(phi2)) -m7*g*ones(size(phi2)) zeros(size(phi2))];
G8 = [zeros(size(phi2)) -m8*g*ones(size(phi2)) zeros(size(phi2))];
G9 = [zeros(size(phi2)) -m9*g*ones(size(phi2)) zeros(size(phi2))];
G10= [zeros(size(phi2)) -m10*g*ones(size(phi2)) zeros(size(phi2))];
G11= [zeros(size(phi2)) -m11*g*ones(size(phi2)) zeros(size(phi2))];
G12= [zeros(size(phi2)) -m12*g*ones(size(phi2)) zeros(size(phi2))];


% Snelheden massacentra en benodigde punten:

vel_2 =                cross(omega2,vec_vp2_cog2);      % normaal gezien nul
vel_2_12 = vel_2 +     cross(omega2,-vec_212_cog2);
vel_2_3 = vel_2 +      cross(omega2,-vec_23_cog2);

vel_3 = vel_2_3 +      cross(omega3,vec_23_cog3);
vel_3_4 = vel_2_3 +    cross(omega3,vec_23_34);         % enkel nodig voor controle

vel_4 =                cross(omega4,vec_vp4_cog4);
vel_4_check = vel_3_4 +cross(omega4,vec_34_cog4);

vel_5_lin = [-1*times(dx5,cos(phi4))  -1*times(dx5,sin(phi4))  zeros(size(phi2))];  % times(A,B) geeft de vector terug waar elk element van A vermenigvuldigd wordt met het overeenkomstige element van B
vel_5 = vel_5_lin +    cross(omega4,vec_vp4_cog5);

vel_7 =                cross(omega7,vec_vp7_cog7);
vel_7_6 =              cross(omega7,vec_vp7_67);

vel_6 = vel_7_6 +      cross(omega6,vec_67_cog6);
vel_6_8 = vel_7_6 +    cross(omega6,vec_67_68);

vel_8 = vel_6_8 +      cross(omega8,vec_68_cog8);
vel_8_9 = vel_6_8 +    cross(omega8,vec_68_89);
vel_8_10 = vel_6_8+    cross(omega8,vec_68_810);        % enkel nodig voor controle

vel_9 = [dx9  zeros(size(phi2))  zeros(size(phi2))];    % controle: moet gelijk zijn aan vel_8_9

vel_12 = vel_2_12 +    cross(omega12,vec_212_cog12);
vel_11_12 = vel_2_12 + cross(omega12,vec_212_1112);

vel_11 = [-dx11  zeros(size(phi2))  zeros(size(phi2))]; % controle: moet gelijk zijn aan vel_11_12
vel_10_11 = vel_11_12;                                  % controle: moet zo kloppen aangezien ze vast hangen + gelijk aan vel_11

vel_10_8 = vel_10_11 + cross(omega10,vec_1011_810);

vel_10 = vel_10_11 +   cross(omega10,vec_1011_cog10);

% Controles van de snelheden:

if fig_dyn_4bar
    
    screen_size = get(groot, 'ScreenSize');
    figure('Name', 'Controle snelheden dynamica (1)', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(3,1,1)
    plot(t, vel_8_9 - vel_9)
    ylabel('\Delta snelheid cog9 [m/s]')   
    
    subplot(3,1,2)
    plot(t, vel_8_9)
    ylabel('vel_8_9 [m/s]')
    
    subplot(3,1,3)
    plot(t, vel_9)
    ylabel('vel_9 [m/s]')
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Controle snelheid cog9 dynamisch'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
    
    figure('Name', 'Controle snelheden dynamica (2)', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(3,1,1)
    plot(t, vel_11_12 - vel_11)
    ylabel('\Delta snelheid cog11 [m/s]')   
    
    subplot(3,1,2)
    plot(t, vel_11_12)
    ylabel('vel_11_12 [m/s�]')
    
    subplot(3,1,3)
    plot(t, vel_11)
    ylabel('vel_11 [m/s�]')
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Controle snelheid cog11 dynamisch'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
    figure('Name', 'Controle snelheden dynamica (3)', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(3,1,1)
    plot(t, vel_8_10 - vel_10_8)
    ylabel('\Delta snelheid 8,10 [m/s]')   
    
    subplot(3,1,2)
    plot(t, vel_8_10)
    ylabel('vel_8_10 [m/s]')
    
    subplot(3,1,3)
    plot(t, vel_10_8)
    ylabel('vel_10_8 [m/s]')
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Controle snelheid 8,10 dynamisch'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
    
    figure('Name', 'Controle snelheden dynamica (4)', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(3,1,1)
    plot(t, vel_4 - vel_4_check)
    ylabel('\Delta snelheid cog4 [m/s]')   
    
    subplot(3,1,2)
    plot(t, vel_4)
    ylabel('vel_4 [m/s]')
    
    subplot(3,1,3)
    plot(t, vel_4_check)
    ylabel('vel_4 check [m/s]')
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Controle snelheid cog4 dynamisch'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
end 



% Declaratie van de deelsnelheden voor variatie van kinetische energie:
vel_2x = vel_2(:,1);
vel_2y = vel_2(:,2);
vel_3x = vel_3(:,1);
vel_3y = vel_3(:,2);
vel_4x = vel_4(:,1);
vel_4y = vel_4(:,2);
vel_5x = vel_5(:,1);
vel_5y = vel_5(:,2);
vel_6x = vel_6(:,1);
vel_6y = vel_6(:,2);
vel_7x = vel_7(:,1);
vel_7y = vel_7(:,2);
vel_8x = vel_8(:,1);
vel_8y = vel_8(:,2);
vel_9x = vel_9(:,1);
vel_9y = vel_9(:,2);
vel_10x = vel_10(:,1);
vel_10y = vel_10(:,2);
vel_11x = vel_11(:,1);
vel_11y = vel_11(:,2);
vel_12x = vel_12(:,1);
vel_12y = vel_12(:,2);


% Berekening vermogen

M12_controle = zeros(size(phi2));

vec_M12 = [zeros(size(phi2))  zeros(size(phi2))  M12_controle];

P = dot(G2,vel_2,2) + dot(G3,vel_3,2) + dot(G4,vel_4,2) + dot(G5,vel_5,2) ...
    + dot(G6,vel_6,2) + dot(G7,vel_7,2) + dot(G8,vel_8,2) + dot(G9,vel_9,2) + dot(G10,vel_10,2) ...
    + dot(G11,vel_11,2) + dot(G12,vel_12,2);
% dot(A,B,2) werkt het inwendig product uit, maar behandeld de rijen als
% vectoren ipv de kolommen

% Variatie van kinetische energie:

dE_kin = m2*dot(vel_2,acc_2,2) + m3*dot(vel_3,acc_3,2) + m4*dot(vel_4,acc_4,2) + m5*dot(vel_5,acc_5,2) ...
       + m6*dot(vel_6,acc_6,2) + m7*dot(vel_7,acc_7,2) + m8*dot(vel_8,acc_8,2) + m9*dot(vel_9,acc_9,2) ...
       + m10*dot(vel_10,acc_10,2) + m11*dot(vel_11,acc_11,2) + m12*dot(vel_12,acc_12,2) ...
       + J2*dot(omega2,alpha2,2) + J3*dot(omega3,alpha3,2) + J4*dot(omega4,alpha4,2) ...
       + J6*dot(omega6,alpha6,2) + J7*dot(omega7,alpha7,2) + J8*dot(omega8,alpha8,2) ...
       + J10*dot(omega10,alpha10,2) + J12*dot(omega12,alpha12,2) + J5*dot(omega4,alpha4,2);
	

M12_check = times((dphi2.^-1),(dE_kin - P));                     % .^ verheft elk element van de matrix/vector tot de macht die er bijstaat

if fig_dyn_4bar
    
    screen_size = get(groot, 'ScreenSize');
    figure('Name', 'Controle aandrijfmoment', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/3])
    
    subplot(1,2,1)
    plot(t, M12)
    ylabel('M12 [Nm]')
       
    subplot(1,2,2)
    plot(t, M12-M12_check)
    ylabel('\DeltaM12 [Nm]')
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Controle aandrijfmoment M12'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
end

%% *** Controle: conservatie van momentum ***

% We defini�ren alle hulpvectoren voor de vectoren van het rotatie punt O tot de massa centra
% We nemen als punt O (waarrond alles roteert) het vaste punt 1,2
vec_cog2_23 = -1*vec_23_cog2;
vec_34_vp4 = vec_34_cog4 - vec_vp4_cog4;
vec_34_cog5 = vec_34_vp4 + vec_vp4_cog5;    % cog5 is ook het punt 5,6 normaal gezien
vec_cog5_67 = [-(r6k*cos(phi6))  -(r6k*sin(phi6))  zeros(size(phi2))];
vec_67_vp7 = -1*vec_vp7_67;
vec_cog5_68 = [(r6l*cos(phi6))  (r6l*sin(phi6))  zeros(size(phi2))];
vec_68_cog9 = vec_68_89;                    % cog9 is ook het punt 8,9 normaal gezien
vec_cog2_212 = -1*vec_212_cog2;
vec_1112_cog11 = [X11*ones(size(phi2))  -Y11*ones(size(phi2))   zeros(size(phi2))];
vec_1112_1011 = [zeros(size(phi2))   -r11*ones(size(phi2))  zeros(size(phi2))];

% We defini�ren alle vectoren van het rotatie punt O tot de massa centra
vec_vp2_cog3 = vec_vp2_cog2 + vec_cog2_23 + vec_23_cog3;
vec_vp2_cog4 = vec_vp2_cog2 + vec_cog2_23 + vec_23_34 + vec_34_cog4;
vec_vp2_cog5 = vec_vp2_cog2 + vec_cog2_23 + vec_23_34 + vec_34_cog5;
vec_vp2_cog6 = vec_vp2_cog2 + vec_cog2_23 + vec_23_34 + vec_34_cog5 + vec_cog5_67 + vec_67_cog6;
vec_vp2_cog7 = vec_vp2_cog2 + vec_cog2_23 + vec_23_34 + vec_34_cog5 + vec_cog5_67 + vec_67_vp7 ...
                + vec_vp7_cog7;
vec_vp2_cog8 = vec_vp2_cog2 + vec_cog2_23 + vec_23_34 + vec_34_cog5 + vec_cog5_68 + vec_68_cog8;
vec_vp2_cog9 = vec_vp2_cog2 + vec_cog2_23 + vec_23_34 + vec_34_cog5 + vec_cog5_68 + vec_68_cog9;

vec_vp2_cog12 = vec_vp2_cog2 + vec_cog2_212 + vec_212_cog12;
vec_vp2_cog11 = vec_vp2_cog2 + vec_cog2_212 + vec_212_1112 + vec_1112_cog11;
vec_vp2_cog10 = vec_vp2_cog2 + vec_cog2_212 + vec_212_1112 + vec_1112_1011 + vec_1011_cog10;

% Dit geeft bij de controle shaking forces en moment:

F_shak_x_check = -1*(m2*acc_2x + m3*acc_3x + m4*acc_4x + m5*acc_5x + m6*acc_6x ...
                + m7*acc_7x + m8*acc_8x + m9*acc_9x + m10*acc_10x ...
                + m11*acc_11x + m12*acc_12x);
            
F_shak_y_check = -1*(m2*(acc_2y) + m3*(acc_3y) + m4*(acc_4y) + m5*(acc_5y) + m6*(acc_6y) ...
                + m7*(acc_7y) + m8*(acc_8y) + m9*(acc_9y) + m10*(acc_10y) ...
                + m11*(acc_11y) + m12*(acc_12y));
            
M_shak_check = -1*(J2*ddphi2 + J3*ddphi3 + J4*ddphi4 + J5*ddphi4 + J6*ddphi6 + J7*ddphi7 ...
                + J8*ddphi8 + J10*ddphi10 + J12*ddphi12) ...
                -(  (m2*(times(vec_vp2_cog2(:,1),acc_2y) - times(vec_vp2_cog2(:,2),acc_2x))) ...
                  + (m3*(times(vec_vp2_cog3(:,1),acc_3y) - times(vec_vp2_cog3(:,2),acc_3x))) ...
                  + (m4*(times(vec_vp2_cog4(:,1),acc_4y) - times(vec_vp2_cog4(:,2),acc_4x))) ...
                  + (m5*(times(vec_vp2_cog5(:,1),acc_5y) - times(vec_vp2_cog5(:,2),acc_5x))) ...
                  + (m6*(times(vec_vp2_cog6(:,1),acc_6y) - times(vec_vp2_cog6(:,2),acc_6x))) ...
                  + (m7*(times(vec_vp2_cog7(:,1),acc_7y) - times(vec_vp2_cog7(:,2),acc_7x))) ...
                  + (m8*(times(vec_vp2_cog8(:,1),acc_8y) - times(vec_vp2_cog8(:,2),acc_8x))) ...
                  + (m9*(times(vec_vp2_cog9(:,1),acc_9y) - times(vec_vp2_cog9(:,2),acc_9x))) ...
                  + (m10*(times(vec_vp2_cog10(:,1),acc_10y) - times(vec_vp2_cog10(:,2),acc_10x))) ...
                  + (m11*(times(vec_vp2_cog11(:,1),acc_11y) - times(vec_vp2_cog11(:,2),acc_11x))) ...
                  + (m12*(times(vec_vp2_cog12(:,1),acc_12y) - times(vec_vp2_cog12(:,2),acc_12x))) );

% tweede manier om M_shak_check te berekenen. Geeft zelfde resultaat
tussenuitkomst = m2*cross(vec_vp2_cog2, acc_2) + m3*cross(vec_vp2_cog3, acc_3) ...
                + m4*cross(vec_vp2_cog4, acc_4) + m5*cross(vec_vp2_cog5, acc_5) ...
                + m6*cross(vec_vp2_cog6, acc_6) + m7*cross(vec_vp2_cog7, acc_7) ...
                + m8*cross(vec_vp2_cog8, acc_8) + m9*cross(vec_vp2_cog9, acc_9) ...
                + m10*cross(vec_vp2_cog10, acc_10) + m11*cross(vec_vp2_cog11, acc_11) ...
                + m12*cross(vec_vp2_cog12, acc_12);

M_shak_check = - (J2*ddphi2 + J3*ddphi3 + J4*ddphi4 + J5*ddphi4 + J6*ddphi6 ...
                + J7*ddphi7 + J8*ddphi8 + J10*ddphi10 + J12*ddphi12 ...
                + tussenuitkomst(:,3));
            
tussenuitkomst_shaking_moment = cross(vec_vp2_cog2,G2) + cross(vec_vp2_cog3,G3) ...
+ cross(vec_vp2_cog4,G4) + cross(vec_vp2_cog5,G5) ...
+ cross(vec_vp2_cog6,G6) + cross(vec_vp2_cog7,G7) ...
+ cross(vec_vp2_cog8,G8) + cross(vec_vp2_cog9,G9) ...
+ cross(vec_vp2_cog10,G10) + cross(vec_vp2_cog11,G11) ...
+ cross(vec_vp2_cog12,G12);
            

              
% De werkelijke shaking forces en moment zijn:
F_shak_x = -(F12x + F17x + F14x);                            
F_shak_y = -(F12y + F17y + F14y - F19 + F111 - m2*g - m3*g - m4*g - m5*g - m6*g - m7*g - m8*g - m9*g - m10*g - m11*g - m12*g);
M_shak = -(M12 - M19 + M111 + F14y*x4 - F14x*y4 + F17y*x7 - F17x*y7 - F19.*(r2l+r12+x9) + F111.*(r2l+r12-x11) + tussenuitkomst_shaking_moment(:,3));

% Plotten van controle:
if fig_dyn_4bar
    
    screen_size = get(groot, 'ScreenSize');    
    figure('Name', 'Controle shaking forces', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(3,2,1)
    plot(t, F_shak_x)
    ylabel('F_{shak,x} [N]')  
    
    subplot(3,2,2)
    plot(t, F_shak_x - F_shak_x_check)
    ylabel('\Delta F_{shak,x} [N]')
    
    subplot(3,2,3)
    plot(t, F_shak_y)
    ylabel('F_{shak,y} [N]')
    
    subplot(3,2,4)
    plot(t, F_shak_y - F_shak_y_check)
    ylabel('\Delta F_{shak,y} [N]')
    
    subplot(3,2,5)
    plot(t, M_shak )
    ylabel('M_{shak} [Nm]')
    
    subplot(3,2,6)
    plot(t, M_shak - M_shak_check)
    ylabel('\Delta M_{shak} [Nm]')
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Controle shaking forces'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
    
end



