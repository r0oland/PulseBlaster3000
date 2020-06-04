CT = CascadeTriggerChen();

% NOTE all values must be positive integers,uint32 integers, i.e. allowed range
% is 0 to 4,294,967,295
CT.daqDelay = 3; % [us] delay between laser trigger and daq triggering
CT.trigDuration = 5; % [us] trigger on duration, used for all trigger signals
CT.camWait = 4; % trigger cam every n-shots
CT.nBaselineWait = 20; % start stimulus after this many shots
CT.nRecordLength = 40; % record data (trigger daq + cam) for this many shots
CT.nCycleLength = 80; % repeat whole cycle after this many shots

CT.Enable_Cascade_Mode(); % puts trigger board in trigger mode, where it waits
  % for trigger input

CT.Disable_Cascade_Mode(); % disables trigger mode
