function [] = Write_Command(PB,command)
  if ~isa(command,'uint16')
    error('Counter commands must be uint16!');
  end
  command = typecast(command, 'uint8'); % commands send as 2 byte
  PB.Write_Data(command);
end
