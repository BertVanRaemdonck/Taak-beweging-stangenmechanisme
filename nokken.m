clear;
close all;

%% Declaration of variables and loading in matcam

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPORTANT
%
% To get this program to run smoothly, please make sure you have the
% nok_hefwet.mot, nok_externe_krachten.exl and
% nok_overgangsverschijnsel.mot files in the same directory as this script.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
home_directory = pwd;
mot_law_location = strcat(home_directory, '\nok_hefwet.mot');
ext_load_location = strcat(home_directory, '\nok_externe_krachten.exl');

% assigned values
m_follower = 20;
zeta = 0.077;
T_cycle = 0.5;
omega = 2*pi/T_cycle;
cam_rpm = 60/T_cycle;

R_0 = 80;
R_v = 20;

matcam()

% setting the additional parameters for the analysis
global genmotlaw_startangle_edit genmotlaw_endangle_edit
global genmotlaw_startlift_edit genmotlaw_endlift_edit
global bcr_edit rof_edit exc_edit contourgrad_edit          
global mass_edit spring_edit sprload_edit rpm_edit
set(genmotlaw_startangle_edit, 'string', '330');            % not relevant for calculations, just keep matcam from throwing errors
set(genmotlaw_endangle_edit, 'string', '360');              % not relevant for calculations, just keep matcam from throwing errors
set(genmotlaw_startlift_edit, 'string', '0');               % not relevant for calculations, just keep matcam from throwing errors
set(genmotlaw_endlift_edit, 'string', '0');                 % not relevant for calculations, just keep matcam from throwing errors
set(bcr_edit, 'string', num2str(R_0));
set(rof_edit, 'string', num2str(R_v));
set(exc_edit, 'string', '0');                               % Analysis first without an eccentric follower
set(contourgrad_edit, 'string', '0');
set(mass_edit, 'string', num2str(m_follower));
set(spring_edit, 'string', '0');                            % Analysis without a spring first, see section 3) for calculation of the spring
set(sprload_edit, 'string', '0');                           % Analysis without a spring first, see section 3) for calculation of the spring
set(rpm_edit, 'string', num2str(cam_rpm));

% loading the files with the motion law and load profile
if exist(mot_law_location, 'file') == 2
    matcam('genmotlawload', mot_law_location)
else
    matcam('genmotlawload')
end

if exist(ext_load_location, 'file') == 2
    matcam('genextloadload', ext_load_location)
else
    matcam('genextloadload')
end

matcam('calc')
close all

%% Making matcam variables locally accessible

global Stot Vtot Atot;    
S = Stot;                                       % Lift in mm
V = Vtot;                                       % Velocity in mm/degree
A = Atot;                                       % Acceleration in mm/degree^2
global tetatot tetatotrad rpm;
theta = tetatot;                                % Cam angle in degrees
theta_rad = tetatotrad;                         % Cam angle in radians
global alfa;
alpha = alfa;                                   % Pressure angle
global force_spring force_load;
F_spring = force_spring;                        % Spring force
F_load = force_load;                            % External load
global force_acc force_tot;
F_acc = force_acc;                              % Inertial force
F_tot = force_tot;                              % Total force
global force_x force_y;
F_x = force_x;                                  % Total force in x direction
F_y = force_y;                                  % Total force in y direction
global roc;                                     % Radius curvature
radius_of_curvature = roc;
global Rtotrad


%% 2a) Calculating motion laws

figure()
plot(S)                                     % plotting the lift
title('Graph of lift')

figure()
plot(V)                                     % plotting the velocity
title('Graph of velocity')

figure()
plot(A)                                     % plotting the acceleration
title('Graph of acceleration')



%% 2b) Calculating cam dimensions:

% Without eccentricity

figure()
plot(radius_of_curvature)                       % plotting radius of curvature
axis([0 360 0 500])
title('Graph of radius of curvature without eccentricity')

figure()
plot(alpha)                                     % plotting pressure angle
title('Graph of pressure angle without eccentricity')

% With eccentricity

eccentricity = 10;                              % Chosen by hand


