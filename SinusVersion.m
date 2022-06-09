% % Connecting the Bluetooth:
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
y1 = 70;

x = x1-x0;
y = y1-y0;

epsilon = 20;

theta = atan(y/x);

R = sqrt(x^2+y^2)/(2*sin(2*atan(y/x)));

l = sqrt(x^2+y^2);
length = 100;
for i = 1:100
    x_(i) = x*i/100;
    l_(i) = l*i/100;
    y__(i) = y*i/100;
    y_(i) = y__(i)+5*sin(x_(i)/6);
end

plot(x_,y_)
% Calculations:
alpha = atan(2*L*sin(2*atan(y/x))/(sqrt(x^2+y^2)));

alpha = alpha*180/pi;

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
status = EPOCommunications('close',comport);