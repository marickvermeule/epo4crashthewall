

while true
    [~,~,button]=ginput(1);
    if button == 30   % forward
        if button == 28   % forward left
            EPOCommunications('transmit','D140');   % direction
            EPOCommunications('transmit','M160');   % speed
        elseif button == 29   %forward right
            EPOCommunications('transmit','D160');   % direction
            EPOCommunications('transmit','M160');   % speed
        else % straight forward
            EPOCommunications('transmit','D150');   % direction
            EPOCommunications('transmit','M160');   % speed
            end
        end
    if button == 31   % backwards
        if button == 28   % backwards left
            EPOCommunications('transmit','D140');   % direction
            EPOCommunications('transmit','M140');   % speed
        elseif button == 29   % backwards right
            EPOCommunications('transmit','D160');   % direction
            EPOCommunications('transmit','M140');   % speed
        else % straight backwards
            EPOCommunications('transmit','D150');   % direction
            EPOCommunications('transmit','M140');   % speed
            end
        end
    if button == 115  % stop 's'
        EPOCommunications('transmit','D150');   % direction
        EPOCommunications('transmit','M150');   % speed
    end
    if button == 113  % turn off 'q'
        break
    end
end
    