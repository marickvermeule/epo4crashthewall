%START UP SEQUENCE USED TO RETRIEVE DESTINATION COORDINATES
load Reference_Data.mat

loop=0;

check_1=0;
check_2=0;
check_3=0;
check_4=0;
Loc_array=[];
Port=input("What Port:");

while check_1==0
    Location=input("Location of Destination:[x,y]:");
    if prod(size(Location)==[1,2],"all")==1
        if 0<=Location(1)&Location(1)<=4.8
            if 0<=Location(2)&Location(2)<=4.8
                check_1=1;
            else
                check_1=0;
            end
        else
            check_1=0;
        end
    else
        check_1=0;
    end
end

Loc_array(1,:)=Location;
while check_2==0
    a=input("do you want to add a second Destination y/n:",'s');
    if a=="y"
        while check_3==0
            Location=input("Location of Destination:[x,y]:");
            if prod(size(Location)==[1,2],"all")==1
                if 0<=Location(1)&Location(1)<=4.8
                    if 0<=Location(2)&Location(2)<=4.8
                        check_3=1;
                    else
                    check_3=0;
                    end
                else
                    check_3=0;
                end
            else
                check_3=0;
            end
        end
        Loc_array(2,:)=Location;
        check_2=1;
    elseif a=="n"
        check_2=1;
    else
        check_2=0;
    end
end

% group_name = 'A2';
comport = '\\.\COM';
comport=comport+string(Port);

comport = '\\.\COM39';
resultOpen = EPOCommunications('open', comport);

%%%%START AUDIO BEACON

EPOCommunications('transmit', 'B4000');
    % set the bit frequency
EPOCommunications('transmit', 'F8000');
    % set the carrier frequency
EPOCommunications('transmit', 'R800');
    % set the repetition count
EPOCommunications('transmit', 'C0x38109746');
    % set the audio code
EPOCommunications('transmit', 'A1');


%%%START LOCALIZATION
channels = 15:19;       %1:5 for tellegen{1,2}; 15:19 for office; channels on which you record
Fs = 48000;             %sample frequency [Hz], 48 kHz for office, <??> for the other 2
second_rec = 1;         %time of recording [s]
fnc_init_playrec(Fs);  
N = round(second_rec*Fs); %nbr of samples to be recorded

%%Loading in Reference Signal
load [480,480]_Last.mat

audioref=data(:,3);
audioref=audioref(5550:7000);
%Variables outside the loop

x_plot=[];
y_plot=[];
figure(1)
xlim([0 4.8])
ylim([0 4.8])

%Here The Localisation Starts



% VARIABLES & INPUTS:

% Starting points:              % probably make an input off it
x0 =0 %x_car(1)*100;              % Takes The First Localisation Position as Starting Point
y0 =0 %x_car(2)*100;              % Takes The First Localisation Position as Starting Point

% End points:                   % probably make an input off it
x1 = Loc_array(1,1)*100;
y1 = Loc_array(1,2)*100;
%initializing x_car for 1 check 
x_car = [];
if (nonempty(x_car) == 0)                                                                                                                              
while (norm(x_car-[x1 y1]) => 20) 
    [x_trajectory,y_trajectory,Angle_trajectory] = trajectory(x0,y0,x1,y1);
    pause(1)
    EPOCommunications('transmit','M150') 
    pause(1)
    loop_end = 3; 
while loop~=loop_end
samples=[];
r=[];
count=1;
x=[];
y=[];

data=  fnc_record_playrec(N, channels);

hhat_1=ch3(audioref,data(1:48000,1));
hhat_2=ch3(audioref,data(1:48000,2));
hhat_3=ch3(audioref,data(1:48000,3));
hhat_4=ch3(audioref,data(1:48000,4));
hhat_5=ch3(audioref,data(1:48000,5));


[peaks1,Location1]=findpeaks(double(hhat_1>0.65*max(hhat_1)));
[peaks2,Location2]=findpeaks(double(hhat_2>0.65*max(hhat_2)));
[peaks3,Location3]=findpeaks(double(hhat_3>0.65*max(hhat_3)));
[peaks4,Location4]=findpeaks(double(hhat_4>0.65*max(hhat_4)));
[peaks5,Location5]=findpeaks(double(hhat_5>0.65*max(hhat_5)));


x(1,1)=Location1(1);
x(2,1)=Location2(1);
x(3,1)=Location3(1);
x(4,1)=Location4(1);
x(5,1)=Location5(1);

for i=1:5
    for j=1:5
        if j>i
            r(count)=343*(x(i,1)-x(j,1))/48000;
            count=count+1;
        end
    end
end

x_car=Loc(r)

if x_car(1)<=4.8
    if x_car(2)<=4.8
        x_plot(end+1)=x_car(1);
        y_plot(end+1)=x_car(2);
        plot(x_plot,y_plot)
    end
end

loop=loop+1;
end
loop=0;
end
else
end



% Breaking:
EPOCommunications('transmit', direction);   % direction
EPOCommunications('transmit','M150');   % speed

loop=0;
pause(5)


