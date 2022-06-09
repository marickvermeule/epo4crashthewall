load [0,0]_Last.mat

audioref1=data(:,1);
audioref1=audioref1(700:1700);
load [0,480]_Last.mat
audioref2=data(:,2);
audioref2=audioref2(5750:7750);
load [480,480]_Last.mat
audioref3=data(:,3);
audioref3=audioref3(5550:7000);
load [0,480]_Last.mat
audioref4=data(:,4);
audioref4=audioref4(6600:10500);
load [0,240]_Last.mat
audioref5=data(:,5);
audioref5=audioref5(6400:7800);
load [480,480]_Last.mat

%[0,0]=[50,88] FAIL
%[0,240]=[241,420] FAIL

%[0,480]=[22,467] PASS
%[120,100]=[124,100] PASS
%[120,200]=[115,199] PASS
%[120,300]=[148,292] PASS
%[120,400]=[130,395] PASS

%[240,100]=[240,216] FAIL
%[240,200]=[240,239] FAIL

%[240,240]=[240,240] PASS

%[240,300]=[239,242] FAIL
%[240,400]=[239,244] FAIL

%[360,100]=[355,115] PASS

%[360,200]=[57,-17.7] FAIL

%[360,300]=[357,306] PASS
%[360,400]=[340,382] PASS
%[480,0]=[466,10] PASS

%[480,480]=[387,443] FAIL

% 8 FAILS, 10 PASSES
time=[];
samples=[];
r=[];
count=1;
x=[];
y=[];

hhat_1=ch3(audioref3,data(1:48000,1),0.04,48000);
hhat_2=ch3(audioref3,data(1:48000,2),0.04,48000);
hhat_3=ch3(audioref3,data(1:48000,3),0.04,48000);
hhat_4=ch3(audioref3,data(1:48000,4),0.04,48000);
hhat_5=ch3(audioref3,data(1:48000,5),0.04,48000);
x_axis=(1:48000)/48000;
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
plot(data(1:24000,1));
plot(data(1:24000,2));
plot(data(1:24000,3));
plot(data(1:24000,4));
plot(data(1:24000,5));
hold off
%plot(x_axis,hhat)




[peaks1,Location1]=findpeaks(double(hhat_1>0.75*max(hhat_1)));
[peaks2,Location2]=findpeaks(double(hhat_2>0.75*max(hhat_2)));
[peaks3,Location3]=findpeaks(double(hhat_3>0.75*max(hhat_3)));
[peaks4,Location4]=findpeaks(double(hhat_4>0.75*max(hhat_4)));
[peaks5,Location5]=findpeaks(double(hhat_5>0.75*max(hhat_5)));

x(1,1)=Location1(1);
x(2,1)=Location2(1);
x(3,1)=Location3(1);
x(4,1)=Location4(1);
x(5,1)=Location5(1);

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

x_car=Loc(r)


%%%%%%%%%%%%%%%%%%%%%%%%%
%%Testing ONLY
%%%%%%%%%%%%%%%%%%%%%%%%%
loc=[4.8,4.8,0.3]; %ONLY FOR TESTS
d=[];
r_check=[];
mic1=[0,0,0.5];
mic2=[0,4.8,0.5];
mic3=[4.8,4.8,0.5];
mic4=[4.8,0,0.5];
mic5=[0,2.4,0.8];
d(1)=sqrt((loc(1)-mic1(1))^2+(loc(2)-mic1(2))^2+(loc(3)-mic1(3))^2);
d(2)=sqrt((loc(1)-mic2(1))^2+(loc(2)-mic2(2))^2+(loc(3)-mic2(3))^2);
d(3)=sqrt((loc(1)-mic3(1))^2+(loc(2)-mic3(2))^2+(loc(3)-mic3(3))^2);
d(4)=sqrt((loc(1)-mic4(1))^2+(loc(2)-mic4(2))^2+(loc(3)-mic4(3))^2);
d(5)=sqrt((loc(1)-mic5(1))^2+(loc(2)-mic5(2))^2+(loc(3)-mic5(3))^2);
count=1;
for i=1:5
    for j=1:5
        if j>i
            r_check(count)=d(i)-d(j);
            count=count+1;
        else
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
r
r_check
r_dif=r-r_check

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