if 1 == 1                                       % Recalibration matcam
    
    matcam()
    % setting the additional parameters for the analysis
    set(genmotlaw_startangle_edit, 'string', '330');            % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_endangle_edit, 'string', '360');              % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_startlift_edit, 'string', '0');               % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_endlift_edit, 'string', '0');                 % not relevant for calculations, just keep matcam from throwing errors
    set(bcr_edit, 'string', num2str(R_0));
    set(rof_edit, 'string', num2str(R_v));
    set(exc_edit, 'string', num2str(eccentricity));             % Analysis first without an eccentric follower
    set(contourgrad_edit, 'string', '0');
    set(mass_edit, 'string', num2str(m_follower));
    set(spring_edit, 'string', '0');                            % Analysis without a spring first, see section 3) for calculation of the spring
    set(sprload_edit, 'string', '0');                           % Analysis without a spring first, see section 3) for calculation of the spring
    set(rpm_edit, 'string', num2str(cam_rpm));

    % loading the files with the motion law and load profile
    if exist(mot_law_location, 'file') == 2
        matcam('genmotlawload', mot_law_location)
    else
        matcam('genmotlawload')
    end

    if exist(ext_load_location, 'file') == 2
        matcam('genextloadload', ext_load_location)
    else
        matcam('genextloadload')
    end

    matcam('calc')
    % Making matcam variables locally accessible

    S = Stot;                                       % Lift in mm
    V = Vtot;                                       % Velocity in mm/degree
    A = Atot;                                       % Acceleration in mm/degree^2

    theta = tetatot;                                % Cam angle in degrees
    theta_rad = tetatotrad;                         % Cam angle in radians

    alpha = alfa;                                   % Pressure angle

    F_spring = force_spring;                        % Spring force
    F_load = force_load;                            % External load

    F_acc = force_acc;                              % Inertial force
    F_tot = force_tot;                              % Total force

    F_x = force_x;                                  % Total force in x direction
    F_y = force_y;                                  % Total force in y direction

    radius_of_curvature = roc;                      % Radius curvature

    % Close matcam window
    matcam_figure = gcf;
    close(matcam_figure.Number)
end 



figure()
plot(radius_of_curvature)                       % plotting radius of curvature
axis([0 360 -500 500])
title('Graph of radius of curvature with eccentricity')

figure()
plot(alpha)                                     % plotting pressure angle
title('Graph of pressure angle with eccentricity')


%% 3a) Calculation spring constant:

figure()
plot(F_tot)                                     % plotting total contact force without a spring
title('Graph of total contact force without a spring')


F_v0 = 20;                                      % Spring preload [N]   (chosen by hand)
g = 9.81;                                       % Gravitational acceleration [m/s^2]
gamma = 0;                                      % Angle between follower and vertical axis [�]

conversie_factor = (180^2)/(pi^2*1000);         % Conversion factor of converting [(kg*rad^2)/(s^2*�^2)] to [(N*rad^2)/mm]


k = max((-F_load - F_v0*ones(size(S)) - m_follower.*omega.*omega.*A.*conversie_factor )./S)               % - follower_mass*g*cos(gamma)*ones(size(S))  deleted from original equation because gravity is negligible

k = 5*ceil(k/5);                                % Rounds k up to the next integer wich is a multiple of 5, in order to have a strong enough spring


if 1 == 1                                       % Recalibration matcam
    
    matcam()
    % setting the additional parameters for the analysis
    set(genmotlaw_startangle_edit, 'string', '330');            % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_endangle_edit, 'string', '360');              % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_startlift_edit, 'string', '0');               % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_endlift_edit, 'string', '0');                 % not relevant for calculations, just keep matcam from throwing errors
    set(bcr_edit, 'string', num2str(R_0));
    set(rof_edit, 'string', num2str(R_v));
    set(exc_edit, 'string', num2str(eccentricity));             % Analysis with an eccentric follower
    set(contourgrad_edit, 'string', '0');
    set(mass_edit, 'string', num2str(m_follower));
    set(spring_edit, 'string', num2str(k));                     % Analysis with a spring 
    set(sprload_edit, 'string', num2str(F_v0));                 % Analysis with a spring
    set(rpm_edit, 'string', num2str(cam_rpm));

    % loading the files with the motion law and load profile
    if exist(mot_law_location, 'file') == 2
        matcam('genmotlawload', mot_law_location)
    else
        matcam('genmotlawload')
    end

    if exist(ext_load_location, 'file') == 2
        matcam('genextloadload', ext_load_location)
    else
        matcam('genextloadload')
    end

    matcam('calc')
    % Making matcam variables locally accessible

    S = Stot;                                       % Lift in mm
    V = Vtot;                                       % Velocity in mm/degree
    A = Atot;                                       % Acceleration in mm/degree^2

    theta = tetatot;                                % Cam angle in degrees
    theta_rad = tetatotrad;                         % Cam angle in radians

    alpha = alfa;                                   % Pressure angle

    F_spring = force_spring;                        % Spring force
    F_load = force_load;                            % External load

    F_acc = force_acc;                              % Inertial force
    F_tot = force_tot;                              % Total force

    F_x = force_x;                                  % Total force in x direction
    F_y = force_y;                                  % Total force in y direction

    radius_of_curvature = roc;                      % Radius curvature

    % Close matcam window
    matcam_figure = gcf;
    close(matcam_figure.Number)
