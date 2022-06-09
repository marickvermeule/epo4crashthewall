% test of EPOCommunications interface to KITT
% this version: show the car in a plot window; WASD interaction
% plot using uifigure (which has limited functionality)
% 
% Alle-Jan van der Veen, TU Delft, 13 May 2020

% the directory "carmodel" contains the scripts and needs to be in the path:
% addpath carmodel -begin

clear variables;% needed to clear the internal state of EPOCommunications

%---------------------------------------------------------------------------
% initializations
EPOCommunications('init','X[100;0]');	% initial position of car
EPOCommunications('init','D[0;1]');	% initial direction of car

% define positions of microphones
P = [
0   600     0   600;
0     0   600   600;
30   30    30    30];
pp = mat2str(P);
EPOCommunications('init',['P' pp]);% initialize positions of mics
EPOCommunications('init','J20000');	% set sample rate of mics
EPOCommunications('init','N2000');	% set number of samples to return

d2 = [];
% define arena boundary
B1 = [
-50 650 650 -50;
-50 -50 650 650];	% outer arena boundary (outside bounding box)
NAN = [NaN; NaN];	% spacer between objects
B2 = [
-21 621 621 -21;
-21 -21 621 621];	% inner arena boundary (hole since it overlaps B1)
bb = mat2str([B1 NAN B2]);
EPOCommunications('init',['O' bb]);	% initialize arena boundary

% 
% % % define obstacle position (polygons)
%  O1 = [
%  200 200 260 230; 
%  200 240 240 200];	% first obstacle
%  O2 = [
%  350 380 410 410; 
%  200 240 240 200];	% second obstacle
%  oo = mat2str([O1 NAN O2]);
%  EPOCommunications('init',['O' oo]);	% initialize obstacles

% define two waypoints
W = [
180   400;
150   400];
ww = mat2str(W);
EPOCommunications('init',['W' ww]);	% initialize waypoints


% create kitt!
kitt = EPOCommunications('open','P')	% create kitt (P = public, with access
					% to position, orientation, velocity)
                    
%---------------------------------------------------------------------------
N = 200;	% number of samples (about 30 seconds with T = 0.1)
T = 0.05;	% time step between updates, not faster than 50 ms
eps2 = 10;
eps = 90;
epswall = 300;
% keep statistics on positions vs time
xx = zeros(2,N);
dd = zeros(2,N);
tt = zeros(1,N);	
pn = zeros(1,N);
tp = zeros(1,N);
d2hist = zeros(1,N);
%---------
% plot with user interface that responds to keypresses (with function keyfig)
%f = uifigure('WindowKeyPressFcn',@figkey,'Name','KITT');
f = uifigure('Name','KITT');

% enlarge window to size 800 x 800
v = get(f,'Position');
v(3:4) = [800 800];
set(f,'Position',v);

aa = axes(f);			% plot axes handle; store handle in aa

f.WindowKeyPressFcn = {@figkey, kitt,aa}; %creating callback function and passing "kitt" as additional input argument (thanks, Mathijs van Binnendijk)

axis(aa,'square')		% aspect ratio of plot
axis(aa,[-50 650 -50 650])	% restrict plot size to slightly more than arena
hold(aa,'on')
title(aa,'control KITT using W A S D keys; space = stop; c = check waypoint; f = fire zap')

% plot arena box (assume 600 * 600)
plot(aa,[0 600 600 0 0],[0 0 600 600 0],'--')

hs = plot(kitt.Sensors,aa);	% plot obstacles and arena bounding box
plot(kitt.Micarray,aa);		% plot mics as "x"
hw = plot(kitt.Waypoints,aa);	% plot waypoints as "o"

% track some parameters in the corner of the window
s1 = sprintf('force: %g',kitt.force);
s2 = sprintf('velocity: %0.2f cm/s',kitt.velocity);
s3 = sprintf('angle: %g',kitt.angle);
s4 = sprintf('distL: %g cm',kitt.distL);
s5 = sprintf('distR: %g cm',kitt.distR);
h(1) = text(aa,0,490,s1);	% keep handle so we can update string
h(2) = text(aa,0,470,s2);
h(3) = text(aa,0,450,s3);
h(4) = text(aa,0,430,s4);
h(5) = text(aa,0,410,s5);

% show initial position of car
hand = plot(kitt,aa);		% draw outline of the car

drawnow limitrate nocallbacks;	% flush plot buffer

%---------------------------------------------------------------------------
% loop to drive around and collect positions
now = tic;				% start timer
position = zeros(2,2);

