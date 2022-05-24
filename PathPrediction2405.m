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

% Starting points:
x0 = 0;
y0 = 0;

% End points:
x1 = 70;
y1 = 30;

x = x1-x0;
y = y1-y0;

epsilon = 20; % this is the range in which we want to end up (radius around the endpoint that is close enough)

theta = atan(x/y); % this is the angle of the tiangle from the starting point to the endpoint
theta_degree = theta*180/pi;

R = sqrt(x^2+y^2)/(2*sin(theta)); % this is the Radius of the circle on which the car rides

x_NullPoint = x0+R; % these are the centrepoint of the radius
y_NullPoint = y0; % same as above

i_max = 100;
% Calculate the position (x,y) & angle of the Car at given point on the
% trajectory:
for i = 1:i_max
    x_trajectory(i) = x_NullPoint - R*cos(i*2*theta/i_max);
    y_trajectory(i) = R*sin(i*2*theta/i_max);
    Angle_trajectory(i) = asin(y_trajectory(i)/R);
end;
    
plot(x_trajectory, y_trajectory)

%x_in = input(localisation);
%y_in = input(localisation);

% Calculations:
alpha = atan(2*L*sin(2*atan(y/x))/(sqrt(x^2+y^2)));
alpha_degree = alpha*180/pi;

% The angle of the car at the final position ( ==
% Angle_trjectorty(i_max)):
Car_angle = 2*theta;
Car_angle_degree = Car_angle*180/pi;

D = 150-(1.35*alpha);

% Returning the value to the Car:
direction = ['D', int2str(D)];

% Drive:
% EPOCommunications('transmit', direction);   % direction
% EPOCommunications('transmit','M156');   % speed

% Depending on the real position to the intended breaking position (& the
% allowed error epsilon)
% if ((x_in-x1)^2+(y_in-y1)^2 <= epsilon^2)
%     EPOCommunications('transmit', 150);   % direction
%     EPOCommunications('transmit','M150');   % speed
% end;

%pause(3);

%EPOCommunications('transmit', direction);   % direction
%EPOCommunications('transmit','M150');   % speed

% Closing the connection:
% status = EPOCommunications('close',comport);