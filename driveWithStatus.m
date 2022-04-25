% EPO4 A2
% Alex Hirsig
% 25.04.2022

comport = '\\.\COM3'; % the actual COM port
% to use varies.
result = EPOCommunications('open',comport);
% open connection.

dir = 0;    % Default direction = stillstand

t = createErgoTimer;
start(t)
disp('Check for input:')

while true
[~,~,button]=ginput(1);
if button == 113    % quit the program
    break
end
if dir == 0     % stillstand
   if button == 30   % go forwards
        dir = 1;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M160');   % speed
   elseif button == 31   % go backwards
        dir = 2;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M140');   % speed
   elseif button == 28   % go left
        dir = 3;
        EPOCommunications('transmit','D140');   % direction
        EPOCommunications('transmit','M150');   % speed
   elseif button == 29   % go right
        dir = 4;
        EPOCommunications('transmit','D160');   % direction
        EPOCommunications('transmit','M150');   % speed
   end;
elseif dir == 1     % forwards
    if button == 115    % stop
        dir = 0;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 31     % go backwards
        dir = 2;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M140');   % speed
    elseif button == 28   % go left forwards
        dir = 5;
        EPOCommunications('transmit','D140');   % direction
        %EPOCommunications('transmit','M160');   % speed
   elseif button == 29   % go right forwards
        dir = 6;
        EPOCommunications('transmit','D160');   % direction
        %EPOCommunications('transmit','M160');   % speed
    end;
elseif dir == 2     % backwards
    if button == 115    % stop
        dir = 0;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 30     % go forwards
        dir = 1;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M160');   % speed
    elseif button == 28   % go left backwards
        dir = 7;
        EPOCommunications('transmit','D140');   % direction
        %EPOCommunications('transmit','M140');   % speed
   elseif button == 29   % go right backwards
        dir = 8;
        EPOCommunications('transmit','D160');   % direction
        %EPOCommunications('transmit','M140');   % speed
    end;
elseif dir == 3     % Left stillstand
    if button == 115    % stop
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 30     % go left forwards
        dir = 5;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M160');   % speed
    elseif button == 31   % go left backwards
        dir = 7;
        %EPOCommunications('transmit','D140');   % direction
        EPOCommunications('transmit','M140');   % speed
    elseif button == 29   % go to stillstand (1 step to the right from current position)
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        %EPOCommunications('transmit','M140');   % speed
    end;
elseif dir == 4
    if button == 115    % stop
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 30     % go right forwards
        dir = 5;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M160');   % speed
    elseif button == 31   % go right backwards
        dir = 7;
        %EPOCommunications('transmit','D140');   % direction
        EPOCommunications('transmit','M140');   % speed
    elseif button == 28   % go to stillstand (1 step to the left from current position)
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        %EPOCommunications('transmit','M140');   % speed
    end;
elseif dir == 5     % Left forwards
    if button == 115    % stop
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 31     % go left backwards
        dir = 7;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M140');   % speed
   elseif button == 29   % go forwards (1 step to the right from current position)
        dir = 1;
        EPOCommunications('transmit','D150');   % direction
        %EPOCommunications('transmit','M160');   % speed
    end;
elseif dir == 6     % Right forwards
    if button == 115    % stop
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 31     % go right backwards
        dir = 8;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M140');   % speed
    elseif button == 28   % go forwards (1 step to the left from current position)
        dir = 1;
        EPOCommunications('transmit','D150');   % direction
        %EPOCommunications('transmit','M140');   % speed
    end;
 elseif dir == 7    % Left backwards
    if button == 115    % stop
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 30     % go left forwards
        dir = 5;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M160');   % speed
   elseif button == 29   % go backwards (1 step to the right from current state)
        dir = 2;
        EPOCommunications('transmit','D150');   % direction
        %EPOCommunications('transmit','M160');   % speed
    end;
elseif dir == 8     % Right backwards
    if button == 115    % stop
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 30     % go right forwards
        dir = 6;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M160');   % speed
    elseif button == 28   % go backwards (1 step to the left from current state)
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

t = timer;
t.StartFcn = @ergoTimerStart;
t.TimerFcn = @takeBreak;
t.StopFcn = @ergoTimerCleanup;

% 10 minutes between breaks + 30 second break
t.Period = 0.01;

% time till first break
t.StartDelay = 0; 

% Number of breaks during 8-hr period
%t.TasksToExecute = ceil(8*60^2/t.Period);
t.ExecutionMode = 'fixedSpacing';
end 

function ergoTimerStart(mTimer,~)
disp("Start")
end

function takeBreak(mTimer,~)
disp('Status')
EPOCommunications('transmit','S');
end

function ergoTimerCleanup(mTimer,~)
disp('Stop')
delete(mTimer)
end