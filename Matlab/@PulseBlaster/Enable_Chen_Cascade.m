function [] = Enable_Chen_Cascade(PB)
  PB.Flush_Serial();
  
  daqDelay = uint32(PB.daqDelay);
  trigDuration = uint32(PB.trigDuration);
  camWait = uint32(PB.camWait);
  nBaselineWait = uint32(PB.nBaselineWait);
  nRecordLength = uint32(PB.nRecordLength);
  nCycleLength = uint32(PB.nCycleLength);

  PB.PrintF('[Blaster] Enabling cascade trigger.\n');
  PB.Write_Command(PB.ENABLE_CHEN_CASCADE);
  PB.Write_32bit(daqDelay);
  PB.Write_32bit(trigDuration);
  PB.Write_32bit(camWait);
  PB.Write_32bit(nBaselineWait);
  PB.Write_32bit(nRecordLength);
  PB.Write_32bit(nCycleLength);
end