end 


figure()
plot(F_tot)                                     % plotting total contact force with a spring
title('Graph of total contact force with a spring')


% Doubling the rotation speed, same spring:

double_rpm = 2*cam_rpm;

if 1 == 1                                       % Recalibration matcam
    
    matcam()
    % setting the additional parameters for the analysis
    set(genmotlaw_startangle_edit, 'string', '330');            % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_endangle_edit, 'string', '360');              % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_startlift_edit, 'string', '0');               % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_endlift_edit, 'string', '0');                 % not relevant for calculations, just keep matcam from throwing errors
    set(bcr_edit, 'string', num2str(R_0));
    set(rof_edit, 'string', num2str(R_v));
    set(exc_edit, 'string', num2str(eccentricity));             % Analysis with an eccentric follower
    set(contourgrad_edit, 'string', '0');
    set(mass_edit, 'string', num2str(m_follower));
    set(spring_edit, 'string', num2str(k));                     % Analysis with same spring 
    set(sprload_edit, 'string', num2str(F_v0));                 % Analysis with same spring
    set(rpm_edit, 'string', num2str(double_rpm));               % Analysis with double rotation speed

    % loading the files with the motion law and load profile
    if exist(mot_law_location, 'file') == 2
        matcam('genmotlawload', mot_law_location)
    else
        matcam('genmotlawload')
    end

    if exist(ext_load_location, 'file') == 2
        matcam('genextloadload', ext_load_location)
    else
        matcam('genextloadload')
    end

    matcam('calc')
    % Making matcam variables locally accessible

    S = Stot;                                       % Lift in mm
    V = Vtot;                                       % Velocity in mm/degree
    A = Atot;                                       % Acceleration in mm/degree^2

    theta = tetatot;                                % Cam angle in degrees
    theta_rad = tetatotrad;                         % Cam angle in radians

    alpha = alfa;                                   % Pressure angle

    F_spring = force_spring;                        % Spring force
    F_load = force_load;                            % External load

    F_acc = force_acc;                              % Inertial force
    F_tot = force_tot;                              % Total force

    F_x = force_x;                                  % Total force in x direction
    F_y = force_y;                                  % Total force in y direction

    radius_of_curvature = roc;                      % Radius curvature

    % Close matcam window
    matcam_figure = gcf;
    close(matcam_figure.Number)
end 

figure()
plot(F_tot)                                     % plotting total contact force with the same spring and double the rotation speed
title('Graph of total contact force, double rotation speed')

% Doubling the rotation speed, different spring
F_v0_double = 80;                               % Spring preload [N]   (chosen by hand)
double_omega = (2*pi*double_rpm)/60;

k_double = max((-F_load - F_v0_double*ones(size(S)) - m_follower.*double_omega.*double_omega.*A.*conversie_factor )./S)   % - follower_mass*g*cos(gamma)*ones(size(S)) deleted from original equation because gravity is negligible
k_double = 5*ceil(k_double/5);                  % Rounds k_double up to the next integer wich is a multiple of 5, in order to have a strong enough spring

if 1 == 1                                       % Recalibration matcam
    
    matcam()
    % setting the additional parameters for the analysis
    set(genmotlaw_startangle_edit, 'string', '330');            % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_endangle_edit, 'string', '360');              % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_startlift_edit, 'string', '0');               % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_endlift_edit, 'string', '0');                 % not relevant for calculations, just keep matcam from throwing errors
    set(bcr_edit, 'string', num2str(R_0));
    set(rof_edit, 'string', num2str(R_v));
    set(exc_edit, 'string', num2str(eccentricity));             % Analysis with an eccentric follower
    set(contourgrad_edit, 'string', '0');
    set(mass_edit, 'string', num2str(m_follower));
    set(spring_edit, 'string', num2str(k_double));              % Analysis with different spring 
    set(sprload_edit, 'string', num2str(F_v0_double));          % Analysis with different spring
    set(rpm_edit, 'string', num2str(double_rpm));               % Analysis with double rotation speed

    % loading the files with the motion law and load profile
    if exist(mot_law_location, 'file') == 2
        matcam('genmotlawload', mot_law_location)
    else
        matcam('genmotlawload')
    end

    if exist(ext_load_location, 'file') == 2
        matcam('genextloadload', ext_load_location)
    else
        matcam('genextloadload')
    end

    matcam('calc')
    % Making matcam variables locally accessible

    S = Stot;                                       % Lift in mm
    V = Vtot;                                       % Velocity in mm/degree
    A = Atot;                                       % Acceleration in mm/degree^2

    theta = tetatot;                                % Cam angle in degrees
    theta_rad = tetatotrad;                         % Cam angle in radians

    alpha = alfa;                                   % Pressure angle

    F_spring = force_spring;                        % Spring force
    F_load = force_load;                            % External load

    F_acc = force_acc;                              % Inertial force
    F_tot = force_tot;                              % Total force

    F_x = force_x;                                  % Total force in x direction
    F_y = force_y;                                  % Total force in y direction

    radius_of_curvature = roc;                      % Radius curvature

    % Close matcam window
    matcam_figure = gcf;
    close(matcam_figure.Number)
