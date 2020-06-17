CT = PulseBlaster();

% NOTE all values must be positive integers,uint32 integers, i.e. allowed range
% is 0 to 4,294,967,295
PB.daqDelay = 3; % [us] delay between laser trigger and daq triggering
PB.trigDuration = 5; % [us] trigger on duration, used for all trigger signals
PB.camWait = 4; % trigger cam every n-shots
PB.nBaselineWait = 20; % start stimulus after this many shots
PB.nRecordLength = 40; % record data (trigger daq + cam) for this many shots
PB.nCycleLength = 80; % repeat whole cycle after this many shots

PB.Enable_Cascade_Mode(); % puts trigger board in trigger mode, where it waits
  % for trigger input

PB.Disable_Cascade_Mode(); % disables trigger mode
