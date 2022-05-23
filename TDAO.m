d=[sqrt(8),sqrt(8),sqrt(8),sqrt(8),2];
r=[];
b=[]
x_mic=[]
A=[]
count=1;
mic1=[0,0];
mic2=[4,4];
mic3=[0,4];
mic4=[4,0];
mic5=[0,2];


x_mic(1)=mic1(1)^2+mic1(2)^ 2;
x_mic(2)=mic2(1)^2+mic2(2)^ 2;
x_mic(3)=mic3(1)^2+mic3(2)^ 2;
x_mic(4)=mic4(1)^2+mic4(2)^ 2;
x_mic(5)=mic5(1)^2+mic5(2)^ 2;


for i=1:length(d)
    for j=1:length(d)
        if j>=i
        else
            r(count)=d(i)-d(j);
            b(count)=r(count)^2-x_mic(i)+x_mic(j);
            count=count+1;
        end
    end
end


            
 % 1,2 1,3 1,4 1,5 2,3 2,4 2,5 3,4 3,5 4,5