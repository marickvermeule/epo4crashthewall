tic % somewhere where the run starts

global breaking;

min_speed = 135;
max_speed = 165;

min_force = 10;
max_force = -14

b = 5;  % to be changed

F_stop = max_force; % Can be set by ourselves;

begin = input("Where does the car start (in m)?");
sensor = mean(Left, Right); % mean of both sensor values;

x_stop = input("Where should the car stop (in m)?");

x = begin-sensor;

speed = input("How fast (135-165)?");   % User input

% in the timer with frequency t_timer
% {
if breaking == 0    % this is 0 as long as we are not breaking & 1 if we are breaking
    status = EPOCommunications('transmit', 'S');
    Position = strfind(status, 'Mot.');
    speed = str2double(extractBetween(status,Position+5, Position+7));

    F_car = force(speed);

    %F_car = max_force+(min_force-max_force)/(max_speed-min_speed)*speed;% change

    t = toc;
    v = F_car*t+b*x;

    t_break = v/F_stop; % this has to be updated with every period of the timer until the if statement is entered;

    x_break = v*t_break-0.5*F_stop*t_break^2
end
% }

if sensor-v*t_break <= x_stop+x_break
    breaking = 1;
    pause(sensor-x_stop-x_break/v); % maybe we need a small delta that we substract
    EPOCommunications('transmit','D150');   % direction
    EPOCommunications('transmit','M135');   % speed
    pause(t_break);
    EPOCommunications('transmit','D150');   % direction
    EPOCommunications('transmit','M150');   % speed
end

% Force
function F = Force(x)
if x >149
    F = 2/3 * x - 100;
else
    F = 14/15 * x - 140;
end
end

