% function [] = Update_Code(AQ)
% does something coole...
% Johannes Rebling, (johannesrebling@gmail.com), 2019

function [] = Update_Firmware(Obj)
  % requires Platformio to be installed and to be added to the system path!
  Obj.Hor_Div();
  Obj.PrintF('[CT] Updating teensy code using Platformio:\n');
  Obj.Close();
  matlabPath = pwd;
  cd ..\BoardFirmware\;
  Obj.PrintF('   Compiling and uploading,this might take a few seconds...\n');
  % run power shell, compile and upload using platformio (needs to be correctly installed)
  [status,cmdReturn] = system('powershell platformio run --target upload');
  wasSuccess = ~contains(cmdReturn,'[SUCCESS]');
  if ~wasSuccess || status
    short_warn('Uploading firmware failed:');
    Obj.PrintF('%s',cmdReturn);
  else
    Obj.PrintF('   Uploading firmware was a big success!\n');
  end
  cd(matlabPath); % return to original path
  pause(1); % wait a second for teensy to start back up...
  Obj.Connect();
  Obj.Hor_Div();
end
