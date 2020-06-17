% function [] = Write_Data(PB)
% does something coole...
% Johannes Rebling, (johannesrebling@gmail.com), 2019

function [] = Write_Data(PB,data)
  if PB.isConnected
    tic();
    % PB.VPrintF('[Blaster] Writing %i bytes of data...',numel(data));
    if ~isa(data,'uint8')
      PB.Verbose_Warn('   Data converted to uint8!');
      data = uint8(data);
    end
    writePort(PB.serialPtr,data);
    % PB.Done();
  else
    PB.Verbose_Warn('Need to connect to Teensy before sening data!\n');
  end
end