end 

figure()
plot(F_tot)                                     % plotting total contact force with the same spring and double the rotation speed
title('Graph of total contact force, double rotation speed, different spring')

%% 3b) Calculation instantaneous power

if 1 == 1                                       % Recalibration matcam
    
    matcam()
    % setting the additional parameters for the analysis
    set(genmotlaw_startangle_edit, 'string', '330');            % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_endangle_edit, 'string', '360');              % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_startlift_edit, 'string', '0');               % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_endlift_edit, 'string', '0');                 % not relevant for calculations, just keep matcam from throwing errors
    set(bcr_edit, 'string', num2str(R_0));
    set(rof_edit, 'string', num2str(R_v));
    set(exc_edit, 'string', '0');                               % Analysis without eccentricity
    set(contourgrad_edit, 'string', '0');
    set(mass_edit, 'string', num2str(m_follower));
    set(spring_edit, 'string', num2str(k));                     % Analysis with a spring 
    set(sprload_edit, 'string', num2str(F_v0));                 % Analysis with a spring
    set(rpm_edit, 'string', num2str(cam_rpm));

    % loading the files with the motion law and load profile
    if exist(mot_law_location, 'file') == 2
        matcam('genmotlawload', mot_law_location)
    else
        matcam('genmotlawload')
    end

    if exist(ext_load_location, 'file') == 2
        matcam('genextloadload', ext_load_location)
    else
        matcam('genextloadload')
    end

    matcam('calc')
    % Making matcam variables locally accessible

    S = Stot;                                       % Lift in mm
    V = Vtot;                                       % Velocity in mm/degree
    A = Atot;                                       % Acceleration in mm/degree^2

    theta = tetatot;                                % Cam angle in degrees
    theta_rad = tetatotrad;                         % Cam angle in radians

    alpha = alfa;                                   % Pressure angle

    F_spring = force_spring;                        % Spring force
    F_load = force_load;                            % External load

    F_acc = force_acc;                              % Inertial force
    F_tot = force_tot;                              % Total force

    F_x = force_x;                                  % Total force in x direction
    F_y = force_y;                                  % Total force in y direction

    radius_of_curvature = roc;                      % Radius curvature
    
    R_tot = R_0 + R_v ;                             % Total distance between center of rotation and center of follower
    R_tot_rad = Rtotrad ;
    
    
    % Close matcam window
    matcam_figure = gcf;
    close(matcam_figure.Number)
end 

P1 = F_tot .*(omega*ones(size(S))) .*(sind(alpha)) .* ((R_tot + S).*0.001);      % instantaneous power

P1_2 = F_tot .*(omega*ones(size(S))) .*(sind(alpha)) .* ((R_tot_rad).*0.001);    % instantaneous power calculated by values of matcam

figure()
plot(P1)                                     % plotting total contact force with the same spring and double the rotation speed
title('Graph of instantaneous power 1')

