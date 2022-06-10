tic
while(toc < 1.7*s+1)        % time of riding + some additional time
% Here the loop has to start:

data = pa_wavrecord(1,5,Fs*t, 48000);

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

if (toc >= 1.7s)
% Breaking:
if breaking == 1        % no active breaking
    EPOCommunications('transmit', direction);   % direction
    EPOCommunications('transmit','M150');   % speed
else    % active breaking for a minimal amount of time with a force dependent on the distance:
    M = ['M', int2str(150-round(2*s))];
    EPOCommunications('transmit', direction);   % direction
    EPOCommunications('transmit',M);   % speed
end
end
% End of the loop;
end
