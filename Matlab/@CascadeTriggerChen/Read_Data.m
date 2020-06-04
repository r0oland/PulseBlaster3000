% function [] = Read_Data(CT)
% does something coole...
% Johannes Rebling, (johannesrebling@gmail.com), 2019

function [byteData,twoByteData] = Read_Data(CT,nBytes)
  if nargin == 1
    % no nBytes specified, read "all" available bytes
    nBytes = CT.bytesAvailable();
    % if too many bytes are available, only read max. available bytes
    nBytes = min(nBytes,CT.MAX_BYTE_PER_READ); % make sure we don't try and read to many
  end

  if nBytes > CT.MAX_BYTE_PER_READ
    errMessage = sprintf('Can''t read more than %i bytes at once!',CT.MAX_BYTE_PER_READ);
    error(errMessage);
  end

  % tic();
  % CT.VPrintF('[CT] Reading %i bytes of data...',nBytes);
  byteData = readPort(CT.serialPtr, nBytes);

  %% convert to uint16 again
  twoByteData = typecast(byteData,'uint16');

  % CT.Done();
end
