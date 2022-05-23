
function [x,y] = TDAO(d)
r=[];
b=[];
x_mic=[];
mic2=[];
A=[];
count=1;
%Mic Locations
mic1=[0,0];
mic2=[4,4];
mic3=[0,4];
mic4=[4,0];
mic5=[0,2];
%entriies for matrix A
mic_2(1,1:2)=2*(mic2-mic1);
mic_2(2,1:2)=2*(mic3-mic1);
mic_2(3,1:2)=2*(mic4-mic1);
mic_2(4,1:2)=2*(mic5-mic1);
mic_2(5,1:2)=2*(mic3-mic2);
mic_2(6,1:2)=2*(mic4-mic2);
mic_2(7,1:2)=2*(mic5-mic2);
mic_2(8,1:2)=2*(mic4-mic3);
mic_2(9,1:2)=2*(mic5-mic3);
mic_2(10,1:2)=2*(mic5-mic4);
%entries for vector b
x_mic(1)=mic1(1)^2+mic1(2)^ 2;
x_mic(2)=mic2(1)^2+mic2(2)^ 2;
x_mic(3)=mic3(1)^2+mic3(2)^ 2;
x_mic(4)=mic4(1)^2+mic4(2)^ 2;
x_mic(5)=mic5(1)^2+mic5(2)^ 2;

%Creating vector b
for i=1:5
    for j=1:5
        if j>i
            r(count)=d(i)-d(j);
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
    for j=1:5
        if j==1
            A(i,j:j+1)=mic_2(i,1:2);
        end
        if j>2
            if i<5
                A(i,i+2)=r(i);
            end
            if i>4&i<8
                A(i,i-1)=r(i);
            end
            if i>7&i<10
                A(i,i-3)=r(i);
            end
            if i==10
                A(i,i-4)=r(i); 
            end
            
        end
           
    end
end

last=inv(A.'*A)*A.'*b
[x,y]=last(1:2)
end

