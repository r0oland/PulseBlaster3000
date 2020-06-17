function [trigOutChMask,triggerOut] = Setup_Trigger(PB)
  PB.VPrintF('[Blaster] Setting trigger channel: ');
  PB.Write_Command(PB.SET_TRIGGER_CH);
  switch PB.mode
    case 'all'
      PB.VPrintF(' all channels...');
      trigMode = PB.ALL_TRIG;
    case 'us'
      PB.VPrintF(' us...');
      trigMode = PB.US_TRIG;
    case 'dye'
      PB.VPrintF(' dye...');
      trigMode = PB.EDGE_TRIG;
    case 'onda32'
      PB.VPrintF(' onda32...');
      trigMode = PB.ONDA_TRIG;
    otherwise
      PB.Verbose_Warn(sprintf('Trigger mode %s not supported. Using US!\n', PB.mode));
      PB.VPrintF(' us...');
      trigMode = PB.US_TRIG;
  end

  PB.Write_Command(trigMode);
  % read back what we just tried to set as a way of error checking
  [~,trigOutChMask] = PB.Read_Data(2); % read trigger out
  [~,triggerOut] = PB.Read_Data(2); % read trigger out
  if triggerOut ~= trigMode
    PB.Verbose_Warn('Setting trigger mode failed!');
  end
  PB.Wait_Done();
  PB.Done();
end