if check_3==1
    x0 =x_car(x_plot(end))*100;              % Takes The First Localisation Position as Starting Point
    y0 =x_car(x_plot(end))*100;              % Takes The First Localisation Position as Starting Point

    % End points:                   % probably make an input off it
    x1 = Loc_array(1,1)*100;
    y1 = Loc_array(1,2)*100;

   
    
    [x_trajectory, y_trajectory, Angle_trajectory] = trajectory(x0,y0,x1,y1);
    
    loop_end=round(1.7(s/second_rec))


    while loop~=loop_end
        samples=[];
        r=[];
        count=1;
        x=[];
        y=[];

        data=  fnc_record_playrec(N, channels);

        hhat_1=ch3(audioref,data(1:48000,1));
        hhat_2=ch3(audioref,data(1:48000,2));
        hhat_3=ch3(audioref,data(1:48000,3));
        hhat_4=ch3(audioref,data(1:48000,4));
        hhat_5=ch3(audioref,data(1:48000,5));


        [peaks1,Location1]=findpeaks(double(hhat_1>0.65*max(hhat_1)));
        [peaks2,Location2]=findpeaks(double(hhat_2>0.65*max(hhat_2)));
        [peaks3,Location3]=findpeaks(double(hhat_3>0.65*max(hhat_3)));
        [peaks4,Location4]=findpeaks(double(hhat_4>0.65*max(hhat_4)));
        [peaks5,Location5]=findpeaks(double(hhat_5>0.65*max(hhat_5)));


        x(1,1)=Location1(1);
        x(2,1)=Location2(1);
        x(3,1)=Location3(1);
        x(4,1)=Location4(1);
        x(5,1)=Location5(1);

        for i=1:5
            for j=1:5
                if j>i
                    r(count)=343*(x(i,1)-x(j,1))/48000;
                    count=count+1;
                end
            end
        end

        x_car=Loc(r)

        if x_car(1)<=4.8
            if x_car(2)<=4.8
                x_plot(end+1)=x_car(1);
                y_plot(end+1)=x_car(2);
                plot(x_plot,y_plot)
            end
        end

        loop=loop+1;
    end



    % Breaking:
    EPOCommunications('transmit', direction);   % direction
    EPOCommunications('transmit','M150');   % speed

    loop=0;
else
  % Don't start driving second time
end

%%%STOP LOCALIZATION


%%%STOP AUDIO BEACON

playrec('reset');
resultClose = EPOCommunications('close')

%functions

function x=Loc(r)

%loc=[1.2222,0.3344,2] %ONLY FOR TESTS
%d=[];
b=[];
x_mic=[];
mic_2=[];
A=[];
count=1;
%Mic Locations
%    [x,y,z]
mic1=[0,0,0.5];
mic2=[0,4.8,0.5];
mic3=[4.8,4.8,0.5];
mic4=[4.8,0,0.5];
mic5=[0,2.4,0.8];

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
b=b.';
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
 last=inv(A.'*A)*A.'*b;
 last(1:3);
 x=last(1:3);
end 
function [x_trajectory,y_trajectory,Angle_trajectory,D] = trajectory(xb,yb,xe,ye)
L = 42;
 x = xe-xb;              % Change to dx
    y = ye-yb;              % Change to dy

    % Acceptable Error:
    epsilon = 20; % this is the range in which we want to end up (radius around the endpoint that is close enough)

    % Angle Startpoint-Endpoint:
    theta = atan(x/y); % this is the angle of the triangle from the starting point to the endpoint
    theta_degree = theta*180/pi;

    % Radius:
    R = sqrt(x^2+y^2)/(2*sin(theta)); % this is the Radius of the circle on which the car rides

    x_NullPoint = xb+R; % these are the centrepoint of the radius
    y_NullPoint = yb; % same as above

    % Distance to be driven (needed for the breaking time):
    s = 2*theta*R/100;

    % Calculate the position (x,y) & angle of the Car at given point on the trajectory:
    i_max = 100; % can be changed; dependent on how often we want an update;
    for i = 1:i_max
    x_trajectory(i) = x_NullPoint - R*cos(i*2*theta/i_max);
    y_trajectory(i) = R*sin(i*2*theta/i_max);
    Angle_trajectory(i) = asin(y_trajectory(i)/R);
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
    %pause(1.7*s);           % needs tweaking: the additional term (+0.7) is needed for small distances, but not for large ones. find a  relation that gives the time needed dependent on the distance;
end
function v = speed(x,y)
     vy = diff(y)/T;
     vx = diff(x)/T;
     v = sqrt(vx^2+vy^2);
end
function control(x_trajectory,y_trajectory,xnow,ynow,xlast,ylast,d)
    k = 2;
    Angle_trajectory = (180/pi)*atan(y_trajectory'./x_trajectory');

    %with the trajectory code
    %this is just the old position
    %this is just for testing
    %defining the orientation of the car based on the localization
    if (xnow == xlast)
        theta = 90;
    else    
        theta = (180/pi)*atan((ynow-ylast)/(xnow-xlast));
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
        elseif( minn == 1000 && j == 100)
            fprintf('something is wrong');
        end
    end
    %basic p controller to control the stearing
    phi = -k*(theta-Angle_trajectory(index));
    D2 = D+phi;
    direction = ['D', int2str(D2)];
     %controlling based on being eps 2 away from the trajectory
    if((minn>eps2) && (minn ~= 1000))
        EPOCommunications('transmit', direction);   % direction
    else
    end
end
function d = orientation(xlast,ylast,xnow,ynow)
    if (xnow == xlast)
        d = 90;
    else    
        d = (180/pi)*atan((xnow-xlast)/(ynow-ylast));
    end
end
% only use parking when the error wrst the trajectory is not big
function parking(v,xnow,ynow,xstop,ystop)
    if (v <= 0.05 && norm(abs(x'-dstop)) >= 10 )
        EPOCommunications('transmit','M144')
    else
    end
    if (abs(v) > 0 && toc(now) > 20)       
          EPOCommunications('transmit','M150')
    else
    end
end