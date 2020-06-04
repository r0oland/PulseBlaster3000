% function [] = Enable_Scope_Mode(AQ)
% Johannes Rebling, (johannesrebling@gmail.com), 2019

function [] = Enable_Cascade_Mode(CT)
  daqDelay = uint32(CT.daqDelay);
  trigDuration = uint32(CT.trigDuration);
  camWait = uint32(CT.camWait);
  nBaselineWait = uint32(CT.nBaselineWait);
  nRecordLength = uint32(CT.nRecordLength);
  nCycleLength = uint32(CT.nCycleLength);

  CT.PrintF('[CT] Enabling cascade trigger.\n');
  CT.Write_Command(CT.ENABLE_CASCADE_TRIGGER);
  CT.Write_32bit(daqDelay);
  CT.Write_32bit(trigDuration);
  CT.Write_32bit(camWait);
  CT.Write_32bit(nBaselineWait);
  CT.Write_32bit(nRecordLength);
  CT.Write_32bit(nCycleLength);
end
