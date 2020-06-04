function [success] = Check_Connection(CT)
   CT.Flush_Serial(); % make sure to get rid of old bytes...
  CT.PrintF('[CT] Checking connection...');
  CT.Write_Command(CT.CHECK_CONNECTION);
  timeOut = 1; % 1 seconds default timeout

  t1 = tic;
  % wait for ready command...
  while (CT.bytesAvailable<2)
    if toc(t1) > timeOut
      CT.Verbose_Warn('Teensy response timeout!\n');
      return;
    end
  end
  CT.PrintF('got answer...');

  [~,answer] = CT.Read_Data(2);
  if answer ~= CT.READY_FOR_COMMAND
    short_warn('[CT] unexpected return value:');
    answer
    error('[CT] Something went wrong in the teensy!');
    success = false;
  else
    success = true;
    CT.PrintF('we are ready to go!\n');
  end
end
