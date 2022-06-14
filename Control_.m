% Length of Car:
global L;
L = 42;

% Starting points:              % probably make an input off it
x0 = 0;
y0 = 0;

% End points:                   % probably make an input off it
x1 = 80;
y1 = 80;

x = x1-x0;
y = y1-y0;

% Car angle in rad:
%Angle_Car = 0;

global i_max;
i_max = 100;

for i = 1:i_max
    x_trajectory(i) = 0;
    y_trajectory(i) = 0;
    Angle_trajectory(i) = 0;
end;

while true
    x0 = x_Location;
    y0 = y_Location;
%     for i =1:i_max
%         dx(i) = x_trajectory(i)-xL;
%         dy(i) = y_trajectory(i)-yL;
%         z(i) = sqrt(dx(i)^2+dy(i)^2); % distance between trajectory and actual location;
%     end;
%     [M, I] = min(z);
%     Angle_Car = Angle_trajectory(I);
    A = trajectory(x0, y0, x1, y1, x_trajectory, y_trayectory, Angle_trajectory);
end;


function A = trajectory(x0, y0, x1, y1, x_trajectory, y_trajectory, Angle_trajectory)
    for i = 1:i_max
        d_x(i) = x_trajectory(i)-xL;
        d_y(i) = y_trajectory(i)-yL;
        z(i) = sqrt(d_x(i)^2+d_y(i)^2);
    end;
    [M, I] = min(z);
    Angle_Car = Angle_trajectory(I);

    x = x1-x0;
    y = y1-y0;

    theta = atan(x/y); % Angle from y axis to z
    if y < 0 % equivalent to abs(delta) > pi/2
        if x < 0
            theta = theta-pi;
        else
            theata = theta+pi;
        end;
    end;
    z = sqrt(x^2+y^2);
    Angle = pi/2 - theta + Angle_Car;
    % Angle of z relative to the car (x_car) (needed to find forwards/backwards &
    % right/left movement):
    dx = z*cos(Angle);
    dy = z*sin(Angle);
    % delta is needed to get the radius and the angle of the wheels:
    delta = atan(dx/dy); % delta is equal to theta relative to the car;

    if dy < 0 % equivalent to abs(delta) > pi/2
        dy = -dy;
        if dx < 0
            delta = delta-pi;
        else
            delta = delta+pi;
        end;
    end;
        
    R = sqrt(dx^2+dy^2)/(2*sin(delta));
    
    if dx>abs(dy) % equivalent to delta > 45 & delta < 135
        dx = 2*R-dx;
    elseif -dx>abs(dy) % equivalent to delta <-45 & delta > -135
        dx = dx-2*R;
    end;

    x_NullPoint = xL+R*cos(Angle_Car);
    y_NullPoint = yL-R*sin(Angle_Car);
    for i = 1:i_max
        x_trajectory(i) = x_NullPoint - R*cos(i*2*delta/i_max+Angle_Car);
        y_trajectory(i) = y_NullPoint + R*sin(i*2*delta/i_max+Angle_Car);
        Angle_trajectory(i) = i*2*delta/(i_max)+Angle_Car;
    end;
    plot(x_trajectory,y_trajectory);

    % Distance to drive (in m):
    s = 2*delta*R/100;

    % Angle of the wheels:
    alpha = atan(2*L*sin(2*atan(dx/dy))/z);
    alpha_degree = alpha*180/pi;
 
    % The angle of the car at the final position ( == Angle_trjectorty(i_max)):
    Car_angle = 2*theta;
    Car_angle_degree = Car_angle*180/pi;
 
    % Stearing of the car:
    D = 150-(1.15*alpha_degree);

    direction = ['D', int2str(D)];

    EPOCommunications('transmit', direction);   % direction
    EPOCommunications('transmit','M156');   % speed

    return x_trajectory;
    return y_trajectory;
    return Angle_trajectory;

end;