if 1 == 1                                       % Recalibration matcam
    
    matcam()
    % setting the additional parameters for the analysis
    set(genmotlaw_startangle_edit, 'string', '330');            % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_endangle_edit, 'string', '360');              % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_startlift_edit, 'string', '0');               % not relevant for calculations, just keep matcam from throwing errors
    set(genmotlaw_endlift_edit, 'string', '0');                 % not relevant for calculations, just keep matcam from throwing errors
    set(bcr_edit, 'string', num2str(R_0));
    set(rof_edit, 'string', num2str(R_v));
    set(exc_edit, 'string', num2str(eccentricity));             % Analysis with eccentricity
    set(contourgrad_edit, 'string', '0');
    set(mass_edit, 'string', num2str(m_follower));
    set(spring_edit, 'string', num2str(k));                     % Analysis with a spring 
    set(sprload_edit, 'string', num2str(F_v0));                 % Analysis with a spring
    set(rpm_edit, 'string', num2str(cam_rpm));

    % loading the files with the motion law and load profile
    if exist(mot_law_location, 'file') == 2
        matcam('genmotlawload', mot_law_location)
    else
        matcam('genmotlawload')
    end

    if exist(ext_load_location, 'file') == 2
        matcam('genextloadload', ext_load_location)
    else
        matcam('genextloadload')
    end

    matcam('calc')
    % Making matcam variables locally accessible

    S = Stot;                                       % Lift in mm
    V = Vtot;                                       % Velocity in mm/degree
    A = Atot;                                       % Acceleration in mm/degree^2

    theta = tetatot;                                % Cam angle in degrees
    theta_rad = tetatotrad;                         % Cam angle in radians

    alpha = alfa;                                   % Pressure angle

    F_spring = force_spring;                        % Spring force
    F_load = force_load;                            % External load

    F_acc = force_acc;                              % Inertial force
    F_tot = force_tot;                              % Total force

    F_x = force_x;                                  % Total force in x direction
    F_y = force_y;                                  % Total force in y direction

    radius_of_curvature = roc;                      % Radius curvature
    
    R_tot = R_0 + R_v;                              % Total distance between center of rotation and center of follower
    R_tot_rad = Rtotrad;
    
    % Close matcam window
    %matcam_figure = gcf;
    %close(matcam_figure.Number)
end 

P2 = F_tot .*(omega*ones(size(S))) .*( ( ( (sqrt(R_tot^2 - eccentricity^2) + S).* 0.001).*sind(alpha)) + (eccentricity*0.001.*cosd(alpha)) );         % instantaneous power

P2_2 = F_tot .*(omega*ones(size(S))) .*( ( ( (sqrt(R_tot_rad.^2 - eccentricity^2)).* 0.001).*sind(alpha)) + (eccentricity*0.001.*cosd(alpha)) );      % instantaneous power calculated by values of matcam


% Extra calculation from derivative function
conversion_V = (0.001*180)/pi;               % from mm/� to m/rad
P3 = F_tot .*(omega*ones(size(S))) .* (V*conversion_V) .* cosd(alpha);

figure()
plot(P2)                                     % plotting total contact force with the same spring and double the rotation speed
title('Graph of instantaneous power 2')      

figure()                                     % plotting difference between the two equations
plot(P1-P2)
title('Graph of difference P1 and P2')

% figure()                                          % Extra control plot
% plot(P1-P1_2)
% title('Graph of difference P1 and P1_2')

% figure()                                          % Extra control plot
% plot(P2-P2_2)
% title('Graph of difference P2 and P2_2')

 figure()                                          % Extra control plot to verify the deriven equation
 plot(P1-P3)
 title('Graph of difference P1 and P3')




%% 3c) Calculation average power usage

% Defining integration boundaries:
theta_min = 1;
theta_max = length(S);                      % Normally 361 values

P_tot1 = zeros(size(S));
P_tot2 = zeros(size(S));

i = theta_min;
while i < theta_max
    P_tot1(i+1) = P_tot1(i) + (P1(i) + P1(i+1))/2;      
    P_tot2(i+1) = P_tot2(i) + (P2(i) + P2(i+1))/2;
    
    i = i+1;

end 

P_average1 = P_tot1(theta_max)/(theta_max - theta_min)      % width of the interval is in degrees, not in radian --> dividing by 360�
P_average2 = P_tot2(theta_max)/(theta_max - theta_min)


%% 3d) Calculation torque and dimensions flywheel

M21 = -P1 ./ (omega*ones(size(S)));


figure()
plot(M21)
title('Graph of needed torque')


M_average = -P_average1 / omega

At = zeros(size(S));

i = theta_min;

while i < theta_max
    At(i+1) = At(i) + ((M21(i) - M_average) + (M21(i+1) - M_average))/2;
    
    i = i+1;
end

theta_m = find(At==min(At)) - 1;   % index starts counting from 1, not from 0
theta_M = find(At==max(At)) - 1;

precision = 0.1;

theta_m_torque = find(abs(M21-M_average) < precision ) -1;              % if you want to know theta_m and theta_M, look at the first and last value in this vector
%theta_M_torque = find(abs(M21-M_average) < precision ,1,last) -1        commando last doesn't work, should have calculated the last value wich suffices
% Gives the same values as above!!!   --> extra control


figure()
plot(At)
title('Graph of needed work')

