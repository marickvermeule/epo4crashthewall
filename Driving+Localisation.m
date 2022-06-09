% Connecting the Bluetooth:     % probably make an input off it
com = '16';
P = ['\\.\COM', com];
comport = P; % the actual COM port
% to use varies.
result = EPOCommunications('open',comport);

% Localisation input:
Fs = 48e3;
t = 10;

load Audio_Reference_Localization.mat
load test_data_5_24.mat
time=[];
samples=[];
r=[];
count=1;
x=[];
y=[];
audioref(2*48000:3*48000);
data(2*48000:3*48000,1);


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

x = x1-x0;              % Change to dx
y = y1-y0;              % Change to dy

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

    EPOCommunications('transmit', 'B5000');
    % set the bit frequency
    EPOCommunications('transmit', 'F15000');
    % set the carrier frequency
    EPOCommunications('transmit', 'R2500');
    % set the repetition count
    EPOCommunications('transmit', 'C0xaa55aa55');
    % set the audio code
    EPOCommunications('transmit', 'A1');

% Here the loop has to start:

    data = pa_wavrecord(1,5,Fs*t, 48000);
% 

hhat_1=ch3(audioref,data(5*48000:6*48000,1),0.7,48000);
hhat_2=ch3(audioref,data(5*48000:6*48000,2),0.7,48000);
hhat_3=ch3(audioref,data(5*48000:6*48000,3),0.7,48000);
hhat_4=ch3(audioref,data(5*48000:6*48000,4),0.7,48000);
hhat_5=ch3(audioref,data(5*48000:6*48000,5),0.7,48000);

[y(1,1:2),x(1,1:2)]=findpeaks(hhat_1);
[y(2,1:2),x(2,1:2)]=findpeaks(hhat_2);
[y(3,1:2),x(3,1:2)]=findpeaks(hhat_3);
[y(4,1:2),x(4,1:2)]=findpeaks(hhat_4);
[y(5,1:2),x(5,1:2)]=findpeaks(hhat_5);

for i=1:5
    for j=1:5
        if j>i
            samples(count)=x(i,1)-x(j,1)
            time(count)=(x(i,1)-x(j,1))/48000;
            r(count)=343*(x(i,1)-x(j,1))/48000;
            count=count+1;
        end
    end
end

x_car=Loc(r)
% End of the loop;

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

function x=Loc(r)

%loc=[1.2222,0.3344,2] %ONLY FOR TESTS
%d=[];
b=[];
x_mic=[];
mic2=[];
A=[];
count=1;
%Mic Locations
%    [x,y,z]
mic1=[0,0,0.5];
mic2=[4,4,0.5];
mic3=[0,4,0.5];
mic4=[4,0,0.5];
mic5=[0,2,0.8];

%calculating distance ONLY FOR TESTS
% d(1)=sqrt((loc(1)-mic1(1))^2+(loc(2)-mic1(2))^2+(loc(3)-mic1(3))^2)
% d(2)=sqrt((loc(1)-mic2(1))^2+(loc(2)-mic2(2))^2+(loc(3)-mic2(3))^2)
% d(3)=sqrt((loc(1)-mic3(1))^2+(loc(2)-mic3(2))^2+(loc(3)-mic3(3))^2)
% d(4)=sqrt((loc(1)-mic4(1))^2+(loc(2)-mic4(2))^2+(loc(3)-mic4(3))^2)
% d(5)=sqrt((loc(1)-mic5(1))^2+(loc(2)-mic5(2))^2+(loc(3)-mic5(3))^2)
%entriies for matrix A
mic_2(1,1:3)=2*(mic2-mic1);
mic_2(2,1:3)=2*(mic3-mic1);
mic_2(3,1:3)=2*(mic4-mic1);
mic_2(4,1:3)=2*(mic5-mic1);
mic_2(5,1:3)=2*(mic3-mic2);
mic_2(6,1:3)=2*(mic4-mic2);
mic_2(7,1:3)=2*(mic5-mic2);
mic_2(8,1:3)=2*(mic4-mic3);
mic_2(9,1:3)=2*(mic5-mic3);
mic_2(10,1:3)=2*(mic5-mic4);
%entries for vector b
x_mic(1)=mic1(1)^2+mic1(2)^2+mic1(3)^2;
x_mic(2)=mic2(1)^2+mic2(2)^2+mic2(3)^2;
x_mic(3)=mic3(1)^2+mic3(2)^2+mic3(3)^2;
x_mic(4)=mic4(1)^2+mic4(2)^2+mic4(3)^2;
x_mic(5)=mic5(1)^2+mic5(2)^2+mic5(3)^2;

%Creating vector b
for i=1:5
    for j=1:5
        if j>i
            b(count)=r(count)^2-x_mic(i)+x_mic(j);
            count=count+1;
        else
        end
    end
end
b=b.'
%creating matrix A
A=zeros(10,6);

for i=1:10
    for j=1:6
        if j==1
            A(i,j:j+2)=mic_2(i,1:3);
        end
        if j>3
            if i<5
                A(i,i+3)=r(i);
            end
            if i>4&i<8
                A(i,i)=r(i);
            end
            if i>7&i<10
                A(i,i-2)=r(i);
            end
            if i==10
                A(i,i-3)=r(i); 
            end
            
        end
           
    end
end
% A.'*A
% inv(A.'*A)
% inv(A.'*A)*A.'
 last=inv(A.'*A)*A.'*b
 last(1:3)
 x=last(1:3)
end
%             
 % 1,2 1,3 1,4 1,5 2,3 2,4 2,5 3,4 3,5 4,5
