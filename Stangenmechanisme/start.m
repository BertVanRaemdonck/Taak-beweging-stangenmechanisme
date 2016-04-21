clear
close all


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data initialization (all data is converted to SI units)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% program data
fig_kin_4bar = 1;        % draw figures of kinematic analysis if 1
fig_dyn_4bar = 1;        % draw figures of dynamic analysis if 1
fig_forward_dyn = 1;     % draw figures of forward dynamic if 1

% kinematic parameters (link lengths)
conv = 0.19;                % conversie factor reële waardes en lengtes simulatie programma

r2k = 1.203 * conv;         % eccentric crank circle diameter
r2l = 2.0 * conv;           % 'langere' zijde van de eccentric crank
r3 = 9.750 * conv;          % eccentric rod
r4l = 3.021 * conv;         % vervang lengte van link crank (dg) (verticaal) = link crank vert
r4k = 0.801 * conv;         % vervang lengte van link crank (dg) (horizontaal) = link crank back set
r6k = 1.625 * conv;         % radius rod extension
r6l = 9.125 * conv;         % radius rod
r7 = 1.625 * conv;          % lifting link
r8k = 0.336 * conv;         % combination lever upper
r8l = 3.664 * conv;         % combination lever lower
r10 = 2.922 * conv;         % union link
r11 = 1 * conv;             % drop link to cross head vert
r12 = 16.5 * conv;          % main rod

x4 = 10.297 * conv;         % link center pivot horizontal
y4 = 3.500 * conv;          % link center pivot vertical
rev_arm_angle = asin(1.30/2.344);                 % hoek tussen horizontale en lifting arm in de uiterste stand
x7 = (6.164 + 2.75 * cos(rev_arm_angle)) * conv;  % horizontale positie scharnier 1-7 = reverse arm pivot hor + lifting arm length (met hoekcorrectie)
y7 = (5.031 - 2.75 * sin(rev_arm_angle)) * conv;  % verticale positie scharnier 1-7 = reverse arm pivot vert + ligting arm length (met hoekcorrectie)
y9 = 3.5 * conv;            % valve CL to cyl CL

phi1 = 0;                   


% Definitie extra parameters:   +- arbitrair gekozen
breedte5 = 0.05;            % breedte schuifscharnier
hoogte5 = 0.05;             % hoogte schuifscharnier
breedte9 = 0.2;             % breedte piston1, stang 9
hoogte9 = 0.1;              % hoogte piston1, stang 9
breedte11 = 0.3;            % breedte piston2, stang 11
hoogte11 = 0.2;             % hoogte piston2, stang11


R_wiel = 7.875/2 * conv;

rho_l1 = 14.72;                 % massa per lengte stang, alles behalve drijfstang
rho_l2 = 71.76;                 % massa per lengte drijfstang

m2 = 1.2 * 2*pi*R_wiel*rho_l2;  % stang 2 = wiel met velg met sectie ~ stang 12 + correctiefactor voor spaken
m3 = r3 * rho_l1;
m4 = (r4l+r4k) * rho_l1;        % totale massa van stang 4, ma en mb zijn de massa's van de aparte delen
ma = r4l * rho_l1;
mb = r4k * rho_l1;
m5 = 1;                         % massa van schuifscharnier
m6 = (r6k+r6l) * rho_l1;        % totale massa van stang 6, m6k en m6l zijn de massa's van de aparte delen
m6k = r6k * rho_l1;
m6l = r6l * rho_l1;
m7 = r7 * rho_l1;
m8 = (r8k +r8l) * rho_l1;       % totale massa van stang 8, m8k en m8l zijn de massa's van de aparte dele
m8k = r8k * rho_l1;
m8l = r8l * rho_l1;
m10 = r10 * rho_l1;
m11 = r11 * rho_l1;
m12 = r12 * rho_l2;

m_piston_1 = 15;            
m_piston_2 = 20;            

m9 = m_piston_1;            
m11 = m11 + m_piston_2;


% dynamic parameters, defined in a local frame on each of the bars.
X2 = 0;
X3 = r3/2;                  % zwaartepunt
X4 = (mb*r4k/2)/(m4);       % Uitgerekend vanaf vaste punt, zonder uitsteeksel mee te nemen
X5 = 0;                     % in lokaal assenstelsel is cog schuifscharnier in scharnierpunt
X6k = r6k/2;
X6l = r6l/2;
X6 = (r6k + r6l)/2;
X7 = r7/2;
X8k = r8k/2;
X8l = r8l/2;
X8 = (r8k + r8l)/2;
X9 = 0;                  
X10 = r10/2;
X11 = 0;                
X12 = r12/2;


