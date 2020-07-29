% make sure we have all folders and subfolders added to matlab path
scriptPath = mfilename('fullpath');
folderPath = fileparts(scriptPath);
addpath(genpath(folderPath));

% remove git folder if one exists...
if isfolder('.git')
  rmpath('.git');
end
clear;

if ~exist('PB') %#ok<*EXIST>
  PB = PulseBlaster(false); % create PB object, don't connect yet
  PB.SERIAL_PORT = 'COM5'; % change from default com port
  PB.Connect(); % now connect via serial
end

% has two modes, free-running and cascade
% free-running:
PB.prf = 500; % [HZ]
      
PB.Enable_LMI_Mode();
pause(0.5);
PB.Disable_LMI_Mode();

PB.Enable_Chen_Cascade();
pause(0.5);
PB.Disable_Chen_Cascade();

PB.prf = 10000; % [Hz]
PB.trigDuration = 5000; % [ns] trigger on time
PB.Enable_Scope(0);
% PB.Disable_Scope();
