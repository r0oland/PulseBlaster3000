% trigger cascade checks for rising and falling flanks on trigger input
% and sends out trigger cascade for each flank

function [success] = Enable_Cascade(Obj,maxPrf)
  timeOut = 3;
  Obj.Flush_Serial();
  
  maxTrigOn = 1./maxPrf*1e6; % trigger period in us
  safeTrigOn = round(maxTrigOn*0.5); % 50% duty cycl trigger length
  trigDuration = uint32(safeTrigOn); 
  Obj.VPrintF_With_ID('Enabling cascade trigger (%i us duration).\n',...
    trigDuration);

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

  % send out trigger duration and such...
  Obj.Write_32bit(uint32(trigDuration));

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
