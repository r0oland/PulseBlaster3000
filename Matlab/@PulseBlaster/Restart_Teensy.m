% function [] = Update_Code(AQ)
% does something coole...
% Johannes Rebling, (johannesrebling@gmail.com), 2019

function [] = Restart_Teensy(Obj)
  Obj.PrintF('Restarting microcontroller, this takes a few seconds...\n');
  if Obj.isConnected
    Obj.Close();
  end
  cmd1 = sprintf('$port= new-Object System.IO.Ports.SerialPort %s,134,None,8,one',...
    Obj.SERIAL_PORT);
  cmd2 = '$port.open()';
  cmd3 = '$port.Close()';
  fullCmd = sprintf('powershell %s; %s; %s',cmd1, cmd2, cmd3);

  [status] = system(fullCmd); % sends restart command
  pause(0.25); % give matlab a chance to check what is going on, i.e. port is missing

  waitForPort = true;
  while(waitForPort)
    availPorts = serialportlist();
    if ~isempty(availPorts) && contains(availPorts,Obj.SERIAL_PORT)
      waitForPort = false;
    else
      waitForPort = true;
      pause(0.1); % don't run this while loop at full speed
    end
  end
  Obj.Connect();

  if status
    Obj.PrintF('\n\n');
    short_warn('Restart failed:');
  else
    Obj.PrintF('Microcontroller restarted successfully!\n');
  end

end


