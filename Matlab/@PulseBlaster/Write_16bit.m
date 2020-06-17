function [] = Write_16bit(CT,data)
  if ~isa(data,'uint16')
    error('Counter datas must be uint16!');
  end
  data = typecast(data, 'uint8'); % datas send as 2 byte
  CT.Write_Data(data);
end
