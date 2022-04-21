% EPO4 A2
% Alex Hirsig
% 21.04.2022

comport = '\\.\COM3'; % the actual COM port
% to use varies.
result = EPOCommunications('open',comport);
% open connection.

% Directions:
%   0   Stillstand
%   1   Forwards
%   2   Backwards
%   3   Left stillstand
%   4   Right stillstand
%   5   Left forwards
%   6   Right forwards
%   7   Left backwards
%   8   Right backwards

% Buttons:
%   30  Forwards
%   31  Backwards
%   28  Left
%   29  Right
%   115 Stop (Stillstand)
%   113 Quit (Close connection)


dir = 0;    % Default direction = stillstand
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
status = EPOCommunications('close',comport);
% close connection.
