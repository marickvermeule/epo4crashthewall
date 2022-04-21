dir = 0;
while true
[~,~,button]=ginput(1);
if button == 113
    break
end
if dir == 0
   if button == 30   % forward
        dir = 1;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M160');   % speed
   elseif button == 31   % backwards
        dir = 2;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M140');   % speed
   elseif button == 28   % left
        dir = 3;
        EPOCommunications('transmit','D140');   % direction
        EPOCommunications('transmit','M150');   % speed
   elseif button == 29   % right
        dir = 4;
        EPOCommunications('transmit','D160');   % direction
        EPOCommunications('transmit','M150');   % speed
   end;
elseif dir == 1
    if button == 115
        dir = 0;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 31
        dir = 2;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M140');   % speed
    elseif button == 28   % left
        dir = 5;
        EPOCommunications('transmit','D140');   % direction
        %EPOCommunications('transmit','M160');   % speed
   elseif button == 29   % right
        dir = 6;
        EPOCommunications('transmit','D160');   % direction
        %EPOCommunications('transmit','M160');   % speed
    end;
elseif dir == 2
    if button == 115
        dir = 0;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 30
        dir = 1;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M160');   % speed
    elseif button == 28   % left
        dir = 7;
        EPOCommunications('transmit','D140');   % direction
        %EPOCommunications('transmit','M140');   % speed
   elseif button == 29   % right
        dir = 8;
        EPOCommunications('transmit','D160');   % direction
        %EPOCommunications('transmit','M140');   % speed
    end;
elseif dir == 5
    if button == 115
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 31
        dir = 7;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M140');   % speed
   elseif button == 29   % right
        dir = 1;
        EPOCommunications('transmit','D150');   % direction
        %EPOCommunications('transmit','M160');   % speed
    end;
elseif dir == 6
    if button == 115
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 31
        dir = 8;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M140');   % speed
    elseif button == 28   % left
        dir = 1;
        EPOCommunications('transmit','D150');   % direction
        %EPOCommunications('transmit','M140');   % speed
    end;
 elseif dir == 7
    if button == 115
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 30
        dir = 5;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M160');   % speed
   elseif button == 29   % right
        dir = 2;
        EPOCommunications('transmit','D150');   % direction
        %EPOCommunications('transmit','M160');   % speed
    end;
elseif dir == 8
    if button == 115
        dir = 0;
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    elseif button == 30
        dir = 6;
        %EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M160');   % speed
    elseif button == 28   % left
        dir = 2;
        EPOCommunications('transmit','D150');   % direction
        %EPOCommunications('transmit','M140');   % speed
    end;
end;
end;