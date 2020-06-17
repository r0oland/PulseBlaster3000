% function [] = Wait_Done(Obj)
% Johannes Rebling, (johannesrebling@gmail.com), 2019

function [success] = Wait_Done(Obj,timeOut)
  success = false;
  if nargin == 1
    timeOut = 3; % 1 seconds default timeout
  end
  t1 = tic;
  % wait for ready command...
  while (Obj.bytesAvailable<2)
    if toc(t1) > timeOut
      Obj.Verbose_Warn('Teensy response timeout!\n');
      return;
    end
  end

  [~,answer] = Obj.Read_Data(2);
  if answer ~= Obj.DONE
    short_warn('[CT] unexpected return value:');
    error('[CT] Something went wrong in the teensy!');
  else
    success = true;
  end
end
