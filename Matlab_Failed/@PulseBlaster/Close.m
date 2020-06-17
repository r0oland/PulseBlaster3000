% function [] = Close(VCS)
% does something coole...
% Johannes Rebling, (johannesrebling@gmail.com), 2019

function [] = Close(CT)
  tic;

  if ~isempty(CT.serialPtr) && CT.isConnected
    CT.VPrintF('[CT] Closing connection to counter...');
    closePort(CT.serialPtr);
    CT.serialPtr = [];
    CT.Done();
  else
    CT.VPrintF('[CT] Connection was not open!\n');
  end

end