Y2 = 0;
Y3 = 0;                     % Y coordinates of cog
Y4 = ((ma*r4l/2)+(mb*r4l))/m4;      % Uitgerekend vanaf vaste punt, zonder uitsteeksel mee te nemen
Y5 = 0;                     % in lokaal assenstelsel is cog schuifscharnier in scharnierpunt
Y6k = 0;
Y6l = 0;
Y6 = 0;
Y7 = 0;
Y8k = 0;
Y8l = 0;
Y8 = 0;
Y9 = 0;
Y10 = 0;
Y11 = ((r11*rho_l1)*r11/2)/(m11);
Y12 = 0;


% Traagheidsmomenten:

J2 = m2*R_wiel^2;       
J3 = m3*r3^2/12;

J4l = ma*r4l^2/12;
J4k = mb*r4k^2/12;
J4l_cog4 = J4l + (X4^2 + (Y4-r4l/2)^2) * ma;
J4k_cog4 = J4k + ((r4k/2-X4)^2 + (r4l-Y4)^2) * mb;
J4 = J4l_cog4 + J4k_cog4;

J5 = m5*((hoogte5^2)+(breedte5^2)) / 12 ;     % te benaderen als volle balk
J6k = m6k*r6k^2/12;
J6l = m6l*r6l^2/12;
J6 = m6*(r6k+r6l)^2/12;
J7 = m7*r7^2/12;
J8k = m8k*r8k^2/12;
J8l = m8l*r8l^2/12;
J8 = m8*(r8k+r8l)^2/12;
J9 = m_piston_1*((hoogte9^2)+(breedte9^2)) / 12 ;    % benaderd als volle balk
J10 = m10*r10^2/12;
J11 = m_piston_2*((hoogte11^2)+(breedte11^2)) / 12;  % benaderd als volle balk

J11_piston = m_piston_2*(hoogte11^2+breedte11^2) / 12;
J11_stang = (r11*rho_l1)*r11^2/12;
J11_piston_cog11 = J11_piston + Y11^2 * m_piston_2;
J11_stang_cog11 = J11_stang + (r11-Y11)^2 * (r11*rho_l1);
J11 = J11_piston_cog11 + J11_stang_cog11;

J12 = m12*r12^2/12;


% Extra parameter nodig
L9 = r8l - X8;              % Afstand tussen scharnierpunt 8,9 en het zwaartepunt van stang 8


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 1. Determination of Kinematics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% position analysis

% initial condition for first step of position analysis with fsolve (phi3 and phi4)
% VERY IMPORTANT because it determines which branch of the mechanism you're in
phi_init = [0; 2*pi/3 ; 0.25 ; pi/12 ; 2*pi/3 ; 7*pi/12 ; 0.5 ; pi/12 ; 0.25 ; pi/12];    
        
phi3_init =  phi_init(1);
phi4_init =  phi_init(2);
x5_init =    phi_init(3);
phi6_init =  phi_init(4);
phi7_init =  phi_init(5);
phi8_init =  phi_init(6);
x9_init =    phi_init(7);
phi10_init = phi_init(8);
x11_init =   phi_init(9);
phi12_init = phi_init(10);


t_begin = 0;                   % start time of simulation
t_end = 2*pi/25;               % end time of simulation = volledige rotatie
Ts = (t_end-t_begin)/2000;     % time step of simulation => Multiply by factor get faster analysis
t = [t_begin:Ts:t_end]';       % time vector

% initialization of driver
omega = -25;
alpha = 0;
phi2 = omega*t + pi/2;
dphi2 = omega*ones(size(phi2));
ddphi2 = alpha*ones(size(phi2));

% calculation of the kinematics (see kin_4bar.m)
[   phi3,   phi4,   x5,     phi6,   phi7,   phi8,   x9,     phi10,      x11,    phi12, ... 
    dphi3,  dphi4,  dx5,    dphi6,  dphi7,  dphi8,  dx9,    dphi10,     dx11,   dphi12, ...
    ddphi3, ddphi4, ddx5,   ddphi6, ddphi7, ddphi8, ddx9,   ddphi10,    ddx11,  ddphi12, ...
    a56_x_check, a56_y_check, a67_x_check, a67_y_check, a68_x_check, a68_y_check, a89_x_check, ...
    a89_y_check, a810_x_check, a810_y_check, a1011_x_check, a1011_y_check] = ...
    kinematics_4bar(r2l, r2k, r3, r4l, r4k, r6l, r6k, r7, r8l, r8k, r10, r11, r12, x4, y4, x7, y7, y9, ...
                    phi1, phi2, dphi2, ddphi2, omega, alpha, ...
                    phi3_init, phi4_init, x5_init, phi6_init, phi7_init, phi8_init, x9_init, phi10_init, x11_init, phi12_init, ...
                    t, fig_kin_4bar);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 2. Dynamics Calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calculation of the dynamics (see dyn_4bar.m)
