% 
classdef PulseBlaster < BaseHardwareClass
  properties
    prf(1,1) {mustBeNumeric,mustBeNonnegative,mustBeFinite} = 100;
    mode(1,:) char = 'us'; % set function ensures only valid modes are used!
  end

  properties
    % chen trigger specific properties
    nPreTrigger(1,1) {mustBeInteger,mustBeNonnegative,mustBeFinite} = 1; %
    postAcqDelay(1,1) {mustBeInteger,mustBeNonnegative,mustBeFinite} = 100; % [us]
    camTrigDelay(1,1) {mustBeInteger,mustBeNonnegative,mustBeFinite} = 0; % [us]
    aodTrigger(1,1) {mustBeInteger,mustBeNonnegative,mustBeFinite} = 9; 
      % number of AOD triggers per camera trigger  

    daqDelay(1,1) uint32 {mustBeInteger,mustBeNonnegative,mustBeFinite} = 3;
    trigDuration(1,1) uint32 {mustBeInteger,mustBeNonnegative,mustBeFinite} = 5;
    camWait(1,1) uint32 {mustBeInteger,mustBeNonnegative,mustBeFinite} = 4;
    nBaselineWait(1,1) uint32 {mustBeInteger,mustBeNonnegative,mustBeFinite} = 20;
    nRecordLength(1,1) uint32 {mustBeInteger,mustBeNonnegative,mustBeFinite} = 40;
    nCycleLength(1,1) uint32 {mustBeInteger,mustBeNonnegative,mustBeFinite} = 80;

    SERIAL_PORT = 'COM26';
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

    %% Comands defined in teensy_lib.h

    % define commands %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    DO_NOTHING = uint16(0);
    STOP_TRIGGER = uint16(23);

    SET_TRIGGER_CH = uint16(60);

    ENABLE_INT_TRIGGER = uint16(61);
    ENABLE_CHEN_INT_TRIGGER = uint16(62);
    DISABLE_INT_TRIGGER = uint16(63);

    ENABLE_CASCADE_TRIGGER = uint16(64);
    ENABLE_CHEN_CASCADE_TRIGGER = uint16(65);
    DISABLE_CASCADE_TRIGGER = uint16(66);

    CHECK_CONNECTION = uint16(88);
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
    function CT = PulseBlaster(doConnect)
      if nargin < 1
        doConnect = CT.DO_AUTO_CONNECT;
      end

      if doConnect && ~CT.isConnected
        CT.Connect;
      elseif ~CT.isConnected
        CT.VPrintF('[CT] Initialized but not connected yet.\n');
      end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function delete(CT)
      if ~isempty(CT.serialPtr) && CT.isConnected
        CT.Close();
      end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % when saved, hand over only properties stored in saveObj
    function SaveObj = saveobj(CT)
      SaveObj = CascadeTrigger.empty; % see class def for info
    end
  end


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods % short methods, which are not worth putting in a file



    function [] = Write_16Bit(CT,data)
      CT.Write_Command(data); % same as command, but lets not confuse our users...
    end

    function [] = Enable_Trigger(CT)
      CT.Setup_Trigger();

      if CT.Wait_Done()
        CT.Done();
        tic;
        CT.VPrintF('[CT] Enabling trigger board...');
        CT.Write_Command(CT.DO_TRIGGER);
        CT.Done();
      else
        CT.Verbose_Warn('[CT] Trigger enable failed!\n');
      end
    end

    function [] = Disable_Trigger(CT)
      tic;
      CT.VPrintF('[CT] Disabling trigger board...');
      CT.Write_Command(CT.STOP_TRIGGER);
      CT.Done();
    end

    function [] = Update_Trigger(CT)
      CT.Disable_Trigger();
      CT.Enable_Trigger();
    end

    function [] = Flush_Serial(CT)
      tic;
      nBytes = CT.bytesAvailable;
      if nBytes
        CT.VPrintF('[CT] Flushing %i serial port bytes...',nBytes);
        for iByte = 1:nBytes
          [~] = readPort(CT.serialPtr, 1);
        end
        CT.Done();
      end
    end

    % --------------------------------------------------------------------------
    function [slowSampling] = get.slowSampling(CT)
      if CT.prf > 20
        % samplingPeriod in us
        slowSampling = false;
      else
        % samplingPeriod in ms
        slowSampling = true;
      end
    end
    % --------------------------------------------------------------------------
    function [samplingPeriod] = get.samplingPeriod(CT)
      if CT.slowSampling
        % samplingPeriod in ms
        samplingPeriod = uint16(1./CT.prf*1e3);
      else
        % samplingPeriod in us
        samplingPeriod = uint16(1./CT.prf*1e6);
      end
    end

  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods (Access = private)
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  methods % set / get methods
    function [bytesAvailable] = get.bytesAvailable(CT)
      if CT.isConnected
        numBytesToRead = 0;
        [~ , bytesAvailable] = readPort(CT.serialPtr, numBytesToRead);
      else
        bytesAvailable = [];
      end
    end
  end % <<<<<<<< END SET?GET METHODS

end % <<<<<<<< END BASE CLASS
