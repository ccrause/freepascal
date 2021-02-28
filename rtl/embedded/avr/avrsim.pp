{******************************************************************************
Startup code for an avr simulator

******************************************************************************}
unit avrsim;

{$goto on}
{$macro on}

  interface
    var
      OUTPUTREG   : byte absolute $20;
      EXITCODEREG : byte absolute $21;
      HALTREQUEST : byte absolute $22;
      EXCEPTIONJMPZERO : boolean absolute 52;

      // Needed by EEPROM handling code
      SPMCSR : byte absolute $57;  // Store Program Memory Control and Status Register

      EEAR  : word absolute $41;   // EEPROM Address Register
      EEARL : byte absolute $41;   // EEPROM Address Register Low
      EEARH : byte absolute $41+1; // EEPROM Address Register High
      EEDR  : byte absolute $40;   // EEPROM Data Register
      EECR  : byte absolute $3F;   // EEPROM Control Register

    const
      // EECR bits
      EEPM  = 4;  // EEPROM Programming Mode Bits
      EERIE = 3;  // EEPROM Ready Interrupt Enable
      EEMPE = 2;  // EEPROM Master Write Enable
      EEPE  = 1;  // EEPROM Write Enable
      EERE  = 0;  // EEPROM Read Enable

      // Check if EEPROM access is supported by controller
     {$if declared (NVMCTRL) or declared(EECR)}
       procedure writeEEPROMbyte(const EEPROMaddress: pointer; const val: byte); public name 'FPC_WRITE_EEPROM_BYTE';
       function readEEPROMbyte(const EEPROMaddress: pointer): byte; public name 'FPC_READ_EEPROM_BYTE';
     {$endif}

     {$define DOCALL:=call}
    {$define DOJMP:=jmp}

  implementation

    uses
      consoleio, heapmgr, intrinsics;

    procedure PASCALMAIN; external name 'PASCALMAIN';

    procedure _FPC_haltproc; public name '_haltproc'; noreturn;
      begin
        EXITCODEREG:=exitcode;
        HALTREQUEST:=1;
        { really stop }
        while true do
          ;
      end;

    procedure Default_IRQ_handler; public name '_Default_IRQ_handler';noreturn;
      begin
        while true do
          ;
      end;

    var
      _data: record end; external name '__data_start';
      _edata: record end; external name '__data_end';
      _etext: record end; external name '_etext';
      _bss_start: record end; external name '__bss_start';
      _bss_end: record end; external name '__bss_end';
      _stack_top: record end; external name '_stack_top';

    procedure EE_READY_ISR; external name 'EE_READY_ISR'; // Interrupt 1 EEPROM Ready

    procedure _FPC_start; assembler; nostackframe;
      label
        _start;
      asm
        .init
        .globl _start
        jmp _start
        jmp EE_READY_ISR

        {
          all ATMEL MCUs use the same startup code, the details are
          governed by defines
        }
        {$i start.inc}

        .weak EE_READY_ISR
        .set EE_READY_ISR, Default_IRQ_handler
      end;


    function WriteChar(ACh: char; AUserData: pointer): boolean;
      begin
        WriteChar:=true;
        OUTPUTREG:=ord(ACh);
      end;


    function ReadChar(var ACh: char; AUserData: pointer): boolean;
      begin
        ReadChar:=true;
        ACh:=#0;
      end;

    {$if declared (NVMCTRL)}
      {$include avrxmega3_eeprom.inc}
    {$elseif declared(EECR)}
      {$include classicavr_eeprom.inc}
    {$endif}

begin
  EXCEPTIONJMPZERO:=true;
  OpenIO(Input, @WriteChar, @ReadChar, fmInput, nil);
  OpenIO(Output, @WriteChar, @ReadChar, fmOutput, nil);
  OpenIO(ErrOutput, @WriteChar, @ReadChar, fmOutput, nil);
  OpenIO(StdOut, @WriteChar, @ReadChar, fmOutput, nil);
  OpenIO(StdErr, @WriteChar, @ReadChar, fmOutput, nil);
end.
