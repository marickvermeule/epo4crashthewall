
x=1
y=1
x_car = [x,y]
xi =   [0,0; 4,4; 0,4; 4,0; 0,2]

%d=[sqrt(8),sqrt(8),sqrt(8),sqrt(8),2];
for i=1:5
    d(i) = sqrt((x-xi(i,1))^2 + (y-xi(i,2))^2)
end
r=[];
b=[];
c=[];
x_mic=[];
A=[];
count=1;

% location microphones xi
mic1=[0,0];
mic2=[4,4];
mic3=[0,4];
mic4=[4,0];
mic5=[0,2];

% microphone distance to origin (0,0)
x_mic(1)=mic1(1)^2+mic1(2)^ 2;
x_mic(2)=mic2(1)^2+mic2(2)^ 2;
x_mic(3)=mic3(1)^2+mic3(2)^ 2;
x_mic(4)=mic4(1)^2+mic4(2)^ 2;
x_mic(5)=mic5(1)^2+mic5(2)^ 2;

% RHS matrix
for i=1:5
    for j=1:5
        if j>=i
        else
            r(count)=d(i)-d(j); % range difference
            b(count)=r(count)^2-x_mic(i)+x_mic(j)
            count=count+1;
        end
    end
end

% LHS matrix

% M = [   2*(mic2(1)-mic1(1)), 2*(mic2(2)-mic1(2)), -2*r(1), 0, 0;
%         2*(mic3(1)-mic1(1)), 2*(mic3(2)-mic1(2)), 0, -2*r(2), 0;
%         2*(mic4(1)-mic1(1)), 2*(mic4(2)-mic1(2)), 0, 0, -2*r(3);
%         2*(mic3(1)-mic2(1)), 2*(mic3(2)-mic2(2)), 0, -2*r(4), 0;
%         2*(mic4(1)-mic2(1)), 2*(mic4(2)-mic2(2)), 0, 0, -2*r(5);
%         2*(mic4(1)-mic3(1)), 2*(mic4(2)-mic3(2)), 0, 0, -2*r(6)]
r
% di
            
 % 1,2 1,3 1,4 1,5 2,3 2,4 2,5 3,4 3,5 4,5