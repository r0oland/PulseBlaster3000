function [success] = Enable_Scope(PB,nTrigger)
  timeOut = 3;
  if nargin < 2
    nTrigger = 0; % run indefinately
  end
  PB.Flush_Serial();
  
  freqStr = num2sip(PB.prf);
  PB.VPrintF_With_ID('Enabling scope @ %s.\n',freqStr);

  triggerPeriod = round(1./PB.prf.*1e6); % convert to trigger period in us
  if triggerPeriod < 10
    PB.VPrintF_With_ID('Trigger period very low (%i us)!\n',triggerPeriod);
    PB.VPrintF_With_ID('This will cause inacurate trigger frequency!\n');
  end

  triggerPeriod =  uint32(triggerPeriod);
  trigDuration = uint32(PB.trigDuration); % trigger duration in ns
  nTrigger =  uint32(nTrigger);

  % SEND actual data to teensy, DO NOT CHANGE ORDER OF THIS
  PB.Write_Command(PB.ENABLE_SCOPE);
  PB.Write_32bit(triggerPeriod);
  PB.Write_32bit(trigDuration);
  PB.Write_32bit(nTrigger);

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
  if answer ~= PB.TRIGGER_STARTED
    short_warn('[Blaster] unexpected return value:');
    answer
    error('[Blaster] Something went wrong in the teensy!');
  else
    success = true;
  end


end
