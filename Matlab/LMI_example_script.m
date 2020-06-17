p = genpath(pwd);
addpath(p);

if ~exist('PB') %#ok<*EXIST>
  PB = PulseBlaster(false); % create PB object, don't connect yet
  PB.SERIAL_PORT = 'COM4'; % change from default com port
  PB.Connect(); % now connect via serial
end

% NOTE all values must 32-bit, unsigned integers, i.e. allowed range
% is 0 to 4,294,967,295

% PB.Disable_Scope_Mode();
PB.nPreTrigger = 1;
PB.prf = 90;              % [Hz] set pulse repetitation or AOD scanning frequency
PB.aodTrigger = 9;          % set the devider, camera frame rate = prf/aodTrigge
PB.postAcqDelay = 1000;     % [us] set the delay after one camera frame 
PB.camTrigDelay = 900;      % [us] set the delay between AOD and camera trigger
PB.Enable_Scope_Mode();     % start triggering

% pause(20); %------- set the triggering time duration -------------
% PB.Disable_Scope_Mode(); % stop triggering 









