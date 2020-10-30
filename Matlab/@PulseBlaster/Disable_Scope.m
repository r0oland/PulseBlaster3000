function [] = Disable_Scope(PB,timeOut)
  if nargin == 1
    timeOut = 3; % 5 seconds default timeout
  end
  PB.Flush_Serial();

  % starts recording of the calibration data in the teensy
  PB.VPrintF_With_ID('Disabling scope: ');
  PB.Write_Command(PB.STOP_TRIGGER);
  PB.Wait_Done(timeOut);
  wait for data to come in...
  t1 = tic();
  while (PB.bytesAvailable<4)
    if toc(t1) > timeOut
      PB.Verbose_Warn('Teensy response timeout!\n');
      PB.lastTrigCount = 0;
      return;
    end
  end
  [byteData,~] = PB.Read_Data(4); % get 32 bit trigger counter value
  PB.lastTrigCount = double(typecast(byteData,'uint32'));
  PB.VPrintF_With_ID('Triggered %i times!\n',PB.lastTrigCount);
end
