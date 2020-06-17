% function [] = Close(VCS)
% does something coole...
% Johannes Rebling, (johannesrebling@gmail.com), 2019

function [] = Close(PB)
  tic;

  if ~isempty(PB.serialPtr) && PB.isConnected
    PB.VPrintF('[Blaster] Closing connection to counter...');
    closePort(PB.serialPtr);
    PB.serialPtr = [];
    PB.Done();
  else
    PB.VPrintF('[Blaster] Connection was not open!\n');
  end

end