[F12x, F12y, F23x, F23y, F212x, F212y, F34x, F34y, F14x, F14y, F45, F56x, F56y, F67x, F67y, ...
   F68x, F68y, F17x, F17y, F89x, F89y, F810x, F810y, F19, F1011x, F1011y, F1112x, F1112y, F111, ...
   M12, M19, M111, M45] ...
   = dynamics_4bar(phi2,  phi3,  phi4,  x5,  phi6,  phi7,  phi8,  x9,  phi10,  x11,  phi12, ...
                   dphi2, dphi3, dphi4, dx5, dphi6, dphi7, dphi8, dx9, dphi10, dx11, dphi12, ...
                   ddphi2,ddphi3,ddphi4,ddx5,ddphi6,ddphi7,ddphi8,ddx9,ddphi10,ddx11,ddphi12, ...
                   r2l, r2k, r3, r4l, r4k, r6l, r6k, r7, r8l, r8k, r10, r11, r12, x4, y4, x7, y7, y9, L9, ...
                   m2,m3,ma,mb,m4,m5,m6k,m6l,m6,m7,m8k,m8l,m8,m9,m10,m11,m12, m_piston_1, m_piston_2,...
                   X2,X3,X4,X5,X6k,X6l,X6,X7,X8k,X8l,X8,X9,X10,X11,X12, ...
                   Y2,Y3,Y4,Y5,Y6k,Y6l,Y6,Y7,Y8k,Y8l,Y8,Y9,Y10,Y11,Y12, ...
                   J2,J3,J4,J5,J6k,J6l,J6,J7,J8k,J8l,J8,J9,J10,J11,J12, t, fig_dyn_4bar);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 3. Movie
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
load fourbar_movie Movie
movie(Movie)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 4. Forward dynamic calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

phi2_init = pi/2;
dphi2_init = -25;

[phi2_check,  phi3,  phi4,  x5,  phi6,  phi7,  phi8,  x9,  phi10,  x11,  phi12, ...
 dphi2_check, dphi3, dphi4, dx5, dphi6, dphi7, dphi8, dx9, dphi10, dx11, dphi12, ...
 ddphi2_check,ddphi3,ddphi4,ddx5,ddphi6,ddphi7,ddphi8,ddx9,ddphi10,ddx11,ddphi12, ...
 F12x, F12y, F23x, F23y, F212x, F212y, F34x, F34y, F14x, F14y, F45, F56x, F56y, F67x, F67y, ...
 F68x, F68y, F17x, F17y, F89x, F89y, F810x, F810y, F19, F1011x, F1011y, F1112x, F1112y, F111, ...
 M19, M111, M45]...
 =forward_dynamics(M12, phi2_init, dphi2_init, ... 
                   phi3_init, phi4_init, x5_init, phi6_init, phi7_init, phi8_init, x9_init, phi10_init, x11_init, phi12_init, ...
                   r2l, r2k, r3, r4l, r4k, r6l, r6k, r7, r8l, r8k, r10, r11, r12, x4, y4, x7, y7, y9, L9, ...
                   m2,m3,ma,mb,m4,m5,m6k,m6l,m6,m7,m8k,m8l,m8,m9,m10,m11,m12, m_piston_1, m_piston_2,...
                   X2,X3,X4,X5,X6k,X6l,X6,X7,X8k,X8l,X8,X9,X10,X11,X12, ...
                   Y2,Y3,Y4,Y5,Y6k,Y6l,Y6,Y7,Y8k,Y8l,Y8,Y9,Y10,Y11,Y12, ...
                   J2,J3,J4,J5,J6k,J6l,J6,J7,J8k,J8l,J8,J9,J10,J11,J12, t, fig_forward_dyn);

               
