% function [] = Connect(CT)
% Johannes Rebling, (johannesrebling@gmail.com), 2019

function [] = Connect(CT)
  if ~isempty(CT.serialPtr) && CT.isConnected
    CT.VPrintF('[CT] Trigger already connected!\n');
  else
    tic;
    CT.VPrintF('[CT] Connecting to trigger...');
    try
      tic();
      CT.serialPtr = openPort(CT.SERIAL_PORT,CT.BAUD_RATE);
      CT.isConnected = true;
      % read back identifier to make sure we have a working connection
      % TODO
      CT.Done();
    catch ME
      CT.VPrintF('\n');
      CT.SERIAL_PORT
      CT.Verbose_Warn('Opening serial connection failed!\n');
      rethrow(ME);
    end
  end
  CT.Flush_Serial();
end
