% EPO4 A2
% Alex Hirsig
% 25.04.2022
load Voice_Recognition_Model_Kais.mat

Fs=8000;
L=Fs*(20/1000);
ov=L*(1/2);
threshold=0.01;
Ytest_pred=0;
dummy=0;
dummy2=0;

comport = '\\.\COM8'; % the actual COM port
% to use varies.
result = EPOCommunications('open',comport);
% open connection.
DistanceR = 100;
dir = 0;    % Default direction = stillstand
Values = zeros(1,250);
i = 0;
t = createErgoTimer;
start(t)
%disp('Check for input:')

while true
% print("hello")
[~,~,button]=ginput(1);
if button == 113    % quit the program
    break
end

if button==114
    recObj = audiorecorder(Fs,16,1); % create audio object, 16 bits resolution
    disp('Start speaking...')
    recordblocking(recObj, 2); % do a 2 second recording (blocking)
    disp('End of Recording.');
    y = getaudiodata(recObj); %supposed to be 16000x1 vector  
    x_test=ExtractFeat(y,Fs,L,ov,threshold);
    % standard normalize 
    x_test=(x_test-mu_train)./sigma_train;
    % predic
    Ytest_pred_str = model.predict(x_test);
    Ytest_pred = str2double(Ytest_pred_str);    % 1, 2, 3 dependent on what is recorded
end
    
if dir == 0     % stillstand
   if button == 119    % (w), go forwards
        dir = 1;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M165');   % speed
   elseif button == 115   % (s), go backwards
        dir = 2;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M140');   % speed
   elseif button == 97   % (a), go left
        dir = 3;
        EPOCommunications('transmit','D130');   % direction
        EPOCommunications('transmit','M150');   % speed
   elseif button == 100   % go right
        dir = 4;
        EPOCommunications('transmit','D170');   % direction
        EPOCommunications('transmit','M150');   % speed    
   end;
elseif dir == 1     % forwards
    if button == 112    % stop
        dir = 0;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 115     % go backwards
        dir = 2;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M135');   % speed
    elseif button == 97   % go left forwards
        dir = 5;
        EPOCommunications('transmit','D130');   % direction
        %EPOCommunications('transmit','M160');   % speed
   elseif button == 100   % go right forwards
        dir = 6;
        EPOCommunications('transmit','D170');   % direction
        %EPOCommunications('transmit','M160');   % speed     
    end;
elseif dir == 2     % backwards
    if button == 112    % stop
        dir = 0;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 119     % go forwards
        dir = 1;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M160');   % speed
    elseif button == 97   % go left backwards
        dir = 7;
        EPOCommunications('transmit','D130');   % direction
        %EPOCommunications('transmit','M140');   % speed
   elseif button == 100   % go right backwards
        dir = 8;
        EPOCommunications('transmit','D170');   % direction
        %EPOCommunications('transmit','M140');   % spee
    end;
elseif dir == 3     % Left stillstand
    if button == 112    % stop
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 119     % go left forwards
        dir = 5;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M160');   % speed
    elseif button == 115   % go left backwards
        dir = 7;
        %EPOCommunications('transmit','D130');   % direction
        EPOCommunications('transmit','M140');   % speed
    elseif button == 100   % go to stillstand (1 step to the right from current position)
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        %EPOCommunications('transmit','M140');   % speed
    end;
elseif dir == 4
    if button == 112    % stop
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 119     % go right forwards
        dir = 5;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M160');   % speed
    elseif button == 115   % go right backwards
        dir = 7;
        %EPOCommunications('transmit','D130');   % direction
        EPOCommunications('transmit','M140');   % speed
    elseif button == 97   % go to stillstand (1 step to the left from current position)
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        %EPOCommunications('transmit','M140');   % speed
    end;
elseif dir == 5     % Left forwards
    if button == 112    % stop
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 115     % go left backwards
        dir = 7;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M140');   % speed
   elseif button == 100   % go forwards (1 step to the right from current position)
        dir = 1;
        EPOCommunications('transmit','D150');   % direction
        %EPOCommunications('transmit','M160');   % speed
    end;
