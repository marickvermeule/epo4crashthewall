comport = '\\.\COM24'; % the actual COM port
% to use varies.
result = EPOCommunications('open',comport);
% open connection.
Port = serial('COM1');

