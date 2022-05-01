% EPO4 A2
% Alex Hirsig
% 01.05.2022

port = input("Which COM port is used?");
com = int2str(port);
P = ['\\.\COM', com];
comport = p; % the actual COM port
% to use varies.
result = EPOCommunications('open',comport);
% open connection.

%DistanceR = 100;
rec = 0;
%dir = 0;    % Default direction = stillstand
global x;
global stop = 0;
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
if Ytest_pred==1        % if "ready" we can start the program
    break
end
end

% When ready is given, loop that runs until go is given (with option to
% give stop already)
while true
    [~,~,button]=ginput(1);
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
    % To get a stop signal from a recording: enable breaking, don't leave
    % teh loop
    if Ytest_pred == 3
        stop = 1;
    end
    % To receive a go signal from a recording: Drive forwards, start the
    % timer & exit the loop
    if Ytest_pred == 2
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit',signal);   % speed
        tic
        break
    end
end
    
% TIMER
t = createErgoTimer;
start(t)
%disp('Check for input:')

% To receive a stop signal from a recording
while stop == 0
    [~,~,button]=ginput(1);
    if button==114
        % Stop timer to allow the recording to work uniterrupted from the
        % timer (if this is needed)
        %rec = 1
        %stop(t)    % stop the timer
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
    if Ytest_pred == 3
        stop = 1;
    end
end

% Restart timer (in case it is stoped to record a stop):
if rec == 1
    start(t)
end

% Not sure if anything is needed here to prevent the stop of the timer (I
% think not)

stop(t)
status = EPOCommunications('close',comport);
% close connection.


function t = createErgoTimer()
global x;
t = timer;
%t.StartFcn = @ergoTimerStart;
t.TimerFcn = @takeBreak;
t.StopFcn = @ergoTimerCleanup;

% 10 minutes between breaks + 119 second break
t.Period = 0.1; % can be changed
% time till first break
t.StartDelay = 0; 

% Number of breaks during 8-hr period
% t.TasksToExecute = ceil(10);
t.ExecutionMode = 'fixedSpacing';
end 

%function ergoTimerStart(mTimer,~)
%disp("Start")
%end

function takeBreak(mTimer,~)
global x;
global velocity;

Values = EPOCommunications('transmit','Sd');
A = regexp(Values, '\d*', 'Match');

% Output (to GUI):
Left = str2double(A(1))
Right = str2double(A(2))

disp(toc)

% Breaking:
if stop == 1
    % maybe a delay would do for the control of the breaking
    if Left <= x-(velocity*fact) || Right <= x-(velocity*fact)    % where we stop actively breaking and just stop the wheels: this is depedndent on the control system
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif Left <= x || Right <= x
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M135');   % speed
    end
end

end

function ergoTimerCleanup(mTimer,~)
delete(mTimer)
end