% Chen Trigger Examples
CT = CascadeTriggerChen();

% has two modes, free-running and cascade
% free-running:
CT.prf = 100; % [HZ]
CT.preTriggerPrf = 100; % [HZ]
CT.nPreTrigger = 1; 
CT.postAcqDelay = 100; % [us]
CT.aodTrigger = 9; 
      
CT.Enable_Scope_Mode();

% CT.Disable_Scope_Mode();