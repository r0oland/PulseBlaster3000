if ~exist('PB') %#ok<*EXIST>
  PB = PulseBlaster(false); % create PB object, don't connect yet
  PB.SERIAL_PORT = 'COM4'; % change from default com port
  PB.Connect(); % now connect via serial
end

PB.Enable_Cascade_Mode(); % puts trigger board in trigger mode, where it waits
PB.Disable_Cascade_Mode(); % disables trigger mode