if fig_forward_dyn   
        
    screen_size = get(groot, 'ScreenSize');
    figure('Name', 'Controle voorwaartse dynamica', 'NumberTitle', 'off', ...
           'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
    subplot(3,2,1)
    plot(t, phi2_check)
    ylabel('\theta_2 [rad]')   
    
    subplot(3,2,2)
    plot(t, phi2_check-phi2)
    ylabel('\Delta \theta_2 [rad]') 
    
    subplot(3,2,3)
    plot(t, dphi2_check)
    ylabel('d\theta_2 [rad/s]') 
    
    subplot(3,2,4)
    plot(t, dphi2_check-dphi2)
    ylabel('\Delta d\theta_2 [rad/s]')
    
    subplot(3,2,5)
    plot(t, ddphi2_check)
    ylabel('dd\theta_2 [rad/s�]') 
    
    subplot(3,2,6)
    plot(t, ddphi2_check-ddphi2)
    ylabel('\Delta dd\theta_2 [rad/s�]')
    
    set(gcf,'NextPlot','add');
    axes;
    h = title({'Controle voorwaartse dynamica'; ''});
    set(gca,'Visible','off');
    set(h,'Visible','on')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 5. Influence of rev_arm_angle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fig_kin_4bar = 0;
nb_data_points = 50;

% Declarated again to diminish the amount of time steps, to get faster
% calculations
t_begin = 0;                   % start time of simulation
t_end = 2*pi/25;               % end time of simulation = volledige rotatie
Ts = 20*(t_end-t_begin)/2000;     % time step of simulation => Multiply by factor get faster analysis
t = [t_begin:Ts:t_end]';       % time vector

phi2 = omega*t + pi/2;
dphi2 = omega*ones(size(phi2));
ddphi2 = alpha*ones(size(phi2));

x9_max_ampl = zeros(1,nb_data_points);
x9_max_index = zeros(1,nb_data_points); % index for which x9 becomes maximal
x11_max_index = zeros(1,nb_data_points); % index for which x11 becomes maximal

var_rev_arm_angle = zeros(1, nb_data_points);

for i = [1:1:nb_data_points+1]
    var_rev_arm_angle(i) = -rev_arm_angle + 2*rev_arm_angle*(i-1)/nb_data_points;
    x7 = (6.164 + 2.75 * cos(var_rev_arm_angle(i))) * conv;  
    y7 = (5.031 - 2.75 * sin(var_rev_arm_angle(i))) * conv;
    
    [   phi3,   phi4,   x5,     phi6,   phi7,   phi8,   x9,     phi10,      x11,    phi12, ... 
    dphi3,  dphi4,  dx5,    dphi6,  dphi7,  dphi8,  dx9,    dphi10,     dx11,   dphi12, ...
    ddphi3, ddphi4, ddx5,   ddphi6, ddphi7, ddphi8, ddx9,   ddphi10,    ddx11,  ddphi12, ...
    a56_x_check, a56_y_check, a67_x_check, a67_y_check, a68_x_check, a68_y_check, a89_x_check, ...
    a89_y_check, a810_x_check, a810_y_check, a1011_x_check, a1011_y_check] = ...
    kinematics_4bar(r2l, r2k, r3, r4l, r4k, r6l, r6k, r7, r8l, r8k, r10, r11, r12, x4, y4, x7, y7, y9, ...
                    phi1, phi2, dphi2, ddphi2, omega, alpha, ...
                    phi3_init, phi4_init, x5_init, phi6_init, phi7_init, phi8_init, x9_init, phi10_init, x11_init, phi12_init, ...
                    t, fig_kin_4bar);
                
    x9_max_ampl(i) = max(x9 - mean(x9));
    [dummy, x9_max_index(i)] = max(x9); % 'dummy' is not used, except to get to the second output of the max functions
    [dummy, x11_max_index(i)] = max(x11);

end

screen_size = get(groot, 'ScreenSize');

figure('Name', 'Invloed controlearm', 'NumberTitle', 'off', ...
       'Position', [screen_size(3)/3 screen_size(4)/6 screen_size(3)/3 screen_size(4)/1.5])
subplot(2,1,1)
plot(180/pi*var_rev_arm_angle, x9_max_ampl)
ylabel('amplitude x_9 [m]')
subplot(2,1,2)
plot(180/pi*var_rev_arm_angle, (180/pi)*(Ts*dphi2)*(x9_max_index - x11_max_index),'Color', [0 0.4470 0.7410]);
ylabel('faseverschil x_9 en x_{11} [�]')

set(gcf,'NextPlot','add');
axes;
h = title({'Invloed van de controlearm op x_9'; ''});
set(gca,'Visible','off');
set(h,'Visible','on')