%The time until breaking (dependent on the distance):
x_field = 480;
y_field = 480;

% Length of Car:
L = 42;

% Starting points:              % probably make an input off it
x0 = 100;
y0 = 0;

% End points:                   % probably make an input off it
x1 = 450;
y1 = 200;
dstop = [x1 y1];

x = x1-x0;
y = y1-y0;

% Acceptable Error:

% Angle Startpoint-Endpoint:
theta = atan(x/y); % this is the angle of the triangle from the starting point to the endpoint
theta_degree = theta*180/pi;

% Radius:
R = sqrt(x^2+y^2)/(2*sin(theta)); % this is the Radius of the circle on which the car rides

x_NullPoint = x0+R; % these are the centrepoint of the radius
y_NullPoint = y0; % same as above

% Distance to be driven (needed for the breaking time):
s2 = 2*theta*R/100;

% Calculate the position (x,y) & angle of the Car at given point on the trajectory:
i_max = 100; % can be changed; dependent on how often we want an update;
for i = 1:i_max
    x_trajectory(i) = x_NullPoint - R*cos(i*2*theta/i_max);
    y_trajectory(i) = R*sin(i*2*theta/i_max);
    %Angle_trajectory(i) = asin(y_trajectory(i)/R);
    save('plot.mat','x_trajectory','y_trajectory');
end
if theta_degree > 45
    xOver = x1-x_NullPoint;
    x = x_NullPoint-xOver;
end
%going from phi to direction commands
% CALCULATIONS:
% Angle of the wheels:
alpha = atan(2*L*sin(2*atan(x/y))/(sqrt(x^2+y^2)));
alpha_degree = alpha*180/pi;

% The angle of the car at the final position ( == Angle_trjectorty(i_max)):
Car_angle = 2*theta;
Car_angle_degree = Car_angle*180/pi;

% Stearing of the car:
D = 150-(1.05*alpha_degree);            % this needs some tweaking for better accuarcy

% Returning the value to the Car:
direction = ['D', int2str(D)];
% DRIVE:
EPOCommunications('transmit', direction);   % direction
EPOCommunications('transmit','M156');   % speed

