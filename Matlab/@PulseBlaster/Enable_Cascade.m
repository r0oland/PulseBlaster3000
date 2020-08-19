function [success] = Enable_Cascade(PB,nTrigger)
  timeOut = 3;
  PB.Flush_Serial();
  
  PB.VPrintF_With_ID('Enabling cascade trigger.\n');

  % SEND actual data to teensy, DO NOT CHANGE ORDER OF THIS
  PB.Write_Command(PB.ENABLE_CASCADE);

  t1 = tic;
  % wait for ack of trigger starting
  while (PB.bytesAvailable<2)
    if toc(t1) > timeOut
      PB.Verbose_Warn('Teensy response timeout!\n');
      PB.lastTrigCount = 0;
      return;
    end
  end
  [~,answer] = PB.Read_Data(2);
  if answer ~= PB.CASCADE_STARTED
    short_warn('[Blaster] unexpected return value:');
    short_warn(sprintf('recieved: %i, expected %i!',answer, PB.TRIGGER_STARTED));
    error('[Blaster] Something went wrong in the teensy!');
  else
    success = true;
  end


end
