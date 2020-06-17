function [success] = Check_Connection(PB)
  PB.Flush_Serial(); % make sure to get rid of old bytes...
  PB.PrintF('[Blaster] Checking connection...');
  PB.Write_Command(PB.CHECK_CONNECTION);
  timeOut = 1; % 1 seconds default timeout

  t1 = tic;
  % wait for ready command...
  while (PB.bytesAvailable<2)
    if toc(t1) > timeOut
      PB.Verbose_Warn('Teensy response timeout!\n');
      return;
    end
  end
  PB.PrintF('got answer...');

  [~,answer] = PB.Read_Data(2);
  if answer ~= PB.READY_FOR_COMMAND
    short_warn('[Blaster] unexpected return value:');
    answer
    error('[Blaster] Something went wrong in the teensy!');
    success = false;
  else
    success = true;
    PB.PrintF('we are ready to go!\n');
  end
end
