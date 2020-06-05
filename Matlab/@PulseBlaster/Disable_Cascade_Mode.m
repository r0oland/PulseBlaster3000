% function [] = Disable_Scope_Mode(AQ)
% Johannes Rebling, (johannesrebling@gmail.com), 2019

function [] = Disable_Cascade_Mode(CT,timeOut)
  if nargin == 1
    timeOut = 1; % 5 seconds default timeout
  end

  % starts recording of the calibration data in the teensy
  CT.PrintF('[CT] Disabling scope trigger\n');
  CT.Write_Command(CT.DISABLE_CASCADE_TRIGGER);
  CT.Wait_Done(timeOut);
  % wait for data to come in...
  t1 = tic();
  while (CT.bytesAvailable<4)
    if toc(t1) > timeOut
      CT.Verbose_Warn('Teensy response timeout!\n');
      CT.lastTrigCount = 0;
      return;
    end
  end
  [byteData,twoByteData] = CT.Read_Data(4); % get 32 bit trigger counter value
  CT.lastTrigCount = double(typecast(byteData,'uint32'));

  t1 = tic();
  while (CT.bytesAvailable<4)
    if toc(t1) > timeOut
      CT.Verbose_Warn('Teensy response timeout!\n');
      return;
    end
  end
  [byteData,twoByteData] = CT.Read_Data(4); % get 32 bit trigger counter value
  cycleCount = double(typecast(byteData,'uint32'));

  CT.VPrintF('[CT] Triggered %i times (%i cycles)!\n',CT.lastTrigCount,cycleCount);
end
