% function [] = Write_Data(CT)
% does something coole...
% Johannes Rebling, (johannesrebling@gmail.com), 2019

function [] = Write_Data(CT,data)
  if CT.isConnected
    tic();
    % CT.VPrintF('[CT] Writing %i bytes of data...',numel(data));
    if ~isa(data,'uint8')
      CT.Verbose_Warn('   Data converted to uint8!');
      data = uint8(data);
    end
    writePort(CT.serialPtr,data);
    % CT.Done();
  else
    CT.Verbose_Warn('Need to connect to Teensy before sening data!\n');
  end
end
