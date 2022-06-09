%Date:      19-05-2022
%Author:    Dimme, 
%           based on example by EPO4 teaching team 2016: "EPO4_playrec_example.m"
%      
%Descr:     Simple script which can be used to set the beacon settings and 
%           record audio.  This version uses playrec instead of pa_wavrecord. 
%           The advantage of using playrec is that it possibly introduces
%           less delay compared to pa_wavrecord.
%           
%           Note that you need to set the channels and Fs based on the location where you measure.
%               For office:         channels = 14:19,   Fs = 48 kHz
%               For tellegen{1,2}:  channels = 1:5,     Fs = 44.1 kHz
%           Please confirm for yourself that these settings work properly. 
%
%           USE AT OWN RISK :). Please let us know if there is something wrong.
%      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Comments from original file:
% Playrec - an alternative to pa_wavrecord(.)
% This example script shows how to use playrec to record upto 5 mics.
% Source files can be downloaded from this link below
% http://www.playrec.co.uk/index.html
% 
% We recommend to compile the source files yourself. Nevertheless,
% the precompiled binary files (e.g., for windows use the *.mexw64 file) 
% from the link below
% https://github.com/Janwillhaus/Playrec-Binaries
%
%- for the list of commands for playrec, call playrec without any options      
%- for more detailed explanation of a command use playrec('help','command')
%  
% EPO-4 project, 27-05-2016, TU Delft.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear measurements

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%step 0: user settings
group_name = 'TA';
comport = '\\.\COM19';
channels = 15:19;       %1:5 for tellegen{1,2}; 15:19 for office; channels on which you record
Fs = 48000;             %sample frequency [Hz], 48 kHz for office, <??> for the other 2
second_rec = 1;         %time of recording [s]
bitcode = 'aa55aa55';   %transmitted bits [-], e.g. 'aa55aa55'
F_carrier = 15000;      %carrier frequency [Hz], e.g. 8000   
F_bit = 5000;           %bit frequency [Hz], e.g. 5000
C_repetition = 2500;    %repetition count [-], e.g. 2500
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load Reference_Data_Optimal.mat
audioref=data;
audioref=audioref(2000:4000);
%load [240cm,200cm].mat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%step 1: establish communication, set beacon settings
resultOpen = EPOCommunications('open', comport)


% EPOCommunications('transmit', ['C0x', bitcode]);
% EPOCommunications('transmit', ['F', int2str(F_carrier)]);
% EPOCommunications('transmit', ['B', int2str(F_bit)]);
% EPOCommunications('transmit', ['R', int2str(C_repetition)]);
    EPOCommunications('transmit', 'B4000');
    % set the bit frequency
    EPOCommunications('transmit', 'F8000');
    % set the carrier frequency
    EPOCommunications('transmit', 'R800');
    % set the repetition count
    EPOCommunications('transmit', 'C0x38109746');
    % set the audio code
EPOCommunications('transmit', 'A1');

%Step 2: initialise audiocard
fnc_init_playrec(Fs);  
N = round(second_rec*Fs); %nbr of samples to be recorded

%step 3: make measurements. 
quit = 'n';
i = 1;
while quit ~= 'y'
    disp("Place KITT at the desired location.")
    measurements{i,1} = input("Please specify KITT coordinates as [x, y].");
    
    disp("Taking measurements")
    EPOCommunications('transmit', 'A1');
    measurements{i,2} =  fnc_record_playrec(N, channels);
    EPOCommunications('transmit', 'A0');

    quit = input("If you want to quit, type 'y'. If otherwise, type 'n'");
    i = i+1;
end

resultClose = EPOCommunications('close')
playrec('reset');

%step 4: save workspace
c = clock;
save([group_name, '-', date, '-', num2str(c(4)), '_', num2str(c(5)), '.mat'])

%step 5: some plotting
disp("Plotting...")
[nMeas, ~] = size(measurements);
for i = 1:nMeas
    data = measurements{i,2};
    loc = measurements{i,1};
    figure
    plot(data)
    legend
    title(['location: (x, y) = (', num2str(loc(1)), ', ', num2str(loc(2)), ')'])  
    xlabel('sample [-]')
    ylabel('amplitude []')
end


time=[];
samples=[];
r=[];
count=1;
x=[];
y=[];

hhat_1=ch3(audioref,data(1:48000,1));
hhat_2=ch3(audioref,data(1:48000,2));
hhat_3=ch3(audioref,data(1:48000,3));
hhat_4=ch3(audioref,data(1:48000,4));
hhat_5=ch3(audioref,data(1:48000,5));
x_axis=(1:24000)/24000;
figure(1)
title("Channel")
hold on
plot(x_axis,hhat_1)
plot(x_axis,hhat_2)
plot(x_axis,hhat_3)
plot(x_axis,hhat_4)
plot(x_axis,hhat_5)


%plot(audioref(1:48000));
%plot(data(1:48000,1));
hold off
figure(2)
title("Signal")
hold on
plot(data(1:48000,1));
plot(data(1:48000,2));
plot(data(1:48000,3));
plot(data(1:48000,4));
plot(data(1:48000,5));
hold off
%plot(x_axis,hhat)




[peaks1,Location1]=findpeaks(double(hhat_1>0.8*max(hhat_1)));
[peaks2,Location2]=findpeaks(double(hhat_2>0.8*max(hhat_2)));
[peaks3,Location3]=findpeaks(double(hhat_3>0.8*max(hhat_3)));
[peaks4,Location4]=findpeaks(double(hhat_4>0.8*max(hhat_4)));
[peaks5,Location5]=findpeaks(double(hhat_5>0.8*max(hhat_5)));

x(1,1)=Location1(1)
x(2,1)=Location2(1)
x(3,1)=Location3(1)
x(4,1)=Location4(1)
x(5,1)=Location5(1)

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
