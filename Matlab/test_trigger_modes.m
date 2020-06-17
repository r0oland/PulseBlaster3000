if ~exist('PB') %#ok<*EXIST>
  PB = PulseBlaster(false); % create PB object, don't connect yet
  PB.SERIAL_PORT = 'COM4'; % change from default com port
  PB.Connect(); % now connect via serial
end

% has two modes, free-running and cascade
% free-running:
PB.prf = 500; % [HZ]
      
PB.Enable_Chen_Scope();
pause(0.5);
PB.Disable_Chen_Scope();

PB.Enable_Chen_Cascade();
PB.Disable_Chen_Cascade();

PB.prf = 10000; % [Hz]
PB.trigDuration = 5000; % [ns] trigger on time
PB.Enable_Scope(0);
% PB.Disable_Scope();
