% Connecting the Bluetooth:     % probably make an input off it
com = '16';
P = ['\\.\COM', com];
comport = P; % the actual COM port
% to use varies.
result = EPOCommunications('open',comport);


% VARIABLES & INPUTS:
x_field = 480;
y_field = 480;

% Length of Car:
L = 42;

% Starting points:              % probably make an input off it
x0 = 0;
y0 = 0;

% End points:                   % probably make an input off it
x1 = 180;
y1 = 150;

x = x1-x0;
y = y1-y0;

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
    Angle_trajectory(i) = asin(y_trajectory(i)/R);
end;

% Here a plot of the predicted route can be shown:
%plot(x_trajectory, y_trajectory);
%xlim([0,480])
%ylim([0, 480])

% Here input from the localisation is neede:
%x_loc = input(localisation);
%y_loc = input(localisation);


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


% DRIVE:
EPOCommunications('transmit', direction);   % direction
EPOCommunications('transmit','M156');   % speed

% Localisation input needed to compare actual position to model
% Depending on the real position to the intended breaking position (& the
% allowed error epsilon)
% if ((x_in-x1)^2+(y_in-y1)^2 <= epsilon^2)
%     EPOCommunications('transmit', 'D150');   % direction
%     EPOCommunications('transmit','M150');   % speed
% end;

%The time until breaking (dependent on the distance):
pause(1.7*s+0.7);           % needs tweaking: the additional term (+0.7) is needed for small distances, but not for large ones. find a  relation that gives the time needed dependent on the distance;

% Breaking:
EPOCommunications('transmit', direction);   % direction
EPOCommunications('transmit','M150');   % speed


% Closing the connection:
status = EPOCommunications('close',comport);
