function [] = Write_Command(CT,command)
  if ~isa(command,'uint16')
    error('Counter commands must be uint16!');
  end
  command = typecast(command, 'uint8'); % commands send as 2 byte
  CT.Write_Data(command);
end
