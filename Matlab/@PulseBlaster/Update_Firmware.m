% function [] = Update_Code(AQ)
% does something coole...
% Johannes Rebling, (johannesrebling@gmail.com), 2019

function [] = Update_Firmware(CT)
  % requires Platformio to be installed and to be added to the system path!
  CT.Hor_Div();
  CT.VPrintF('[CT] Updating teensy code using Platformio\n');
  CT.Close();
  updateScript = 'C:\Code\Cascade_Trigger\board_firmware\TeensyTrigger 2.1\update_code.cmd';
  % updateScript = 'C:\Code\Cascade_Trigger\board_firmware\TeensyTriggerAlone\update_code.cmd';
  [status,cmdout] = system(updateScript,'-echo');
  pause(1); % wait a second for teensy to start back up...
  CT.Connect();
  CT.Hor_Div();
end