i = theta_m;
K = 0.1;                            % speed variations between -5% and +5%
Am = 0;                             % maximum work surplus (in Nm�)  (start value)
while i < theta_M
    Am = Am + (M21(i) - (M_average) + (M21(i+1) - M_average))/2;
    i=i+1;
end

conv_deg_to_rad = pi/180;               % conversion factor to change degrees in radians

I = (Am / (K * omega^2)) * conv_deg_to_rad

% Disc flywheel with constant mass
m_flywheel = 10;                        % in kg
d_flywheel = sqrt((I*8)/m_flywheel)     % diameter of an disc type flywheel

% Disc flywheel in a chosen material and with available space
rho_steel = 7800;                       % in kg/ m^3
R_flywheel = 0.20;                      % in m

t_flywheel = (2*I)/(pi*(R_flywheel^4)*rho_steel)


%% 4) Dynamics of a flexible follower

% 4.1) Values critical rise/fall
beta_min = 330-265;                 % minimal angle of a rise in degrees
t_min = beta_min*(pi/180) / omega;  % minimal time of a rise in seconds

% 4.2) Calculate minimal follower stiffness
k_follower = m_follower*(0.75*2*pi/(zeta*t_min))^2-k*1000;  % Spring constant of the follower in N/m
k_follower = k_follower/1000;                               % Spring constant of the follower in N/mm

% 4.3) Numerical simulation cam/follower system
omega_n = sqrt(1000*(k_follower+k)/m_follower);
t_n = 2*pi/omega_n;
lambda = t_min / t_n;

numerator = (2*pi*lambda)^2;
denominator = [1, 2*zeta*(2*pi*lambda), (2*pi*lambda)^2];
sys = tf(numerator, denominator);


Ts = 1/200;
tau = 0:Ts:5;
tau_rise = tau(1:1/Ts);
crit_rise_input = zeros(size(tau));
crit_rise_input(1:1/Ts) = 1 - tau_rise + 1/(2*pi).*sin(2*pi.*tau_rise);

init_rise = 1;
init_vel = 0;
[A,B,C,D] = tf2ss(numerator, denominator);
X0 = [1/C(2)*init_vel; 1/C(2)*init_rise];
figure()
lsim(A,B,C,D, crit_rise_input, tau, X0);            % picture
gamma = lsim(A,B,C,D, crit_rise_input, tau, X0);    % saving data

% 4.4) Approximate analysis
Q = (2*pi)^2;
N = 3;
A1_approx = Q/(2*pi*lambda)^N;    % Amplitude of response @tau=1. Closely approximates the result of the numerical analysis

gamma_approx_envelope = A1_approx*exp(-zeta*2*pi*lambda*(tau-1));

    % Verification
last_max_pos = 1/Ts;
difference = [];

while last_max_pos < length(gamma)-1
    offset = 0;
    new_max_pos = 1;
    while new_max_pos == 1 && last_max_pos + offset < length(gamma)-1
        offset = offset + 1;
        [new_max, new_max_pos] = max(gamma(last_max_pos+offset:length(gamma)));        
    end
    last_max_pos = last_max_pos + new_max_pos + offset;
    if last_max_pos < length(gamma)-1
        difference = [difference (new_max-gamma_approx_envelope(last_max_pos))/new_max];
    end
end

figure('Name', 'Controle Benaderende Analyse', 'NumberTitle', 'off');
subplot(1,2,1)
plot(tau(1/Ts:length(tau)), gamma(1/Ts:length(tau)));
hold on;
plot(tau(1/Ts:length(tau)), gamma_approx_envelope(1/Ts:length(tau)));
hold off;
xlabel('\tau')
ylabel('\gamma(\tau)')
subplot(1,2,2)
plot(difference)
xlabel('index maximum')
ylabel('relatieve fout benadering')
set(gcf,'NextPlot','add');

axes;
h = title({'Nauwkeurigheid van de benaderende analyse'; ''});
set(gca,'Visible','off');
set(h,'Visible','on')

% 4.5) Force response
    
    % Redo simulation to get values in degree form
T_s = 1/66;
tau = 0:T_s:6;
crit_rise_input = zeros(size(tau));
crit_rise_input(1:66) = S(266:331) / (max(S(266:331))-min(S(266:331)));

init_rise = 1;
init_vel = 0;
[A,B,C,D] = tf2ss(numerator, denominator);
X0 = [1/C(2)*init_vel; 1/C(2)*init_rise];
gamma = lsim(A,B,C,D, crit_rise_input, tau, X0); 

