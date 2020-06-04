p = genpath([pwd '\Matlab\']);
addpath(p);

if ~exist('CT') %#ok<*EXIST>
    CT = CascadeTriggerChen();% initialize the trigger device
                           % if the device couldn't be connected, change
                           % the COM port number in "CascadeTriggerChen"
                           % function.
end
%%
% NOTE all values must be positive integers,uint32 integers, i.e. allowed range
% is 0 to 4,294,967,295


% CT.Disable_Scope_Mode();
CT.nPreTrigger = 1;
CT.preTriggerPrf =  90; %[Hz] --------same as the scanning rate of AOD -----------
CT.prf = 90; % ------------set pulse repetitation or AOD scanning frequency---------
CT.aodTrigger = 9;% ----------set the devider, camera frame rate = prf/aodTrigger -----
CT.postAcqDelay = 10; % set the delay after one camera frame 
CT.camTrigDelay = 9; % set the delay between AOD and camera trigger in us!
CT.Enable_Scope_Mode();% start triggeringcl


pause(20); %------- set the triggering time duration -------------
CT.Disable_Scope_Mode();% stop triggering 









