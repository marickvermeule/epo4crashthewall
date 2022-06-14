function [x_trajectory, y_trajectory, Angle_trajectory] = trajectory(x0, y0, x1, y1, x_trajectory, y_trajectory, Angle_trajectory)
global i_max;
global L;
%global D;
for i = 1:i_max
        d_x(i) = x_trajectory(i)-x0;
        d_y(i) = y_trajectory(i)-y0;
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

    x_NullPoint = x0+R*cos(Angle_Car);
    y_NullPoint = y0-R*sin(Angle_Car);
    for i = 1:i_max
        x_trajectory(i) = x_NullPoint - R*cos(i*2*delta/i_max+Angle_Car);
        y_trajectory(i) = y_NullPoint + R*sin(i*2*delta/i_max+Angle_Car);
        Angle_trajectory(i) = i*2*delta/(i_max)+Angle_Car;
    end;
    plot(x_trajectory,y_trajectory);
    hold on;
    pause(2);

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

    direction = ['D', int2str(D)]

    EPOCommunications('transmit', direction);   % direction
    EPOCommunications('transmit','M156');   % speed
    pause(2);
    EPOCommunications('transmit', direction);   % direction
    EPOCommunications('transmit','M150');   % speed   

    %return x_trajectory;
    %return y_trajectory;
    %return Angle_trajectory;

end
