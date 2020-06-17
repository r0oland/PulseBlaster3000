function [trigOutChMask] = Setup_Trigger(PB)
  % trigger channels are based on an 8-bit trigger mask
  % if trigger bit = 1, this channel will be triggered

  PB.VPrintF('[CT] Setting trigger channel: ');
  switch PB.mode
    case 'all'
      PB.VPrintF(' all channels...');
      binStr = '11 11 11 11';
    case 'daq'
      PB.VPrintF(' daq...');
      binStr = '10 00 00 00'; % daq only
    case 'us'
      PB.VPrintF(' us...');
      binStr = '11 00 00 00'; % us + daq
    case {'dye','edge'}
      PB.VPrintF(' dye...');
      binStr = '10 00 10 00'; % trigger edge + daq
    case 'onda32'
      PB.VPrintF(' onda32...');
      binStr = '10 01 00 00';
    otherwise
      PB.Verbose_Warn(sprintf('Trigger mode %s not supported!\n', PB.mode));
      binStr = '00000000'; % init zero mask
  end

  % now write the trigger mask, which is defined by the trigger mode
  trigMask = bin2dec(binStr); % converts 0010 to 2
  trigMask = uint16(trigMask); % data/commands send as 2 bytes...

  PB.Write_Command(PB.SET_TRIGGER_CH); % tell teensy we want to program it
  PB.Write_Command(PB.CHECK_CONNECTION);

  pause(0.5);
  while(PB.bytesAvailable)
    [~,trigOutChMask] = PB.Read_Data(2) % read trigger out
  end

  % read back what we just tried to set as a way of error checking
  % [~,trigOutChMask] = PB.Read_Data(2); % read trigger out
  % if trigOutChMask ~= trigMask
  %   PB.Verbose_Warn('Setting trigger mode failed!');
  % end
  % PB.Wait_Done();
  % PB.Done();
end
