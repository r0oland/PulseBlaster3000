% 
classdef PulseBlaster < BaseHardwareClass
  % general trigger settings
  properties
    classId char = '[Trigger]';
    prf(1,1) {mustBeInteger,mustBeNonnegative,mustBeFinite} = 100; % [HZ]
    trigDuration(1,1) uint32 {mustBeInteger,mustBeNonnegative,mustBeFinite} = 5; % [ns]
    SERIAL_PORT = 'COM4';
    mode char = 'onda32'; % used for compatibility
  end

  % chen trigger settings
  properties
    nPreTrigger(1,1) {mustBeInteger,mustBeNonnegative,mustBeFinite} = 1; %
    postAcqDelay(1,1) {mustBeInteger,mustBeNonnegative,mustBeFinite} = 100; % [us]
    camTrigDelay(1,1) {mustBeInteger,mustBeNonnegative,mustBeFinite} = 0; % [us]
    aodTrigger(1,1) {mustBeInteger,mustBeNonnegative,mustBeFinite} = 9; 
    % number of AOD triggers per camera trigger  

    daqDelay(1,1) uint32 {mustBeInteger,mustBeNonnegative,mustBeFinite} = 3;
    camWait(1,1) uint32 {mustBeInteger,mustBeNonnegative,mustBeFinite} = 4;
    nBaselineWait(1,1) uint32 {mustBeInteger,mustBeNonnegative,mustBeFinite} = 20;
    nRecordLength(1,1) uint32 {mustBeInteger,mustBeNonnegative,mustBeFinite} = 40;
    nCycleLength(1,1) uint32 {mustBeInteger,mustBeNonnegative,mustBeFinite} = 80;
  end

  % depended properties are calculated from other properties
  properties (Dependent = true)
    bytesAvailable(1,1) {mustBeNumeric}; % [counts] current stage position, read from quad encoder
    samplingPeriod(1,1) uint16 {mustBeInteger,mustBeNonnegative};
    slowSampling(1,1); % sets samplingPeriod in us or ms
  end

  % things we don't want to accidently change but that still might be interesting
  properties (SetAccess = private, Transient = true)
    serialPtr = []; % pointer to serial port (we are using MEX Serial instead)
    isConnected = false;
  end

  properties (SetAccess = private, Transient = true)
    lastTrigCount(1,1) {mustBeNumeric,mustBeNonnegative,mustBeFinite};
  end

  % things we don't want to accidently change but that still might be interesting
  properties (Constant)
    % serial properties
    BAUD_RATE = 9600;

    DO_AUTO_CONNECT = true; % connect when object is initialized?
    MAX_BYTE_PER_READ = 4096; % we can read this many bytes over serial at once

    %% Comands shared with teensy_lib.h ----------------------------------------
    DO_NOTHING = uint16(91);
    SET_TRIGGER_CH = uint16(11);
    ENABLE_SCOPE = uint16(12);
    ENABLE_CASCADE = uint16(13);
    STOP_TRIGGER = PulseBlaster.DO_NOTHING;
    STOP_SCOPE = PulseBlaster.DO_NOTHING;
    STOP_CASCADE = PulseBlaster.DO_NOTHING;
    CHECK_CONNECTION = uint16(97);

    %% chen specific commands
    ENABLE_LMI_MODE = uint16(66);
    DISABLE_LMI_MODE = uint16(67);
    ENABLE_CHEN_CASCADE = uint16(68);
    DISABLE_CHEN_CASCADE = uint16(69);

    %% Responses shared with teensy_lib.h -------------------------------------
    TRIGGER_STARTED = uint16(18);
    CASCADE_STARTED = uint16(19);
    READY_FOR_COMMAND = uint16(98);
    DONE = uint16(99);
  end

  % same as constant but now showing up as property
  properties (Hidden=true)
  end


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % constructor, desctructor, save obj
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods
    % constructor, called when class is created
    function Obj = PulseBlaster(doConnect)
      if nargin < 1
        doConnect = Obj.DO_AUTO_CONNECT;
      end

      if nargin == 1 && ischar(doConnect)
        Obj.SERIAL_PORT = doConnect;
        doConnect = true;
      end

      if doConnect && ~Obj.isConnected
        Obj.Connect;
      elseif ~Obj.isConnected
        Obj.VPrintF('[Blaster] Initialized but not connected yet.\n');
      end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function delete(Obj)
      if ~isempty(Obj.serialPtr) && Obj.isConnected
        Obj.Close();
      end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % when saved, hand over only properties stored in saveObj
    function SaveObj = saveobj(Obj)
      SaveObj = PulseBlaster.empty; % see class def for info
    end
  end


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods % short methods, which are not worth putting in a file

    function [] = Write_16Bit(Obj,data)
      Obj.Write_Command(data); % same as command, but lets not confuse our users...
    end

    function [] = Enable_Trigger(Obj)
      Obj.Setup_Trigger();

      if Obj.Wait_Done()
        Obj.Done();
        tic;
        Obj.VPrintF('[Blaster] Enabling trigger board...');
        Obj.Write_Command(Obj.DO_TRIGGER);
        Obj.Done();
      else
        Obj.Verbose_Warn('[Blaster] Trigger enable failed!\n');
      end
    end

    function [] = Disable_Trigger(Obj)
      tic;
      Obj.VPrintF('[Blaster] Disabling trigger board...');
      Obj.Write_Command(Obj.STOP_TRIGGER);
      Obj.Done();
    end

    function [] = Update_Trigger(Obj)
      Obj.Disable_Trigger();
      Obj.Enable_Trigger();
    end

    function [] = Flush_Serial(Obj)
      tic;
      nBytes = Obj.bytesAvailable;
      if nBytes
        Obj.VPrintF('[Blaster] Flushing %i serial port bytes...',nBytes);
        for iByte = 1:nBytes
          [~] = readPort(Obj.serialPtr, 1);
        end
        Obj.Done();
      end
    end

    % --------------------------------------------------------------------------
    function [slowSampling] = get.slowSampling(Obj)
      if Obj.prf > 20
        % samplingPeriod in us
        slowSampling = false;
      else
        % samplingPeriod in ms
        slowSampling = true;
      end
    end
    % --------------------------------------------------------------------------
    function [samplingPeriod] = get.samplingPeriod(Obj)
      if Obj.slowSampling
        % samplingPeriod in ms
        samplingPeriod = uint16(1./Obj.prf*1e3);
      else
        % samplingPeriod in us
        samplingPeriod = uint16(1./Obj.prf*1e6);
      end
    end

  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods (Access = private)
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods % set / get methods
    function [bytesAvailable] = get.bytesAvailable(Obj)
      if Obj.isConnected
        numBytesToRead = 0;
        [~ , bytesAvailable] = readPort(Obj.serialPtr, numBytesToRead);
      else
        bytesAvailable = [];
      end
    end
  end % <<<<<<<< END SET?GET METHODS

end % <<<<<<<< END BASE CLASS
