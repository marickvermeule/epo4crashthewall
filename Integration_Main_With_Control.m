%START UP SEQUENCE USED TO RETRIEVE DESTINATION COORDINATES
load Reference_Data.mat



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
audioref3=data(:,3);
audioref3=audioref3(5550:7000);
%Variables outside the loop

x_plot=[];
y_plot=[];


t = createErgoTimer;


%Here The Localisation Starts
start(t)


%%%START DRIVING CAR

%%%STOP DRIVING CAR

pause(15)


if check_3==1
  %%%%START DRIVING CAR
    %%%STOP DRIVING CAR
else
  % Don't start driving second time
end

%%%STOP LOCALIZATION

stop(t)

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

function t = createErgoTimer()

t = timer;
%t.StartFcn = @ergoTimerStart;
t.TimerFcn = @takeBreak;
%t.StopFcn = @ergoTimerCleanup;

% 10 minutes between breaks + 30 second break
t.Period =5;

% time till first break
t.StartDelay =0; 
t.ExecutionMode = 'fixedSpacing';

end 

function takeBreak(mTimer,~)
    % %Part that needs to be in loop
% %variables in loop
samples=[];
r=[];
count=1;
x=[];
y=[];

data{i,2} =  fnc_record_playrec(N, channels);

hhat_1=ch3(audioref,data(5*48000:6*48000,1),0.04,48000);
hhat_2=ch3(audioref,data(5*48000:6*48000,2),0.04,48000);
hhat_3=ch3(audioref,data(5*48000:6*48000,3),0.04,48000);
hhat_4=ch3(audioref,data(5*48000:6*48000,4),0.04,48000);
hhat_5=ch3(audioref,data(5*48000:6*48000,5),0.04,48000);

[peaks1,Location1]=findpeaks(double(hhat_1>0.6*max(hhat_1)));
[peaks2,Location2]=findpeaks(double(hhat_2>0.6*max(hhat_2)));
[peaks3,Location3]=findpeaks(double(hhat_3>0.6*max(hhat_3)));
[peaks4,Location4]=findpeaks(double(hhat_4>0.6*max(hhat_4)));
[peaks5,Location5]=findpeaks(double(hhat_5>0.6*max(hhat_5)));

for i=1:5
    for j=1:5
        if j>i
            samples(count)=x(i,1)-x(j,1);
            time(count)=(x(i,1)-x(j,1))/48000;
            r(count)=343*(x(i,1)-x(j,1))/48000;
            count=count+1;
        end
    end
end

x_car=Loc(r);
x_plot(end+1)=x_car(1);
y_plot(end+1)=x_car(2);
% end part that needs to be in loop
end