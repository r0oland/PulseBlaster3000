% trigger cascade checks for rising and falling flanks on trigger input
% and sends out trigger cascade for each flank

function [success] = Enable_Cascade(Obj)
  timeOut = 3;
  Obj.Flush_Serial();
  
  Obj.VPrintF_With_ID('Enabling cascade trigger.\n');

  % SEND actual data to teensy, DO NOT CHANGE ORDER OF THIS
  Obj.Write_Command(Obj.ENABLE_CASCADE);

  t1 = tic;
  % wait for ack of trigger starting
  while (Obj.bytesAvailable<2)
    if toc(t1) > timeOut
      Obj.Verbose_Warn('Teensy response timeout!\n');
      Obj.lastTrigCount = 0;
      return;
    end
  end
  [~,answer] = Obj.Read_Data(2);
  if answer ~= Obj.CASCADE_STARTED
    short_warn('[Blaster] unexpected return value:');
    short_warn(sprintf('recieved: %i, expected %i!',answer, Obj.TRIGGER_STARTED));
    error('[Blaster] Something went wrong in the teensy!');
  else
    success = true;
  end


end