elseif dir == 6     % Right forwards
    if button == 112    % stop
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 115     % go right backwards
        dir = 8;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M140');   % speed
    elseif button == 97   % go forwards (1 step to the left from current position)
        dir = 1;
        EPOCommunications('transmit','D150');   % direction
        %EPOCommunications('transmit','M140');   % speed
    end;
 elseif dir == 7    % Left backwards
    if button == 112    % stop
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 119     % go left forwards
        dir = 5;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M160');   % speed
   elseif button == 100   % go backwards (1 step to the right from current state)
        dir = 2;
        EPOCommunications('transmit','D150');   % direction
        %EPOCommunications('transmit','M160');   % speed
    end;
elseif dir == 8     % Right backwards
    if button == 112    % stop
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 119     % go right forwards
        dir = 6;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M160');   % speed
    elseif button == 97   % go backwards (1 step to the left from current state)
        dir = 2;
        EPOCommunications('transmit','D150');   % direction
        %EPOCommunications('transmit','M140');   % speed
    end;
end;
end;

stop(t)
status = EPOCommunications('close',comport);
% close connection.


function t = createErgoTimer()
global i;
t = timer;
t.StartFcn = @ergoTimerStart;
t.TimerFcn = @takeBreak;
t.StopFcn = @ergoTimerCleanup;

% 10 minutes between breaks + 119 second break
t.Period = 0.1;
% time till first break
t.StartDelay = 0; 

% Number of breaks during 8-hr period
% t.TasksToExecute = ceil(8*60^2/t.Period);
t.ExecutionMode = 'fixedSpacing';
end 

function ergoTimerStart(mTimer,~)
disp("Start")
end

function takeBreak(mTimer,~)
global i;
global xleft
global xright;
i = i + 1;
Values = EPOCommunications('transmit','Sd');

A = regexp(Values, '\d*', 'Match');

%if i==10:
%    i=1
%else
%end


%distance(i,:)=[str2double(A(1)) str2double(A(2))]



Left = str2double(A(1));
Right = str2double(A(2));
xleft = [xleft Left];   % clear for every run
xright = [xright Right];    % clear for every run
save('data300cm_50cm.mat', 'xleft', 'xright');
min = min(Left, Right);

if Ytest_pred==1
    disp("Command Ready was given")
    dummy=1;
    EPOCommunications('transmit', 'B5000');
    % set the bit frequency
    EPOCommunications('transmit', 'F15000');
    % set the carrier frequency
    EPOCommunications('transmit', 'R2500');
    % set the repetition count
    EPOCommunications('transmit', 'C0xaa55aa55');
    % set the audio code
    EPOCommunications('transmit', 'A1');
    % switch on audio beacon
    pause(1);
    EPOCommunications('transmit', 'A0'); 
end

if dummy==1
    if Ytest_pred==2
        dummy2=1;
        disp("Command Go was given")
        dir = 1;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M165');   % speed
        %start counting from here 
        %here needs work
    end
    if dummy2==1
        if Ytest_pred==3
            disp("Command Stop was given")
            if (Left <= 50 || Right <= 50) && u <= 0.3
                EPOCommunications('transmit','M135');   % speed
                EPOCommunications('transmit','D150');   % direction
                EPOCommunications('transmit','M150');
                %stop with counting    
            end                                                              %here needs work
        end
    else
        disp("Command Stop was given, but neither Go has yet to been given")
    end
else
    if Ytest_pred==2
        disp("Command Go was given, but Ready has not yet been given")
    elseif Ytest_pred==3
        disp("Command Stop was given, but neither Ready or Go has yet to been given")
    end
end


save('Distance.mat', 'DistanceR', 'DistanceL')
save('prevDistance.mat', 'prevR', 'prevL')
save('Values', 'Values')
end

function ergoTimerCleanup(mTimer,~)
disp('Stop')
delete(mTimer)
end