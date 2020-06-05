% function [] = Enable_Scope_Mode(AQ)
% Johannes Rebling, (johannesrebling@gmail.com), 2019

function [] = Enable_Scope_Mode(CT)
  nPreTrigger = uint32(CT.nPreTrigger);
  triggerFreq = uint32(CT.prf);
  nTrigger = uint32(CT.aodTrigger);
  postAcqDelay = uint32(CT.postAcqDelay); % set acq. delay in microseconds
  camTrigDelay = uint32(CT.camTrigDelay); % set delay in nanoseconds?

  CT.PrintF('[CT] Enabling free-running trigger @ %2.2fkHz.\n',CT.prf*1e-3);

  % SEND actual data to teensy, DO NOT CHANGE ORDER OF THIS
  CT.Write_Command(CT.ENABLE_SCOPE_MODE);
  CT.Write_32bit(nPreTrigger);
  CT.Write_32bit(nTrigger);
  CT.Write_32bit(triggerFreq);
  CT.Write_32bit(postAcqDelay);
  CT.Write_32bit(camTrigDelay);

end
