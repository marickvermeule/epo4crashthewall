% EPO4 A2
% Alex Hirsig
% 01.05.2022
load Voice_Recognition_Model_Kais_V_2.mat

Fs=8000;
L=Fs*(20/1000);
ov=L*(1/2);
threshold=0.01;
%port = input("Which COM port is used?");
%com = int2str(port);
com = '11';     % 02.05.2022
P = ['\\.\COM', com];
comport = P; % the actual COM port
% to use varies.
result = EPOCommunications('open',comport);
% open connection.

%DistanceR = 100;
rec = 0;
%dir = 0;    % Default direction = stillstand
global x;
global t;
global stopCar;
global xleft;
global xright;
stopCar = 0;
% global tim;
global velocity;
x = input("Where should the car stop (distacne in cm)?")

% convert x into the value that is needed for breaking (control loop)

% Next 4 lines are to give the speed by kexboard input:
velocity = input("how fast should the car go (0-10)?")
speed = 155+velocity;
s = int2str(speed);
signal = ['M', s];

% Loop that runs until it gets a 'ready'
while true
[~,~,button]=ginput(1);
if button==114
    recObj = audiorecorder(Fs,16,1); % create audio object, 16 bits resolution
    disp('Start speaking...')
    recordblocking(recObj, 1); % do a 2 second recording (blocking)
    disp('End of Recording.');
    y = getaudiodata(recObj); %supposed to be 16000x1 vector  
    x_test=ExtractFeat(y,Fs,L,ov,threshold);
    % standard normalize 
    x_test=(x_test-mu_train)./sigma_train;
    % predic
    Ytest_pred_str = model.predict(x_test);
    Ytest_pred = str2double(Ytest_pred_str);    % 1, 2, 3 dependent on what is recorded
end
if Ytest_pred==1
    disp("Command Ready was given")% if "ready" we can start the program
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
    break
elseif Ytest_pred==2
    disp("Command Go was given, but Command Ready has yet to be given")
elseif Ytest_pred==3
    disp("Command Stop was given, but Command Ready has yet to be given")
end
end

% When ready is given, loop that runs until go is given (with option to
% give stop already)
while true
    [~,~,button]=ginput(1);
    if button==114
        recObj = audiorecorder(Fs,16,1); % create audio object, 16 bits resolution
        disp('Start speaking...')
        recordblocking(recObj, 1); % do a 2 second recording (blocking)
        disp('End of Recording.');
        y = getaudiodata(recObj); %supposed to be 16000x1 vector  
        x_test=ExtractFeat(y,Fs,L,ov,threshold);
        % standard normalize 
        x_test=(x_test-mu_train)./sigma_train;
        % predic
        Ytest_pred_str = model.predict(x_test);
        Ytest_pred = str2double(Ytest_pred_str);    % 1, 2, 3 dependent on what is recorded
    end

    % To receive a go signal from a recording: Drive forwards, start the
    % timer & exit the loop
    if Ytest_pred == 2
        disp("Command Go was Given")
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit',signal);   % speed
        tic
        break
    elseif Ytest_pred == 1
        disp("Command Ready was given, but the Command has already been issued")
    elseif Ytest_pred == 3
        disp("Command Stop was given, but the Command Go has yet to been given")
    end
end
    
% % TIMER
% t = createErgoTimer;
% start(t)
% %disp('Check for input:')

% To receive a stop signal from a recording
while stopCar == 0
    [~,~,button]=ginput(1);
    tic
    if button==114
        % Stop timer to allow the recording to work uniterrupted from the
        % timer (if this is needed)
        %rec = 1
        %stop(t)    % stop the timer
        recObj = audiorecorder(Fs,16,1); % create audio object, 16 bits resolution
        disp('Start speaking...')
        recordblocking(recObj, 1); % do a 2 second recording (blocking)
        disp('End of Recording.');
        y = getaudiodata(recObj); %supposed to be 16000x1 vector  
        x_test=ExtractFeat(y,Fs,L,ov,threshold);
        % standard normalize 
        x_test=(x_test-mu_train)./sigma_train;
        % predic
        Ytest_pred_str = model.predict(x_test);
        Ytest_pred = str2double(Ytest_pred_str);    % 1, 2, 3 dependent on what is recorded
    end
    toc
    if Ytest_pred == 3
        disp("Command Stop was given")
        stopCar = 1;
    elseif Ytest_pred == 2
        disp("Command Go was given, but the Command Go has already been issued")
        stopCar = 1;
    elseif Ytest_pred == 1
        disp("Command Ready was given,but the Command Ready has already been issued")
        stopCar = 1;
    end
end

% Restart timer (in case it is stoped to record a stop):
% if rec == 1
%     start(t)
% end
% while true
% end
% Not sure if anything is needed here to prevent the stop of the timer (I
% think not)

% stop(t)
%status = EPOCommunications('close',comport);
% close connection.

% TIMER
t = createErgoTimer;
start(t)
%disp('Check for input:')

function t = createErgoTimer()
global x;
global stopCar;
global t;
% global tim;
t = timer;
%t.StartFcn = @ergoTimerStart;
t.TimerFcn = @takeBreak;
t.StopFcn = @ergoTimerCleanup;

% 10 minutes between breaks + 119 second break
t.Period = 0.01; % can be changed
% time till first break
t.StartDelay = 0; 

% Number of breaks during 8-hr period
t.TasksToExecute = ceil(1000);
t.ExecutionMode = 'fixedSpacing';
end 

%function ergoTimerStart(mTimer,~)
%disp("Start")
%end

function takeBreak(mTimer,~)
global x;
global velocity;
global stopCar;
global t;
global xleft;
global xright;
% global tim;

Values = EPOCommunications('transmit','Sd');
A = regexp(Values, '\d*', 'Match');

% Output (to GUI):
 Left = str2double(A(1));
 Right = str2double(A(2));
 xleft = [xleft Left];
 xright = [xright Right];
 save('xleft');
 save('xright');
% tim = str2double(regexp(toc, '\d*', 'Match'));
%disp(toc)


% Breaking:
if stopCar == 1
    % maybe a delay would do for the control of the breaking
    
    %87 cm stopping distance, velocit 1, 100+95+velocity cm given
    %35 cm stopping distance, velocit 1, 50+95+velocity cm given
    %140 cm stopping distance, velocit 1, 150+95+velocity cm given
    %23 cm stopping distance, velocit 1,    30+95+velocity cm given
    %33 cm stopping distance, velocit 1,    40+95+velocity cm given
    
    
    
    
    
    if x>=30 && x<=40
            if Left <= x+15+80-(velocity) || Right <= x+15+80-(velocity)
            EPOCommunications('transmit','D150');   % direction
            EPOCommunications('transmit','M150');   % speed
            toc
            pause(1);
            stop(t);
            status = EPOCommunications('close',comport);
            elseif Left <= x+80+13+velocity || Right <= x+80+13+velocity
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M135');   % speed
        disp("back");
       end
    else
        if Left <= x+20+80-(velocity) || Right <= x+20+80-(velocity)    % where we stop actively breaking and just stop the wheels: this is depedndent on the control system
            EPOCommunications('transmit','D150');   % direction
            EPOCommunications('transmit','M150');   % speed
            toc
            pause(1);
            stop(t);
            status = EPOCommunications('close',comport);
    elseif Left <= x+80+18+velocity || Right <= x+80+18+velocity
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M135');   % speed
        disp("back");
       end
    end
end

end

function ergoTimerCleanup(mTimer,~)
delete(mTimer)
%stop(t)
status = EPOCommunications('close',comport);
end