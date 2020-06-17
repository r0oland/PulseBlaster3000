% 
classdef PulseBlaster < BaseHardwareClass
  % general trigger settings
  properties
    prf(1,1) {mustBeInteger,mustBeNonnegative,mustBeFinite} = 100; % [HZ]
    trigDuration(1,1) uint32 {mustBeInteger,mustBeNonnegative,mustBeFinite} = 5; % [ns]
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

    SERIAL_PORT = 'COM4';
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

    %% Comands shared with teensy_lib.h
    DO_NOTHING = uint16(00);

    SET_TRIGGER_CH = uint16(11);
    ENABLE_SCOPE = uint16(12);
    % TODO - same as scope, but triggered externally...
    ENABLE_CASCADE = uint16(13);
    TRIGGER_STARTED = uint16(18);
    DISABLE_TRIGGER = uint16(19);

    % chen specific commands
    ENABLE_CHEN_SCOPE = uint16(66);
    DISABLE_CHEN_SCOPE = uint16(67);
    ENABLE_CHEN_CASCADE = uint16(68);
    DISABLE_CHEN_CASCADE = uint16(69);

    CHECK_CONNECTION = uint16(97);
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
    function PB = PulseBlaster(doConnect)
      if nargin < 1
        doConnect = PB.DO_AUTO_CONNECT;
      end

      if doConnect && ~PB.isConnected
        PB.Connect;
      elseif ~PB.isConnected
        PB.VPrintF('[Blaster] Initialized but not connected yet.\n');
      end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function delete(PB)
      if ~isempty(PB.serialPtr) && PB.isConnected
        PB.Close();
      end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % when saved, hand over only properties stored in saveObj
    function SaveObj = saveobj(PB)
      SaveObj = CascadeTrigger.empty; % see class def for info
    end
  end


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods % short methods, which are not worth putting in a file

    function [] = Write_16Bit(PB,data)
      PB.Write_Command(data); % same as command, but lets not confuse our users...
    end

    function [] = Enable_Trigger(PB)
      PB.Setup_Trigger();

      if PB.Wait_Done()
        PB.Done();
        tic;
        PB.VPrintF('[Blaster] Enabling trigger board...');
        PB.Write_Command(PB.DO_TRIGGER);
        PB.Done();
      else
        PB.Verbose_Warn('[Blaster] Trigger enable failed!\n');
      end
    end

    function [] = Disable_Trigger(PB)
      tic;
      PB.VPrintF('[Blaster] Disabling trigger board...');
      PB.Write_Command(PB.STOP_TRIGGER);
      PB.Done();
    end

    function [] = Update_Trigger(PB)
      PB.Disable_Trigger();
      PB.Enable_Trigger();
    end

    function [] = Flush_Serial(PB)
      tic;
      nBytes = PB.bytesAvailable;
      if nBytes
        PB.VPrintF('[Blaster] Flushing %i serial port bytes...',nBytes);
        for iByte = 1:nBytes
          [~] = readPort(PB.serialPtr, 1);
        end
        PB.Done();
      end
    end

    % --------------------------------------------------------------------------
    function [slowSampling] = get.slowSampling(PB)
      if PB.prf > 20
        % samplingPeriod in us
        slowSampling = false;
      else
        % samplingPeriod in ms
        slowSampling = true;
      end
    end
    % --------------------------------------------------------------------------
    function [samplingPeriod] = get.samplingPeriod(PB)
      if PB.slowSampling
        % samplingPeriod in ms
        samplingPeriod = uint16(1./PB.prf*1e3);
      else
        % samplingPeriod in us
        samplingPeriod = uint16(1./PB.prf*1e6);
      end
    end

  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods (Access = private)
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods % set / get methods
    function [bytesAvailable] = get.bytesAvailable(PB)
      if PB.isConnected
        numBytesToRead = 0;
        [~ , bytesAvailable] = readPort(PB.serialPtr, numBytesToRead);
      else
        bytesAvailable = [];
      end
    end
  end % <<<<<<<< END SET?GET METHODS

end % <<<<<<<< END BASE CLASS