then = toc(now);
for n = 1:N
   % query car status (kitt automatic updates as time progresses)
   x = kitt.position;
   d = kitt.orientation;
   a = kitt.angle;
   v = kitt.velocity;
   t = toc(now);
   % keep statistics
   xx(:,n) = x;
   dd(:,n) = d;
   tt(:,n) = t;
   % show car
   plot(aa,x(1),x(2),'bo');		% draw car position as 'o'
   delete(hand)				% remove old outline of car
   hand = plot(kitt,aa);		% draw outline of the car
   drawnow limitrate nocallbacks;	% flush plot buffer
   if (isempty(d2) == 0)
       d2 = D;
   else
   end
   % show current speed and angle in the corner of the plot
   s1 = sprintf('force: %g',kitt.force);
   s2 = sprintf('velocity: %0.2f cm/s',kitt.velocity);
   s3 = sprintf('angle: %g',kitt.angle);
   s4 = sprintf('distL: %g cm',kitt.distL);
   s5 = sprintf('distR: %g cm',kitt.distR);
   s6 = sprintf('time: %0.2f',t);
   s7 = sprintf('crash: %g',carcrash(kitt));
   s8 = sprintf('zaps: %g',kitt.numzaps);
   delete(h)
   h(1) = text(aa,0,490,s1);		% update string
   h(2) = text(aa,0,470,s2);
   h(3) = text(aa,0,450,s3);
   h(4) = text(aa,0,430,s4);
   h(5) = text(aa,0,410,s5);
   h(6) = text(aa,0,390,s6);
   h(7) = text(aa,0,370,s7);
   h(8) = text(aa,0,350,s8);
   
   % update plot of waypoints (ERROR not efficient to do this within the loop)
   delete(hw);
   hw = plot(kitt.Waypoints,aa);
   
   % update plot of obstacles (ERROR not efficient to do this within the loop)
   delete(hs);
   hs = plot(kitt.Sensors,aa);	% plot obstacles and arena bounding box
   %evaluating control and stopping 
   if ((isempty(x_trajectory)&&isempty(y_trajectory)) == 0)
    k = 2;
    Angle_trajectory = (180/pi)*atan(y_trajectory'./x_trajectory');

    %with the trajectory code
    %this is just the old position
    %this is just for testing
    %defining the orientation of the car based on the localization
    xlast = xx(:,end);
    if (x(1) == 0)
        theta = 90;
    else    
        theta = (180/pi)*atan((x(2)-xlast(2))/(x(1)-xlast(1)));
    end
    %finding out were you are on the predefined trajectory
    index =1;
    minn = 1000;
    check = [x_trajectory' y_trajectory'];
    for j=1:length(check)
        new_min = sqrt(abs((x(1)-check(j,1))^2)+abs((x(2)-check(j,2))^2));
        if (abs(new_min) <= abs(minn))
            minn = abs(new_min);
            index = j;
        else
        end
    end
    %basic p controller to control the stearing
    phi = -k*(theta-Angle_trajectory(index));
    D2 = D+phi;
 
  %  pn(:,n) = phi;
     tp(:,n) = theta;
    %D2 = uint8(D2);
     d2hist(:,n) = D2;
     minhist(:,n) = minn;
    direction = ['D', int2str(D2)];
    
     %controlling
    if(minn>eps2)
        EPOCommunications('transmit', direction);   % direction
    else
        direction = ['D', int2str(D)];
         EPOCommunications('transmit', direction);
    end
   end
    %stopping
    g = 0;
   if (norm(abs(x'-dstop)) <= eps)
           EPOCommunications('transmit','M150');   % speed
           g = 1
          
   else
   end
    %emergency stop when a wall is nearby
    %still able to roll out
    if (min(kitt.distL,kitt.distR) <= eps && v >= 0.1)
     m = 1
      if(abs(v) >= 0.03 && min(kitt.distL,kitt.distR) == kitt.distL && d(1) < 0)
      EPOCommunications('transmit','M135');   % speed
      EPOCommunications('transmit','D100');   % direction
      elseif((abs(v) >= 0.03 )&& (min(kitt.distL,kitt.distR) == kitt.distR)  && d(1) > 0)
    q = 1
      EPOCommunications('transmit','M135');   % speed
      EPOCommunications('transmit','D200');   % direction
      else 
      %just a wall on the other side of the car
      end
    else
    end
    if (v < 0 && g == 0)
          EPOCommunications('transmit','M150')
         
    else
  end
    %we want to pause T seconds, but subtract the elapsed time in the loop
   Tcorr = max( T - (toc(now) - t), 0);	
   pause(Tcorr);			% wait T sec
end
s6 = sprintf('time: %0.2f EXPIRED',t);
h(6) = text(aa,0,390,s6);
% end of script

%---------------------------------------------------------------------------

%function figkey(kitt,keydata)
function figkey(~, keydata, kitt,aa)
global x_trajectory;
global y_trajectory;
global dstop;
global D;
    % callback function to key presses in the uifigure
    % This will update kitt velocity and angle (will automatically update
    % position/direction as a result)
    % We should use EPOCommunications but directly accessing kitt is easier

    key = keydata.Character;		% the pressed keyboard key
   
    switch key
     case {'w'}
        % speed up
       kitt.force = kitt.force + 1;
	% EPOCommunications('transmit','M160')	% motor
     case {'s'}
        % speed down
       kitt.force = kitt.force - 1;
	% EPOCommunications('transmit','M160')	% motor
     case {'a'}
        % steer to left
       kitt.angle = kitt.angle + 2;
	% EPOCommunications('transmit','D160')	% wheel angle
     case {'d'}
        % steer to right
       kitt.angle = kitt.angle - 2;
	% EPOCommunications('transmit','D160')	% wheel angle
     case {' '}
        % emergency stop
       kitt.angle = 150;
       kitt.force = 150;
	% EPOCommunications('transmit','D160')	% wheel angle
	% EPOCommunications('transmit','M160')	% motor
     case {'c'}
        % check distance to waypoint
	d = kitt.distW;
        s8 = sprintf('waypoint: %0.2f cm',d);
        text(aa,0,330,s8);
	% ERROR the second waypoint text overwrites the first text...
     case {'f'}
        % fire zap to destroy obstacle
	tf = launchzap(kitt);		% logical: true=success
	% tf = EPOCommunication('transmit','O')
        case{'g'}
   

% Localisation input needed to compare actual position to model
% Depending on the real position to the intended breaking position (& the
% allowed error epsilon)
% if ((x_in-x1)^2+(y_in-y1)^2 <= epsilon^2)
%     EPOCommunications('transmit', 'D150');   % direction
%     EPOCommunications('transmit','M150');   % speed
% end;


    end
end