follower_motion = (max(S(266:331))-min(S(266:331)))*crit_rise_input(1:361);
output_motion = (max(S(266:331))-min(S(266:331)))*gamma(1:361).';

    % Calculate forces
alpha_single = alpha(266:331);
alpha_single = [alpha_single.' alpha(332)*ones(1,295)];
spring_force = F_v0 + k*follower_motion;
transient_force = k_follower*(follower_motion - output_motion);
contact_force = (spring_force + transient_force) ./ cos(pi/180*alpha_single);

    % Calculate the spring constant needed to maintain contact
k_adj_single = max((-transient_force(1:66)-F_v0)./ follower_motion(1:66));
k_adj_single = 5*ceil(k_adj_single/5)

    % Calculate the preload needed to maintain contact
compensation = -min(F_v0 + transient_force(66:length(transient_force)) + k_adj_single*follower_motion(66:length(transient_force)));   % Spring helps lowering the needed preload
F_v0_adj_single = F_v0;
if compensation > 0
    F_v0_adj_single = F_v0_adj_single + 5*ceil(compensation/5)          % Rounds up to next multiple of 5
end   
   
    % Calculate the new forces after adjustment of the spring constant and preload
spring_force_adj_single = F_v0_adj_single + k_adj_single*follower_motion;
contact_force_adj_single = (spring_force_adj_single + transient_force) ./ cos(pi/180*alpha_single);

    % Plot results
figure('Name', 'Overgangsverschijnsel krachten', 'NumberTitle', 'off');
subplot(1,2,1)
plot(spring_force, 'g-.')
hold on
plot(transient_force, 'r--')
plot(contact_force, 'b')
plot([1 361], [0 0], 'k:')
xlabel('nokhoek \beta [\degree]');
ylabel('krachten [N]');

subplot(1,2,2)
plot(spring_force_adj_single, 'g-.')
hold on
plot(transient_force, 'r--')
plot(contact_force_adj_single, 'b')
plot([1 361], [0 0], 'k:')
xlabel('nokhoek \beta [\degree]');
ylabel('krachten [N]');

ylimits=get(gca,'Ylim');
ylim=ylimits(2)-ylimits(1);
y_legend(1)=ylimits(2)-ylim*.1;
y_legend(2)=ylimits(2)-ylim*.15;
y_legend(3)=ylimits(2)-ylim*.2;
xlimits=get(gca,'Xlim');
xlim=xlimits(2)-xlimits(1);
x_legend=xlimits(1)+.60*xlim;
set(text(x_legend,y_legend(1),'veerkracht (-\cdot-)'),'color',[0 1 0]);
set(text(x_legend,y_legend(2),'overgangsverschijnsel (- - -)'),'color',[1 0 0]);
set(text(x_legend,y_legend(3),'totale kracht (-)'),'color',[0 0 1]);
hold off



%% 4.6) Multi rise case
% Very simular to the single rise case

lambda_tilde = T_cycle / t_n;

numerator = (2*pi*lambda_tilde)^2;
denominator = [1, 2*zeta*(2*pi*lambda_tilde), (2*pi*lambda_tilde)^2];
sys = tf(numerator, denominator);

times_repeating = 25;

Ts = 1/361;
tau = 0:Ts:times_repeating;

crit_rise_input = S(1:361) / (max(S(1:361))-min(S(1:361)));

crit_rise_input = repmat(crit_rise_input,times_repeating,1);        % Making a column vector wich repeats itself "times_repeating" times

crit_rise_input = [crit_rise_input; 0];         % Otherwise not the same length as the other vectors

init_rise = 0;
init_vel = 0;
[A,B,C,D] = tf2ss(numerator, denominator);
X0 = [1/C(2)*init_vel; 1/C(2)*init_rise];
figure()
lsim(A,B,C,D, crit_rise_input, tau, X0);            % picture
gamma = lsim(A,B,C,D, crit_rise_input, tau, X0);    % saving data

follower_motion = (max(S(1:361))-min(S(1:361)))*crit_rise_input;
output_motion = (max(S(1:361))-min(S(1:361)))*gamma;


min_plot = min(gamma-crit_rise_input) * 1.2;
max_plot = max(gamma-crit_rise_input) * 1.2;

figure()
plot(tau,gamma-crit_rise_input)
title('gamma-crit rise input multi rise')
axis([times_repeating-1 times_repeating min_plot max_plot])

    % Calculate forces
alpha_multi = repmat(alpha,times_repeating,1);
alpha_multi = [alpha_multi; 0];           % Otherwise not the same length as the other vectors
spring_force = F_v0 + k*follower_motion;
transient_force = k_follower*(follower_motion - output_motion);
contact_force = (spring_force + transient_force) ./ cos(pi/180*alpha_multi);

    % Calculate the spring constant needed to maintain contact
