function [] = Enable_Chen_Scope(PB)
  PB.Flush_Serial();

  nPreTrigger = uint32(PB.nPreTrigger);
  triggerFreq = uint32(PB.prf);
  nTrigger = uint32(PB.aodTrigger);
  postAcqDelay = uint32(PB.postAcqDelay); % set acq. delay in microseconds
  camTrigDelay = uint32(PB.camTrigDelay); % set delay in nanoseconds?

  PB.PrintF('[Blaster] Enabling free-running trigger @ %2.2fkHz.\n',PB.prf*1e-3);

  % SEND actual data to teensy, DO NOT CHANGE ORDER OF THIS
  PB.Write_Command(PB.ENABLE_CHEN_SCOPE);
  PB.Write_32bit(nPreTrigger);
  PB.Write_32bit(nTrigger);
  PB.Write_32bit(triggerFreq);
  PB.Write_32bit(postAcqDelay);
  PB.Write_32bit(camTrigDelay);

end
