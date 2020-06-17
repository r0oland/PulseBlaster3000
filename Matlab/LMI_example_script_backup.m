p = genpath('D:\CHEN\CascadeTrigger - Joe\');
addpath(p);

CT = PulseBlaster();% initialize the trigger device
                           % if the device couldn't be connected, change
                           % the COM port number in "PulseBlaster"
                           % function.
%%
% NOTE all values must be positive integers,uint32 integers, i.e. allowed range
% is 0 to 4,294,967,295
PB.Disable_Scope_Mode();
PB.nPreTrigger = 1;
PB.preTriggerPrf =  90000; %[Hz] --------same as the scanning rate of AOD -----------
PB.prf = 90000; % ------------set pulse repetitation or AOD scanning frequency---------
PB.aodTrigger = 9;% ----------set the devider, camera frame rate = prf/aodTrigger -----
PB.postAcqDelay = 0;% set the delay after one camera frame 
PB.Enable_Scope_Mode();% start triggering


pause(20); %------- set the triggering time duration -------------
PB.Disable_Scope_Mode();% stop triggering 