k_adj_multi = max((-transient_force(1:361*times_repeating)-F_v0)./ follower_motion(1:361*times_repeating));
k_adj_multi = 5*ceil(k_adj_multi/5)

    % Calculate the preload needed to maintain contact
compensation = -min(F_v0 + transient_force(66:length(transient_force)) + k_adj_multi*follower_motion(66:length(transient_force)));   % Spring helps to diminish the needed preload
F_v0_adj_multi = F_v0
if compensation > 0
    F_v0_adj_multi = F_v0_adj_multi + 5*ceil(compensation/5)          % Rounds up to next multiple of 5
end

    % Calculate the new forces after adjustment of the spring constant and preload
spring_force_adj_multi = F_v0_adj_multi + k_adj_multi*follower_motion;
contact_force_adj_multi = (spring_force_adj_multi + transient_force) ./ cos(pi/180*alpha_multi);

% % Plot results
min_contact_x = 361*(times_repeating-1);
max_contact_x = 361*(times_repeating);
min_contact_y = min(contact_force)*1.2;
max_contact_y = max(contact_force)*1.2;


figure('Name', 'Overgangsverschijnsel krachten multirise', 'NumberTitle', 'off');
plot(contact_force)
axis([min_contact_x max_contact_x min_contact_y max_contact_y])


min_contact_y_adjusted = min(contact_force_adj_multi)*1.2;
max_contact_y_adjusted = max(contact_force_adj_multi)*1.2;


figure('Name', 'Overgangsverschijnsel krachten multirise adjusted spring', 'NumberTitle', 'off');
plot(contact_force_adj_multi)
axis([min_contact_x max_contact_x min_contact_y_adjusted max_contact_y_adjusted])


% Plot results
figure('Name', 'Overgangsverschijnsel krachten multi rise', 'NumberTitle', 'off');
subplot(1,2,1)
plot(contact_force)
xlabel('nokhoek \beta [\degree]');
ylabel('contact kracht [N]');
axis([min_contact_x max_contact_x min_contact_y max_contact_y]);

subplot(1,2,2)
plot(contact_force_adj_multi)
xlabel('nokhoek \beta [\degree]');
ylabel('contact kracht [N]');
axis([min_contact_x max_contact_x min_contact_y_adjusted max_contact_y_adjusted])

hold off


%% Extra calculation contact force multi rise


    % Calculate forces
spring_force = F_v0 + k*follower_motion;
transient_force = k_follower*(follower_motion-output_motion);
contact_force = (spring_force + transient_force) ./ cos(pi/180*alpha_multi);


k_adjusted = k_double;                  % Estimation of a better spring constant, is recalculated below

    % Calculate the preload needed to maintain contact
compensation = -min(F_v0 + transient_force(1:361*times_repeating) + k_adjusted*follower_motion(1:361*times_repeating));   % Aangepaste veer van single rise helpt
F_v0_adjusted = F_v0;
if compensation > 0
    F_v0_adjusted = F_v0_adjusted + 5*ceil(compensation/5)      % Rounds up to next multiple of 5
end   

% Calculate the spring constant needed to maintain contact
k_adjusted = max((-transient_force(1:361*times_repeating)-F_v0_adjusted)./ follower_motion(1:361*times_repeating))
k_adjusted = 5*ceil(k_adjusted/5);          % rounds up to the next multiple of 5

    % Calculate the new forces after adjustment of the spring constant and preload
spring_force_adjusted = F_v0_adjusted + k_adjusted*follower_motion;
contact_force_adjusted = (spring_force_adjusted + transient_force) ./ cos(pi/180*alpha_multi);


% % Plot results
min_contact_x = 361*(times_repeating-1);
max_contact_x = 361*(times_repeating);
min_contact_y = min(contact_force)*1.2;
max_contact_y = max(contact_force)*1.2;


figure('Name', 'Overgangsverschijnsel krachten multirise extra', 'NumberTitle', 'off');
plot(contact_force)
axis([min_contact_x max_contact_x min_contact_y max_contact_y])


min_contact_y_adjusted = min(contact_force_adjusted)*1.2;
max_contact_y_adjusted = max(contact_force_adjusted)*1.2;


figure('Name', 'Overgangsverschijnsel krachten multirise adjusted spring extra', 'NumberTitle', 'off');
plot(contact_force_adjusted)
axis([min_contact_x max_contact_x min_contact_y_adjusted max_contact_y_adjusted])


