if ~exist('PB') %#ok<*EXIST>
  PB = PulseBlaster(false); % create PB object, don't connect yet
  PB.SERIAL_PORT = 'COM4'; % change from default com port
  PB.Connect(); % now connect via serial
end

% has two modes, free-running and cascade
% free-running:
PB.prf = 500; % [HZ]
PB.nPreTrigger = 1; 
PB.postAcqDelay = 100; % [us]
PB.aodTrigger = 9; 
      
PB.Enable_Chen_Scope();
pause(1);
PB.Disable_Chen_Scope();
      
PB.Enable_Chen_Cascade();
pause(1);
PB.Disable_Chen_Cascade();