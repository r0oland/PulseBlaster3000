% function [] = Read_Data(PB)
% does something coole...
% Johannes Rebling, (johannesrebling@gmail.com), 2019

function [byteData,twoByteData] = Read_Data(PB,nBytes)
  if nargin == 1
    % no nBytes specified, read "all" available bytes
    nBytes = PB.bytesAvailable();
    % if too many bytes are available, only read max. available bytes
    nBytes = min(nBytes,PB.MAX_BYTE_PER_READ); % make sure we don't try and read to many
  end

  if nBytes > PB.MAX_BYTE_PER_READ
    errMessage = sprintf('Can''t read more than %i bytes at once!',PB.MAX_BYTE_PER_READ);
    error(errMessage);
  end

  % tic();
  % PB.VPrintF('[Blaster] Reading %i bytes of data...',nBytes);
  byteData = readPort(PB.serialPtr, nBytes);

  %% convert to uint16 again
  twoByteData = typecast(byteData,'uint16');

  % PB.Done();
end
