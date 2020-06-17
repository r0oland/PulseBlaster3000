% function [] = Connect(PB)
% Johannes Rebling, (johannesrebling@gmail.com), 2019

function [] = Connect(PB)
  if ~isempty(PB.serialPtr) && PB.isConnected
    PB.VPrintF('[Blaster] Trigger already connected!\n');
  else
    tic;
    PB.VPrintF('[Blaster] Connecting to trigger...');
    try
      tic();
      PB.serialPtr = openPort(PB.SERIAL_PORT,PB.BAUD_RATE);
      PB.isConnected = true;
      % read back identifier to make sure we have a working connection
      % TODO
      PB.Done();
    catch ME
      PB.VPrintF('\n');
      PB.SERIAL_PORT
      PB.Verbose_Warn('Opening serial connection failed!\n');
      rethrow(ME);
    end
  end
  PB.Flush_Serial();
end
