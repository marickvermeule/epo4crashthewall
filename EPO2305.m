% Connecting the Bluetooth:
% com = '8';
% P = ['\\.\COM', com];
% comport = P; % the actual COM port
% % to use varies.
% result = EPOCommunications('open',comport);

% Variables:
x_field = 480;
y_field = 480;

L = 42;

x0 = 0;
y0 = 0;

x1 = 100;
y1 = 60;

x = x1-x0;
y = y1-y0;

epsilon = 20; % this is the range in which we want to end up (radius around the endpoint that is close enough)

theta = atan(y/x); % this is the angle of the tiangle from the starting point to the endpoint
theta_degree = theta*180/pi;

R = sqrt(x^2+y^2)/(2*sin(theta)); % this is the Radius of the circle on which the car rides

x_NullPoint = x+R; % these are the centrepoint of the radius
y_NullPoint = 0; % same as above

i_max = 100;
for i = 1:i_max
    x_trajectory(i) = x_NullPoint - R*cos(theta/i_max);
    y_trajectory(i) = R*sin(theta/i_max);
end;
    
    
%x_in = input(localisation);
%y_in = input(localisation);

% Calculations:
alpha = atan(2*L*sin(2*atan(y/x))/(sqrt(x^2+y^2)));

alpha_degree = alpha*180/pi;

Car_angle = 2*alpha;

D = 150-(1.36*alpha);

% Returning the value to the Car:
D_str = int2str(D);

direction = ['D', D_str];

% EPOCommunications('transmit', direction);   % direction
% EPOCommunications('transmit','M156');   % speed
% 
% if ((x_in-x1)^2+(y_in-y1)^2 <= epsilon^2)
%     EPOCommunications('transmit', direction);   % direction
%     EPOCommunications('transmit','M150');   % speed
% end;

%pause(3);

%EPOCommunications('transmit', direction);   % direction
%EPOCommunications('transmit','M150');   % speed

% Closing the connection:
% status = EPOCommunications('close',comport);