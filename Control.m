%% Control
% Alex Hirsig
% 31.05.2022
% EPO4 A.02

%Starting point (coordinates):
x0 = 0;
y0 = 0;

% Endpoints (coordinates):
x1 = input("X: ");
y1 = input("Y: ");

% To ride:
x = x1-x0;
y = y1=y0;

% From localization:
xL = input("X localization: ");
yL = input("Y localization: ");

% Acceptable Error:
epsilon = 20; % this is the range in which we want to end up (radius around the endpoint that is close enough)

% Angle Startpoint-Endpoint:
theta = atan(x/y); % this is the angle of the triangle from the starting point to the endpoint
theta_degree = theta*180/pi;

% Radius:
R = sqrt(x^2+y^2)/(2*sin(theta)); % this is the Radius of the circle on which the car rides

x_NullPoint = x0+R; % these are the centrepoint of the radius
y_NullPoint = y0; % same as above

% Distance to be driven (needed for the breaking time):
s = 2*theta*R/100;

% Calculate the position (x,y) & angle of the Car at given point on the trajectory:
i_max = 100; % can be changed; dependent on how often we want an update;
for i = 1:i_max
    x_trajectory(i) = x_NullPoint - R*cos(i*2*theta/i_max);
    y_trajectory(i) = R*sin(i*2*theta/i_max);
    Angle_trajectory(i) = asin(y_trajectory(i)/R);  % driving on x = const. -> alpha = 0/180; driving on y = const. -> alpha = +/-90
end;

% CALCULATIONS:
% Angle of the wheels:
alpha = atan(2*L*sin(2*atan(x/y))/(sqrt(x^2+y^2)));
alpha_degree = alpha*180/pi;

% The angle of the car at the final position ( == Angle_trjectorty(i_max)):
Car_angle = 2*theta;
Car_angle_degree = Car_angle*180/pi;

% Stearing of the car:
D = 150-(1.15*alpha_degree);            % this needs some tweaking for better accuarcy

% Returning the value to the Car:
direction = ['D', int2str(D)];


%% Control part:
% The distance between the location measured and expected:
i = input("Input needed for the calculation");
dx = xL-x_trajectory(i);
dy = yL-y_trajectory(i);

z = sqrt(dx^2+dy^2);
beta = atan(dy/dx);     % the angle of the error reltive to the field;
gamma = 90-alpha-beta;  % the angle of the error to the car;

xC = z*cos(gamma);      % check whether degree or rad are needed
yC = z*sin(gamma);      % check whether degree or rad are needed

% Tha actual angle of the car:
AngleL = R*Angle_trajectory(i)/(R-xC);      % this is probably not the most accurate yet;

% if x > 0: the car is too far right relative to the expected location
% elseif x < 0: the car is too far left relative to the expected location

% if y > 0: the car is too far ahead relative to the expected location
% elseif y < 0: the car is too far behind relative to the expected location

%% Drive dependent on the control
% we set the new x0 = xC & y0 = yC
% the endpoint (x1, y1) are taken relative to the position of the car
x0 = xC;
y0 = yC;

x = x1-x0;
y = y1-y0;


%% TBD!! see picture on Alex' phone
z = sqrt(x^2+y^2);
x = z*sin(AngleL);      % not sure if this needs to be in degrees or rad
y = y*
